#ifndef CLIENTROOMMSGTEST_H
#define CLIENTROOMMSGTEST_H

#include "ClientComtestCommon.h"

#include <QObject>
#include <QtTest/QtTest>

class DbusInterfaceWrapper;

class ClientRoomMsgTest : public ClientComTestCommon
{
    Q_OBJECT

public:
    ClientRoomMsgTest();

private slots:
    void initTestCase();

    void sendRoomMsgTest();
    void collectMsgStateChanged(QString msgId, QString jid, int state);

private:
    struct MsgIdJidState
    {
        QString msgId;
        QString jid;
        int state;
    };
    DbusInterfaceWrapper* interfaceMhs_;
    const QString user3jid_;
    QList<MsgIdJidState> stateChangeMsgList_;
};

#endif // CLIENTROOMMSGTEST_H
