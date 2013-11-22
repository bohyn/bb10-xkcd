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

using namespace bb::data;
using namespace bb::cascades;


XkcdProvider::XkcdProvider(QObject *parent)
	: QObject(parent), m_maxId(-1), m_currentId(-1)
{
	m_dataNetMan = new QNetworkAccessManager(this);
	m_imgNetMan = new QNetworkAccessManager(this);

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
