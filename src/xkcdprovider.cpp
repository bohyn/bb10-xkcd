/*
 * xkcdprovider.cpp
 *
 *  Created on: Nov 21, 2013
 *      Author: bohacekm
 */

#include "xkcdprovider.h"

#include <bb/data/JsonDataAccess>
#include <bb/cascades/Image>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QSettings>
#include <QVariantMap>

using namespace bb::data;
using namespace bb::cascades;

#define BOOKMARKS_SETTINGS_KEY "BOOKMARKS"


XkcdProvider::XkcdProvider(QObject *parent)
	: QObject(parent), m_maxId(-1), m_currentId(-1)
{
	m_dataNetMan = new QNetworkAccessManager(this);
	m_imgNetMan = new QNetworkAccessManager(this);
	m_settings = new QSettings(this);

	qRegisterMetaTypeStreamOperators<XkcdBookmarksMap>("XkcdBookmarksMap");

	connect(m_dataNetMan, SIGNAL(finished(QNetworkReply *)), this, SLOT(onDataReplyFinished(QNetworkReply *)));
	connect(m_imgNetMan, SIGNAL(finished(QNetworkReply *)), this, SLOT(onImgReplyFinished(QNetworkReply *)));
}

XkcdProvider::~XkcdProvider()
{
}

QUrl XkcdProvider::getCurrentUrl()
{
	if (m_currentId > 0) {
		return QUrl(QString("http://www.xkcd.com/%1").arg(m_currentId));
	} else {
		return QUrl();
	}
}

QVariantList XkcdProvider::getBookmarks()
{
	QVariantList l;
	XkcdBookmarksMap bookmarks = m_settings->value(BOOKMARKS_SETTINGS_KEY).value<XkcdBookmarksMap>();
	l.reserve(bookmarks.size());
	QMapIterator<int, QString> it(bookmarks);
	it.toBack();
	while (it.hasPrevious()) {
		it.previous();
		QVariantMap m;
		m["comic_id"] = it.key();
		m["comic_title"] = it.value();
		l.append(m);
	}
	return l;
}

void XkcdProvider::loadFirst()
{
	load(1);
}

void XkcdProvider::loadPrevious()
{
	if (m_currentId > 1) {
		load(m_currentId - 1);
	}
}

void XkcdProvider::loadRandom()
{
	if (m_maxId > 0) {
		 int r = double(qrand()) / RAND_MAX * (m_maxId - 1) + 1;
		 load(r);
	}
}

void XkcdProvider::loadNext()
{
	if (m_maxId > 0 && m_currentId < m_maxId) {
		load(m_currentId + 1);
	}
}

void XkcdProvider::loadLast()
{
	load(-1);
}

void XkcdProvider::load(int comic_id)
{
	emit loadStarted();
	QNetworkRequest dataRq(getDataUrl(comic_id));
	m_dataNetMan->get(dataRq);
}

void XkcdProvider::addToBookmarks()
{
	if (m_currentId > 0) {
		XkcdBookmarksMap bookmarks = m_settings->value(BOOKMARKS_SETTINGS_KEY).value<XkcdBookmarksMap>();
		QString comic_title = m_currentData.value("title").toString();
		bookmarks.insert(m_currentId, comic_title);
		QVariant v;
		v.setValue<XkcdBookmarksMap>(bookmarks);
		m_settings->setValue(BOOKMARKS_SETTINGS_KEY, v);
		emit addedToBookmarks(m_currentId, comic_title);
	}
}

void XkcdProvider::removeFromBookmarks(int comic_id)
{
	XkcdBookmarksMap bookmarks = m_settings->value(BOOKMARKS_SETTINGS_KEY).value<XkcdBookmarksMap>();
	if (bookmarks.contains(comic_id)) {
		QString comic_title = bookmarks.take(comic_id);
		QVariant v;
		v.setValue<XkcdBookmarksMap>(bookmarks);
		m_settings->setValue(BOOKMARKS_SETTINGS_KEY, v);
		emit removedFromBookmarks(m_currentId, comic_title);
	}
}

QUrl XkcdProvider::getDataUrl(int comic_id)
{
	if (comic_id < 0) {
		return QUrl("http://www.xkcd.com/info.0.json");
	} else {
		return QUrl(QString::fromLatin1("http://www.xkcd.com/%1/info.0.json").arg(comic_id));
	}
}

void XkcdProvider::onDataReplyFinished(QNetworkReply *reply)
{
	JsonDataAccess jda;
	QVariantMap m = jda.load(reply).toMap();
	reply->deleteLater();
	if (m.contains("img")) {
		m_currentData = m;
		m_currentId = m.value("num").toInt();
		if (m_currentId > m_maxId) {
			m_maxId = m_currentId;
		}
		QNetworkRequest imgRq(QUrl(m.value("img").toString()));
		QNetworkReply *imgRply = m_imgNetMan->get(imgRq);
		connect(imgRply, SIGNAL(downloadProgress(qint64, qint64)), this, SIGNAL(loadProgress(qint64, qint64)));
	}
}

void XkcdProvider::onImgReplyFinished(QNetworkReply *reply)
{
	Image img(reply->readAll());
	reply->deleteLater();
	emit loadCompleted(
		m_currentId,
		m_currentData.value("title").toString(),
		m_currentData.value("alt").toString(),
		img
	);
}
