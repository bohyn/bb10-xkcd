/*
 * xkcdprovider.h
 *
 *  Created on: Nov 21, 2013
 *      Author: bohacekm
 */

#ifndef XKCDPROVIDER_H_
#define XKCDPROVIDER_H_

#include <bb/cascades/Image>

#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include <QUrl>
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;
class QSettings;


typedef QMap<int, QString> XkcdBookmarksMap;
Q_DECLARE_METATYPE(XkcdBookmarksMap);


class XkcdProvider : public QObject {
	Q_OBJECT
public:
	XkcdProvider(QObject *parent=0);
	virtual ~XkcdProvider();
	Q_INVOKABLE int getMaxId() { return m_maxId; }
	Q_INVOKABLE QUrl getCurrentUrl();
	Q_INVOKABLE QVariantList getBookmarks();

public slots:
	void loadFirst();
	void loadPrevious();
	void loadRandom();
	void loadNext();
	void loadLast();
	void load(int comic_id);

	void addToBookmarks();
	void removeFromBookmarks(int comic_id);

signals:
	void loadStarted();
	void loadCompleted(int comic_id, const QString &comic_title, const QString &comic_alt, bb::cascades::Image comic_image);
	void loadError();
	void loadProgress(qint64 bytesReceived, qint64 bytesTotal);

	void addedToBookmarks(int comic_id, const QString &comic_title);
	void removedFromBookmarks(int comic_id, const QString &comic_title);

private:
	int m_maxId;
	int m_currentId;
	QVariantMap m_currentData;
	QNetworkAccessManager *m_dataNetMan;
	QNetworkAccessManager *m_imgNetMan;
	QSettings *m_settings;

	QUrl getDataUrl(int comic_id);

private slots:
	void onDataReplyFinished(QNetworkReply *reply);
	void onImgReplyFinished(QNetworkReply *reply);
};

#endif /* XKCDPROVIDER_H_ */
