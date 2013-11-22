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
#include <QVariantMap>
#include <QString>
#include <QUrl>
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;

class XkcdProvider : public QObject {
	Q_OBJECT
public:
	XkcdProvider(QObject *parent=0);
	virtual ~XkcdProvider();
	Q_INVOKABLE int getMaxId() { return m_maxId; }
	Q_INVOKABLE QUrl getCurrentUrl();

public slots:
	void loadFirst();
	void loadPrevious();
	void loadRandom();
	void loadNext();
	void loadLast();
	void load(int comic_id);

signals:
	void loadStarted();
	void loadCompleted(int comic_id, QString comic_title, QString comic_alt, bb::cascades::Image comic_image);
	void loadError();
	void loadProgress(qint64 bytesReceived, qint64 bytesTotal);

private:
	int m_maxId;
	int m_currentId;
	QVariantMap m_currentData;
	QNetworkAccessManager *m_dataNetMan;
	QNetworkAccessManager *m_imgNetMan;

	QUrl getDataUrl(int comic_id);

private slots:
	void onDataReplyFinished(QNetworkReply *reply);
	void onImgReplyFinished(QNetworkReply *reply);
};

#endif /* XKCDPROVIDER_H_ */
