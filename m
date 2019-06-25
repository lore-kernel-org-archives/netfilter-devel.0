Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3547C48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F597204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbfFYG6K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:58:10 -0400
Received: from a3.inai.de ([88.198.85.195]:40132 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbfFYG6K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 02:58:10 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id CC1C626AF8F2; Tue, 25 Jun 2019 08:58:02 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 75B4D2AFD3F6;
        Tue, 25 Jun 2019 08:57:53 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 3/3] msr: remove msr as it has moved to its own tree
Date:   Tue, 25 Jun 2019 08:57:53 +0200
Message-Id: <20190625065753.31059-3-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625065753.31059-1-jengelh@inai.de>
References: <20190625065753.31059-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Simon Eisenmann <s.eisenmann@kopano.com>

The msr subpackage is now available on its own terms as a separate
project at https://stash.kopano.io/projects/KC/repos/msr and this is
removed from kopanocore.
---
 .gitignore                           |   3 -
 ECtools/msr/Makefile.am              |  23 -
 ECtools/msr/kopano-msr.in            |   8 -
 ECtools/msr/kopano_msr/__init__.py   | 657 ---------------------------
 ECtools/msr/kopano_msr/version.py.in |   1 -
 ECtools/msr/requirements.txt         |   2 -
 ECtools/msr/setup.cfg                |   4 -
 ECtools/msr/setup.py                 |  56 ---
 Makefile.am                          |   3 +-
 configure.ac                         |   3 -
 doc/kopano-msr.8                     | 109 -----
 doc/kopano-msr.cfg.5                 | 190 --------
 installer/linux/Makefile.am          |   2 +-
 installer/linux/msr.cfg              |  63 ---
 14 files changed, 2 insertions(+), 1122 deletions(-)
 delete mode 100644 ECtools/msr/Makefile.am
 delete mode 100644 ECtools/msr/kopano-msr.in
 delete mode 100644 ECtools/msr/kopano_msr/__init__.py
 delete mode 100644 ECtools/msr/kopano_msr/version.py.in
 delete mode 100644 ECtools/msr/requirements.txt
 delete mode 100644 ECtools/msr/setup.cfg
 delete mode 100644 ECtools/msr/setup.py
 delete mode 100644 doc/kopano-msr.8
 delete mode 100644 doc/kopano-msr.cfg.5
 delete mode 100644 installer/linux/msr.cfg

diff --git a/.gitignore b/.gitignore
index e7176f8d3..60baf0a7f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -69,9 +69,6 @@ stamp-h2
 /ECtools/migration-pst/kopano-migration-pst
 /ECtools/migration-pst/kopano_migration_pst/version.py
 /ECtools/migration-pst/staging/
-/ECtools/msr/kopano-msr
-/ECtools/msr/kopano_msr/version.py
-/ECtools/msr/staging/
 /ECtools/presence/build/
 /ECtools/presence/kopano-presence
 /ECtools/presence/kopano_presence/version.py
diff --git a/ECtools/msr/Makefile.am b/ECtools/msr/Makefile.am
deleted file mode 100644
index 158c8d1a0..000000000
--- a/ECtools/msr/Makefile.am
+++ /dev/null
@@ -1,23 +0,0 @@
-dist_sbin_SCRIPTS = kopano-msr
-
-EXTRA_DIST = setup.py		\
-	setup.cfg \
-	kopano_msr/__init__.py
-
-install-exec-local:
-	rm -Rf staging
-	${MKDIR_P} staging
-	cp -a ${srcdir}/setup.py ${srcdir}/setup.cfg ${srcdir}/kopano_msr staging/
-	cp -a kopano_msr/version.py staging/kopano_msr/
-	cd staging/ && ${PYTHON} setup.py \
-		build --build-base="${abs_builddir}/build" \
-		install -f $${DESTDIR+--root=${DESTDIR}} \
-		--prefix="${prefix}" --install-purelib ${pythondir}
-	rm -Rf build
-
-install-data-local:
-	mkdir -p "${DESTDIR}${localstatedir}/lib/kopano/msr"
-
-uninstall-local:
-	rm -Rf ${DESTDIR}${pythondir}/kopano_msr \
-		${DESTDIR}${pythondir}/kopano_msr-*.egg-info
diff --git a/ECtools/msr/kopano-msr.in b/ECtools/msr/kopano-msr.in
deleted file mode 100644
index 701b5fea2..000000000
--- a/ECtools/msr/kopano-msr.in
+++ /dev/null
@@ -1,8 +0,0 @@
-#!@PYTHON@
-# SPDX-License-Identifier: AGPL-3.0-only
-import sys
-import kopano_msr
-from kopano_msr import __version__
-
-if __name__ == '__main__':
-    sys.exit(kopano_msr.main())
diff --git a/ECtools/msr/kopano_msr/__init__.py b/ECtools/msr/kopano_msr/__init__.py
deleted file mode 100644
index 426e55d77..000000000
--- a/ECtools/msr/kopano_msr/__init__.py
+++ /dev/null
@@ -1,657 +0,0 @@
-#!/usr/bin/python3
-# SPDX-License-Identifier: AGPL-3.0-only
-import codecs
-import collections
-from contextlib import closing
-import fcntl
-import multiprocessing
-import optparse
-import os.path
-import pickle
-from queue import Empty
-import sys
-
-import bsddb3 as bsddb
-import setproctitle
-
-from .version import __version__
-
-import kopano
-from kopano import Config
-from kopano import log_exc
-
-"""
-kopano-msr - live store migration tool
-
-parallelized over stores, with max 1 worker per store.
-
-migration settings and sync states are persistently stored in 'state_path'.
-
-migration management is done from command-line (using socket for communication).
-
-basic commands (see --help for all options):
-
-kopano-msr --list-users -> list users currently being migrated
-
-kopano-msr -u user1 --add --server node14 -> start migrating user
-
-kopano-msr -u user1 ->  check migration status, compare store contents
-
-kopano-msr -u user1 --remove -> finalize migration (metadata, special folders..)
-
-"""
-
-CONFIG = {
-    'state_path': Config.path(default='/var/lib/kopano/msr/', check=True),
-    'server_bind_name': Config.string(default='file:///var/run/kopano/msr.sock'),
-    'ssl_private_key_file': Config.path(default=None, check=False), # XXX don't check when default=None?
-    'ssl_certificate_file': Config.path(default=None, check=False),
-}
-
-setproctitle.setproctitle('kopano-msr main')
-
-def init_globals(): # late init to survive daemonization
-    global LOCK, STORE_STORE, USER_INFO, STORE_FOLDER_QUEUED, STORE_FOLDERS_TODO, USER_SINK
-
-    LOCK = multiprocessing.Lock()
-
-    _mgr = multiprocessing.Manager()
-
-    # TODO persistency
-    STORE_STORE = _mgr.dict() # store mapping
-    USER_INFO = _mgr.dict() # statistics
-
-    # ensure max one worker per store (performance, correctness)
-    # storeid -> foldereid (specific folder sync) or None (for hierarchy sync)
-    STORE_FOLDER_QUEUED = _mgr.dict()
-
-    # store incoming updates until processed
-    # storeid -> foldereids (or None for hierarchy sync)
-    STORE_FOLDERS_TODO = _mgr.dict()
-
-    USER_SINK = {} # per-user notification sink
-
-def db_get(db_path, key, decode=True):
-    """ get value from db file """
-    key = key.encode('ascii')
-    with closing(bsddb.hashopen(db_path, 'c')) as db:
-        value = db.get(key)
-        if value is not None and decode:
-            value = value.decode('ascii')
-        return value
-
-def db_put(db_path, key, value):
-    """ store key, value in db file """
-    key = key.encode('ascii')
-    with open(db_path+'.lock', 'w') as lockfile:
-        fcntl.flock(lockfile.fileno(), fcntl.LOCK_EX)
-        with closing(bsddb.hashopen(db_path, 'c')) as db:
-            db[key] = value
-
-def update_user_info(state_path, user, key, op, value):
-    data = USER_INFO.get(user.name, {})
-    if op == 'add':
-        if key not in data:
-            data[key] = 0
-        data[key] += value
-    elif op == 'store':
-        data[key] = value
-    USER_INFO[user.name] = data
-
-    data = pickle.dumps(data)
-    db_put(state_path, 'info', data)
-
-def _queue_or_store(state_path, user, store_entryid, folder_entryid, iqueue):
-    with LOCK:
-        update_user_info(state_path, user, 'queue_empty', 'store', 'no')
-
-        if store_entryid in STORE_FOLDER_QUEUED:
-            todo = STORE_FOLDERS_TODO.get(store_entryid, set())
-            todo.add(folder_entryid)
-            STORE_FOLDERS_TODO[store_entryid] = todo
-        else:
-            STORE_FOLDER_QUEUED[store_entryid] = folder_entryid
-            iqueue.put((store_entryid, folder_entryid))
-
-class ControlWorker(kopano.Worker):
-    """ control process """
-
-    def user_details(self, server, username):
-        lines = []
-
-        # general info
-        data = USER_INFO[username]
-        lines.append('user:               %s' % username)
-        lines.append('target server:      %s' % data['server'])
-        lines.append('processed items:    %d' % data['items'])
-        lines.append('initial sync done:  %s' % data['init_done'])
-        lines.append('update queue empty: %s' % data['queue_empty'])
-        lines.append('')
-
-        # store contents comparison
-        lines.append('store comparison:')
-
-        storea = server.user(username).store
-        storeb = server.store(entryid=STORE_STORE[storea.entryid])
-
-        difference = False
-
-        foldersa = set(f.path for f in storea.folders())
-        foldersb = set(f.path for f in storeb.folders())
-
-        for path in foldersb - foldersa:
-            lines.append('%s: folder only exists in target store' % path)
-            difference = True
-
-        for path in foldersa - foldersb:
-            lines.append('%s: folder only exists in source store' % path)
-            difference = True
-
-        for path in foldersa & foldersb:
-            counta = storea.folder(path).count
-            countb = storeb.folder(path).count
-            if counta != countb:
-                lines.append("%s: item count is %d compared to source %d" % (path, countb, counta))
-                difference = True
-
-        if not difference:
-            lines.append('folder structure and item counts are identical')
-
-        return lines
-
-    def main(self):
-        config, server, options = self.service.config, self.service.server, self.service.options
-        setproctitle.setproctitle('kopano-msr control')
-
-        def response(conn, msg):
-            self.log.info('Response: %s', msg)
-            conn.sendall((msg+'\r\n').encode())
-
-        s = kopano.server_socket(config['server_bind_name'], ssl_key=config['ssl_private_key_file'], ssl_cert=config['ssl_certificate_file'], log=self.log)
-
-        while True:
-            with log_exc(self.log):
-                try:
-                    conn = None
-                    conn, _ = s.accept()
-                    for data in conn.makefile():
-                        self.log.info('CMD: %s', data.strip())
-                        data = data.split()
-
-                        if not data:
-                            self.log.error('invalid command send')
-                            break
-
-                        if data[0] == 'ADD' and len(data) == 4:
-                            user, target_user, target_server = data[1:]
-                            if user in USER_INFO:
-                                self.log.error('user %s is already being relocated', user) # TODO return error
-                                response(conn, 'ERROR')
-                                break
-                            self.subscribe.put((user, target_user, target_server, True, None))
-                            response(conn, 'OK:')
-                            break
-
-                        elif data[0] == 'REMOVE' and len(data) == 2:
-                            user = data[1]
-                            if user not in USER_INFO:
-                                self.log.error('user %s is not being relocated', user) # TODO return error
-                                response(conn, 'ERROR')
-                                break
-                            self.subscribe.put((user, None, None, False, None))
-                            response(conn, 'OK:')
-                            break
-
-                        elif data[0] == 'LIST':
-                            lines = []
-                            for user, data in USER_INFO.items():
-                                items = data['items']
-                                init_done = data['init_done']
-                                queue_empty = data['queue_empty']
-                                servername = data['server']
-                                line = 'user=%s server=%s items=%d init_done=%s queue_empty=%s' % (user, servername, items, init_done, queue_empty)
-                                lines.append(line)
-                            response(conn, 'OK:\n' + '\n'.join(lines))
-                            break
-
-                        elif data[0] == 'DETAILS' and len(data) == 2:
-                            user = data[1]
-                            if user not in USER_INFO:
-                                self.log.error('user %s is not being relocated', user) # TODO return error
-                                response(conn, 'ERROR')
-                                break
-                            response(conn, 'OK:\n' + '\n'.join(self.user_details(server, user)))
-                            break
-
-                        else:
-                            response(conn, 'ERROR')
-                            break
-
-                except Exception:
-                    response(conn, 'ERROR')
-                    raise
-                finally:
-                    if conn:
-                        conn.close()
-
-class HierarchyImporter:
-    def __init__(self, state_path, store2, store_entryid, iqueue, subtree_sk, user, log):
-        self.state_path = state_path
-        self.store2 = store2
-        self.store_entryid = store_entryid
-        self.iqueue = iqueue
-        self.subtree_sk = subtree_sk
-        self.user = user
-        self.log = log
-
-    def update(self, f):
-        with log_exc(self.log): # TODO use decorator?
-            entryid2 = db_get(self.state_path, 'folder_map_'+f.sourcekey)
-            psk = f.parent.sourcekey or self.subtree_sk # TODO default pyko to subtree_sk?
-
-            self.log.info('updated: %s', f)
-
-            parent2_eid = db_get(self.state_path, 'folder_map_'+psk)
-            parent2 = self.store2.folder(entryid=parent2_eid)
-
-            self.log.info('parent: %s', parent2)
-
-            if entryid2:
-                self.log.info('exists')
-
-                folder2 = self.store2.folder(entryid=entryid2)
-                folder2.name = f.name
-                folder2.container_class = f.container_class
-
-                if folder2.parent.entryid != parent2_eid:
-                    self.log.info('move folder')
-
-                    folder2.parent.move(folder2, parent2)
-
-            else:
-                self.log.info('create')
-
-                folder2 = parent2.folder(f.name, create=True)
-
-                db_put(self.state_path, 'folder_map_'+f.sourcekey, folder2.entryid)
-
-            _queue_or_store(self.state_path, self.user, self.store_entryid, f.entryid, self.iqueue)
-
-    def delete(self, f, flags):
-        with log_exc(self.log):
-            self.log.info('deleted folder: %s', f.sourcekey)
-
-            entryid2 = db_get(self.state_path, 'folder_map_'+f.sourcekey)
-            if entryid2: # TODO why this check
-                folder2 = self.store2.folder(entryid=entryid2)
-                self.store2.delete(folder2)
-
-            # TODO delete from mapping
-
-class FolderImporter:
-    def __init__(self, state_path, folder2, user, log):
-        self.state_path = state_path
-        self.folder2 = folder2
-        self.user = user
-        self.log = log
-
-    def update(self, item, flags):
-        with log_exc(self.log):
-            self.log.info('new/updated item: %s', item.sourcekey)
-            entryid2 = db_get(self.state_path, 'item_map_'+item.sourcekey)
-            if entryid2:
-                item2 = self.folder2.item(entryid2)
-                self.folder2.delete(item2) # TODO remove from db
-            item2 = item.copy(self.folder2)
-            db_put(self.state_path, 'item_map_'+item.sourcekey, item2.entryid)
-            update_user_info(self.state_path, self.user, 'items', 'add', 1)
-
-    def read(self, item, state):
-        with log_exc(self.log):
-            self.log.info('changed readstate for item: %s', item.sourcekey)
-            entryid2 = db_get(self.state_path, 'item_map_'+item.sourcekey)
-            self.folder2.item(entryid2).read = state
-
-    def delete(self, item, flags):
-        with log_exc(self.log):
-            self.log.info('deleted item: %s', item.sourcekey)
-            entryid2 = db_get(self.state_path, 'item_map_'+item.sourcekey)
-            self.folder2.delete(self.folder2.item(entryid2))
-
-class NotificationSink:
-    def __init__(self, state_path, user, store, iqueue, log):
-        self.state_path = state_path
-        self.user = user
-        self.store = store
-        self.iqueue = iqueue
-        self.log = log
-
-    def update(self, notification):
-        with log_exc(self.log):
-            self.log.info('notif: %s %s', notification.object_type, notification.event_type)
-
-            if notification.object_type == 'item':
-                folder = notification.object.folder
-                _queue_or_store(self.state_path, self.user, self.store.entryid, folder.entryid, self.iqueue)
-
-            elif notification.object_type == 'folder':
-                _queue_or_store(self.state_path, self.user, self.store.entryid, None, self.iqueue)
-
-class SyncWorker(kopano.Worker):
-    """ worker process """
-
-    def main(self):
-        config, server, options = self.service.config, self.service.server, self.service.options
-        setproctitle.setproctitle('kopano-msr worker %d' % self.nr)
-
-        while True:
-            store_entryid, folder_entryid = self.iqueue.get()
-
-            with log_exc(self.log):
-
-                store = self.server.store(entryid=store_entryid)
-                user = store.user
-                store2 = self.server.store(entryid=STORE_STORE[store_entryid])
-                state_path = os.path.join(config['state_path'], user.name)
-
-                self.log.info('syncing for user %s', user.name)
-
-                # sync folder
-                if folder_entryid:
-                    try:
-                        folder = store.folder(entryid=folder_entryid)
-
-                        entryid2 = db_get(state_path, 'folder_map_'+folder.sourcekey)
-                        folder2 = store2.folder(entryid=entryid2)
-
-                    except kopano.NotFoundError: # TODO further investigate
-                        self.log.info('parent folder does not exist (anymore)')
-                    else:
-                        self.log.info('syncing folder %s (%s)', folder.sourcekey, folder.name)
-
-                        # check previous state
-                        state = db_get(state_path, 'folder_state_'+folder.sourcekey)
-                        if state:
-                            self.log.info('previous folder sync state: %s', state)
-
-                        # sync and store new state
-                        importer = FolderImporter(state_path, folder2, user, self.log)
-                        newstate = folder.sync(importer, state)
-                        db_put(state_path, 'folder_state_'+folder.sourcekey, newstate)
-
-                # sync hierarchy
-                else:
-                    self.log.info('syncing hierarchy')
-
-                    # check previous state
-                    state = db_get(state_path, 'store_state_'+store_entryid)
-                    if state:
-                        self.log.info('found previous store sync state: %s', state)
-
-                    # sync and store new state
-                    importer = HierarchyImporter(state_path, store2, store_entryid, self.iqueue, store.subtree.sourcekey, user, self.log)
-                    newstate = store.subtree.sync_hierarchy(importer, state)
-                    db_put(state_path, 'store_state_'+store_entryid, newstate)
-
-            self.oqueue.put((store_entryid, folder_entryid))
-
-class Service(kopano.Service):
-    """ main process """
-
-    def main(self):
-        init_globals()
-
-        setproctitle.setproctitle('kopano-msr service')
-
-        self.iqueue = multiprocessing.Queue() # folders in the working queue
-        self.oqueue = multiprocessing.Queue() # processed folders, used to update STORE_FOLDER_QUEUED
-        self.subscribe = multiprocessing.Queue() # subscription update queue
-
-        self.state_path = self.config['state_path']
-
-        # initialize and start workers
-        workers = [SyncWorker(self, 'msr%d'%i, nr=i, iqueue=self.iqueue, oqueue=self.oqueue)
-                       for i in range(self.config['worker_processes'])]
-        for worker in workers:
-            worker.start()
-
-        control_worker = ControlWorker(self, 'control', subscribe=self.subscribe)
-        control_worker.start()
-
-        # resume relocations
-        for username in os.listdir(self.state_path):
-            if not username.endswith('.lock'):
-                with log_exc(self.log):
-                    state_path = os.path.join(self.state_path, username)
-                    info = pickle.loads(db_get(state_path, 'info', decode=False))
-
-                    self.subscribe.put((username, info['target'], info['server'], True, info['store']))
-
-        # continue using notifications
-        self.notify_sync()
-
-    def subscribe_user(self, server, username, target_user, target_server, storeb_eid):
-        self.log.info('subscribing: %s -> %s', username, target_server)
-
-        usera = server.user(username)
-        storea = usera.store
-
-        # TODO report errors back directly to command-line process
-        if storeb_eid:
-            storeb = server.store(entryid=storeb_eid)
-        elif target_server != '_':
-            try:
-                server2 = kopano.server(
-                    server_socket=target_server,
-                    sslkey_file=server.sslkey_file,
-                    sslkey_pass=server.sslkey_pass
-                )
-            except Exception as e:
-                self.log.error("could not connect to server: %s (%s)", target_server, e, file=sys.stderr)
-            try:
-                userb = server2.user(username) # TODO assuming the user is there?
-                storeb = server2.create_store(userb, _msr=True)
-                storeb.subtree.empty() # remove default english special folders
-            except kopano.DuplicateError:
-                self.log.error('user already has hooked store on server %s, try to unhook first', target_server)
-                return
-        else:
-            storeb = server.user(target_user).store
-
-        state_path = os.path.join(self.state_path, usera.name)
-
-        sink = NotificationSink(state_path, usera, usera.store, self.iqueue, self.log)
-
-        storea.subscribe(sink, object_types=['item', 'folder'])
-
-        STORE_STORE[storea.entryid] = storeb.entryid
-        USER_SINK[username] = sink
-        update_user_info(state_path, usera, 'items', 'store', 0)
-        update_user_info(state_path, usera, 'init_done', 'store', 'no')
-        update_user_info(state_path, usera, 'queue_empty', 'store', 'no')
-        update_user_info(state_path, usera, 'target', 'store', target_user)
-        update_user_info(state_path, usera, 'server', 'store', target_server)
-        update_user_info(state_path, usera, 'store', 'store', storeb.entryid)
-
-        db_put(state_path, 'folder_map_'+storea.subtree.sourcekey, storeb.subtree.entryid)
-
-        _queue_or_store(state_path, usera, storea.entryid, None, self.iqueue)
-
-    def unsubscribe_user(self, server, username):
-        self.log.info('unsubscribing: %s', username)
-
-        storea = server.user(username).store
-        storeb = server.store(entryid=STORE_STORE[storea.entryid])
-
-        # unsubscribe user from notification
-        sink = USER_SINK[username]
-        storea.unsubscribe(sink)
-
-        # unregister user everywhere
-        del USER_SINK[username]
-        del STORE_STORE[storea.entryid]
-        del USER_INFO[username]
-
-        # set special folders
-        for attr in (
-            'calendar',
-            'contacts',
-            'wastebasket',
-            'drafts',
-            'inbox',
-            'journal',
-            'junk',
-            'notes',
-            'outbox',
-            'sentmail',
-            'tasks',
-        ):
-            with log_exc(self.log):
-                setattr(storeb, attr, storeb.folder(getattr(storea, attr).path))
-
-        # transfer metadata
-        with log_exc(self.log): # TODO testing: store deleted in tearDown
-            storeb.settings_loads(storea.settings_dumps())
-
-            for foldera in storea.folders():
-                if foldera.path:
-                    folderb = storeb.get_folder(foldera.path)
-                    if folderb:
-                        folderb.settings_loads(foldera.settings_dumps())
-
-        # remove state dir
-        if self.state_path:
-            os.system('rm -rf %s/%s' % (self.state_path, username))
-            os.system('rm -rf %s/%s.lock' % (self.state_path, username))
-
-    def notify_sync(self):
-        server = kopano.server(notifications=True, options=self.options) # TODO ugh
-
-        while True:
-            # check command-line add-user requests
-            with log_exc(self.log):
-                try:
-                    user, target_user, target_server, subscribe, store_eid = self.subscribe.get(timeout=0.01)
-                    if subscribe:
-                        self.subscribe_user(server, user, target_user, target_server, store_eid)
-                    else:
-                        self.unsubscribe_user(server, user)
-
-                except Empty:
-                    pass
-
-            # check worker output queue: more folders for same store?
-            try:
-                store_entryid, _ = self.oqueue.get(timeout=0.01)
-                with LOCK:
-                    folders_todo = STORE_FOLDERS_TODO.get(store_entryid)
-                    if folders_todo:
-                        folder_entryid = folders_todo.pop()
-                        STORE_FOLDER_QUEUED[store_entryid] = folder_entryid
-                        self.iqueue.put((store_entryid, folder_entryid))
-                        STORE_FOLDERS_TODO[store_entryid] = folders_todo
-                    else:
-                        del STORE_FOLDER_QUEUED[store_entryid]
-
-                        store = server.store(entryid=store_entryid)
-                        user = store.user # TODO shall we use only storeid..
-                        state_path = os.path.join(self.state_path, user.name)
-                        update_user_info(state_path, user, 'init_done', 'store', 'yes')
-                        update_user_info(state_path, user, 'queue_empty', 'store', 'yes')
-
-            except Empty:
-                pass
-
-    def do_cmd(self, cmd):
-        try:
-            with closing(kopano.client_socket(self.config['server_bind_name'], ssl_cert=self.config['ssl_certificate_file'])) as s:
-                s.sendall(cmd.encode())
-                m = s.makefile()
-                line = m.readline()
-                if not line.startswith('OK'):
-                    print('kopano-msr returned an error. please check log.', file=sys.stderr)
-                    sys.exit(1)
-                for line in m:
-                    print(line.rstrip())
-        except OSError as e:
-            print('could not connect to msr socket (%s)' % e)
-            sys.exit(1)
-
-    def cmd_add(self, options):
-        username = options.users[0]
-        for name in (username, options.target):
-            if name and not self.server.get_user(name):
-                print("no such user: %s" % name, file=sys.stderr)
-                sys.exit(1)
-        if options.server:
-            try:
-                ts = kopano.server(
-                    server_socket=options.server,
-                    sslkey_file=self.server.sslkey_file,
-                    sslkey_pass=self.server.sslkey_pass
-                )
-            except Exception as e:
-                print("could not connect to server: %s (%s)" % (options.server, e), file=sys.stderr)
-                sys.exit(1)
-        self.do_cmd('ADD %s %s %s\r\n' % (username, options.target or '_', options.server or '_'))
-
-    def cmd_remove(self, options):
-        self.do_cmd('REMOVE %s\r\n' % options.users[0])
-
-    def cmd_list(self):
-        self.do_cmd('LIST\r\n')
-
-    def cmd_details(self, options):
-        username = options.users[0]
-        if not self.server.get_user(username):
-            print("no such user: %s" % username, file=sys.stderr)
-            sys.exit(1)
-        self.do_cmd('DETAILS %s\r\n' % options.users[0])
-
-def main():
-    # select common options
-    parser = kopano.parser('SUPKQCFulw')
-
-    # custom options
-    parser.add_option('--add', dest='add', action='store_true', help='Add user')
-    parser.add_option('--target', dest='target', action='store', help=optparse.SUPPRESS_HELP) # TODO remove (still used in testset/msr)
-    parser.add_option('--server', dest='server', action='store', help='Specify target server')
-    parser.add_option('--remove', dest='remove', action='store_true', help='Remove user')
-    parser.add_option('--list-users', dest='list_users', action='store_true', help='List users')
-
-    # parse and check command-line options
-    options, args = parser.parse_args()
-
-    service = Service('msr', options=options, config=CONFIG)
-
-    if options.users:
-        if options.list_users:
-            print('too many options provided')
-            sys.exit(1)
-        if len(options.users) != 1:
-            print('more than one user specified', file=sys.stderr)
-            sys.exit(1)
-        if options.add:
-            if not (options.target or options.server):
-                print('no server specified', file=sys.stderr)
-                sys.exit(1)
-            service.cmd_add(options)
-        elif options.remove:
-            service.cmd_remove(options)
-        else:
-            service.cmd_details(options)
-
-    elif options.list_users:
-        if options.add or options.remove or options.target or options.server:
-            print('too many options provided')
-            sys.exit(1)
-        service.cmd_list()
-
-    else:
-        if options.add or options.remove or options.target or options.server:
-            print('no user specified')
-            sys.exit(1)
-        service.start()
-
-if __name__ == '__main__':
-    main() # pragma: no cover
diff --git a/ECtools/msr/kopano_msr/version.py.in b/ECtools/msr/kopano_msr/version.py.in
deleted file mode 100644
index 280beb2dc..000000000
--- a/ECtools/msr/kopano_msr/version.py.in
+++ /dev/null
@@ -1 +0,0 @@
-__version__ = "@PACKAGE_VERSION@"
diff --git a/ECtools/msr/requirements.txt b/ECtools/msr/requirements.txt
deleted file mode 100644
index 6a201acbd..000000000
--- a/ECtools/msr/requirements.txt
+++ /dev/null
@@ -1,2 +0,0 @@
-bsddb3
-kopano
diff --git a/ECtools/msr/setup.cfg b/ECtools/msr/setup.cfg
deleted file mode 100644
index afc2c992c..000000000
--- a/ECtools/msr/setup.cfg
+++ /dev/null
@@ -1,4 +0,0 @@
-[metadata]
-
-[bdist_wheel]
-universal = 1
diff --git a/ECtools/msr/setup.py b/ECtools/msr/setup.py
deleted file mode 100644
index 773609317..000000000
--- a/ECtools/msr/setup.py
+++ /dev/null
@@ -1,56 +0,0 @@
-# SPDX-License-Identifier: AGPL-3.0-or-later
-import io
-import os.path
-import re
-import subprocess
-
-from distutils.command.build_py import build_py
-from setuptools import setup, find_packages
-
-
-version_base = 'kopano_msr'
-here = os.path.abspath(os.path.dirname(__file__))
-
-try:
-    FileNotFoundError
-except NameError:
-    FileNotFoundError = IOError
-
-try:
-    with io.open(os.path.join(here, version_base, 'version.py'), encoding='utf-8') as version_file:
-        metadata = dict(re.findall(r"""__([a-z]+)__ = "([^"]+)""", version_file.read()))
-except FileNotFoundError:
-    try:
-        v = subprocess.check_output(['../../tools/describe_version']).decode('utf-8').strip()[11:]
-    except FileNotFoundError:
-        v = 'dev'
-
-    metadata = {
-        'version': v,
-        'withoutVersionFile': True
-    }
-
-
-class my_build_py(build_py, object):
-    def run(self):
-        super(my_build_py, self).run()
-
-        if metadata.get('withoutVersionFile', False):
-            with io.open(os.path.join(self.build_lib, version_base, 'version.py'), mode='w') as version_file:
-                version_file.write('__version__ = "%s"\n' % metadata['version'])
-
-
-setup(name='kopano-msr',
-      version=metadata['version'],
-      url='https://kopano.io',
-      description='User migration tool for Kopano Core',
-      long_description='Migrates users to different servers without down-time.',
-      author='Kopano',
-      author_email='development@kopano.io',
-      keywords=['kopano'],
-      license='AGPL',
-      packages=find_packages(),
-      install_requires=[
-      ],
-      cmdclass={'build_py': my_build_py},
-)
diff --git a/Makefile.am b/Makefile.am
index 986a5a896..8416e3968 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,7 @@ SUBDIRS += installer/linux
 if ENABLE_PYTHON
 SUBDIRS += ECtools/backup ECtools/cli ECtools/migration-pst \
 	ECtools/presence ECtools/search ECtools/spamd \
-	ECtools/msr ECtools/utils installer/searchscripts spooler/python \
+	ECtools/utils installer/searchscripts spooler/python \
 	spooler/python/plugins swig/python/kopano
 endif
 BUILT_SOURCES =
@@ -947,7 +947,6 @@ dist_man_MANS += \
 	doc/kopano-cli.8 \
 	doc/kopano-mailbox-permissions.8 \
 	doc/kopano-migration-pst.8 doc/kopano-migration-pst.cfg.5 \
-	doc/kopano-msr.8 doc/kopano-msr.cfg.5 \
 	doc/kopano-mr-accept.8 doc/kopano-mr-process.8 \
 	doc/kopano-search.8 doc/kopano-search.cfg.5 \
 	doc/kopano-set-oof.1 \
diff --git a/configure.ac b/configure.ac
index fa4b29375..3ad4079e1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -706,7 +706,6 @@ AC_CONFIG_FILES([Makefile
 		ECtools/backup/Makefile
 		ECtools/cli/Makefile
 		ECtools/migration-pst/Makefile
-		ECtools/msr/Makefile
 		ECtools/presence/Makefile
 		ECtools/search/Makefile
 		ECtools/spamd/Makefile
@@ -732,7 +731,6 @@ AC_CONFIG_FILES([Makefile
 
 AC_CONFIG_FILES([ECtools/search/kopano-search], [chmod +x ECtools/search/kopano-search])
 AC_CONFIG_FILES([ECtools/backup/kopano-backup], [chmod +x ECtools/backup/kopano-backup])
-AC_CONFIG_FILES([ECtools/msr/kopano-msr], [chmod +x ECtools/msr/kopano-msr])
 AC_CONFIG_FILES([ECtools/cli/kopano-cli], [chmod +x ECtools/cli/kopano-cli])
 AC_CONFIG_FILES([ECtools/rules/kopano-rules], [chmod +x ECtools/rules/kopano-rules])
 AC_CONFIG_FILES([ECtools/presence/kopano-presence], [chmod +x ECtools/presence/kopano-presence])
@@ -743,7 +741,6 @@ AC_CONFIG_FILES([ECtools/utils/kopano-mr-process], [chmod +x ECtools/utils/kopan
 AC_CONFIG_FILES([ECtools/utils/kopano-autorespond], [chmod +x ECtools/utils/kopano-autorespond])
 AC_CONFIG_FILES([ECtools/search/kopano_search/version.py], [])
 AC_CONFIG_FILES([ECtools/backup/kopano_backup/version.py], [])
-AC_CONFIG_FILES([ECtools/msr/kopano_msr/version.py], [])
 AC_CONFIG_FILES([ECtools/cli/kopano_cli/version.py], [])
 AC_CONFIG_FILES([ECtools/rules/kopano_rules/version.py], [])
 AC_CONFIG_FILES([ECtools/presence/kopano_presence/version.py], [])
diff --git a/doc/kopano-msr.8 b/doc/kopano-msr.8
deleted file mode 100644
index 145d9ba9a..000000000
--- a/doc/kopano-msr.8
+++ /dev/null
@@ -1,109 +0,0 @@
-.TH "KOPANO\-MSR" "8" "November 2016" "Kopano 8" "Kopano Core user reference"
-.\" http://bugs.debian.org/507673
-.ie \n(.g .ds Aq \(aq
-.el       .ds Aq '
-.\" disable hyphenation
-.nh
-.\" disable justification (adjust text to left margin only)
-.ad l
-.SH "NAME"
-kopano-msr \- Kopano Multi-server Store Relocator
-.SH "SYNOPSIS"
-.HP \w'\fBkopano\-msr\fR\ 'u
-\fBkopano\-msr\fR
-.SH "DESCRIPTION"
-.PP
-The kopano\-msr daemon is used to live-migrate users from one server to another, within a multi-server cluster.
-.PP
-Users need to be separately indicated to the daemon. To do the actual switch-over, user homeservers need to be
-adjusted in the user directory (LDAP), after which kopano-admin --sync will switch to the new store.
-
-\fBkopano-msr\fR(8).
-.SH "OPTIONS"
-.PP
-The Kopano MSR program takes the following configuration options:
-.PP
-\fB\-\-add\fR
-.RS 4
-Add the user specified with \fB\-\-user\fR to the list of users to be relocated.
-.RE
-.PP
-\fB\-\-config\fR, \fB\-c\fR \fIfile\fR
-.RS 4
-Specify the location of the configuration file.
-.sp
-Default:
-\fI/etc/kopano/msr.cfg\fR
-.RE
-.PP
-\fB\-\-foreground\fR, \fB\-F\fR
-.RS 4
-Run in the foreground. Normally the kopano\-msr process will daemonize and run in the background.
-.RE
-.PP
-\fB\-\-list\-users\fR
-.RS 4
-List all users currently being relocated, including status information for each user.
-.RE
-.PP
-\fB\-\-log\-level\fR, \fB\-l\fR \fINAME\fR
-.RS 4
-Specify log\-level, for example, \fBerror\fP, \fBwarning\fP, \fBinfo\fP or \fBdebug\fP.
-.RE
-.PP
-\fB\-\-remove\fR
-.RS 4
-Remove the user specified with \fB\-\-user\fR from the list of users to be relocated. At this point,
-metadata (such as permissions and rules) will be synchronized.
-.RE
-.PP
-\fB\-\-server\fR
-.RS 4
-Specify URL of server to which user specified with \fB\-\-user\fR should be relocated.
-.RE
-.PP
-\fB\-\-user\fR, \fB\-u\fR
-.RS 4
-Specify user. With no further options, it will show details about the user (store) as it is being relocated,
-including a comparison between source and target store.
-.RE
-.PP
-\fB\-\-worker\-processes\fR, \fB\-w\fR \fIN\fR
-.RS 4
-When relocating multiple stores, process these stores in parallel, using the specified number of workers.
-.RE
-.PP
-When invoked without a \fB\-\-config\fR option, the kopano\-msr daemon will search for a configuration file in
-/etc/kopano/msr.cfg. If no configuration file is found, default values are used. See
-\fBkopano-msr.cfg\fR(5)
-for all configuration options and their default values.
-.SH "USAGE"
-.PP
-Starting kopano MSR with log-level debug (subsequent commands assume a running service):
-.PP
-\fBkopano\-msr\fR\ \fB\-l\fR\ debug
-.PP
-Adding a user \fBfritz\fR to be relocated to another server:
-.PP
-\fBkopano\-msr\fR\ \fB\-u\fR\ fritz \fB\-\-add\fR \fB\-\-server\fR https://destination.server:237/
-.PP
-Listing users currently being relocated:
-.PP
-\fBkopano\-msr\fR\ \fB\-\-list\-users\fR
-.PP
-Showing details and relocation status for user \fBfritz\fR:
-.PP
-\fBkopano\-msr\fR\ \fB\-u\fR fritz
-.PP
-Removing user from relocation list (because the target store is up-to-date), and sync metadata:
-.PP
-\fBkopano\-msr\fR\ \fB\-u\fR fritz \fB\-\-remove\fR
-.PP
-After removing a user, and changing the user homeserver to the new server node, make the actual switch:
-.PP
-\fBkopano\-admin\fR\ \fB\-\-sync\fR
-.PP
-.SH "SEE ALSO"
-.PP
-\fBkopano-server\fR(8),
-\fBkopano-msr.cfg\fR(5)
diff --git a/doc/kopano-msr.cfg.5 b/doc/kopano-msr.cfg.5
deleted file mode 100644
index 01edc6fd3..000000000
--- a/doc/kopano-msr.cfg.5
+++ /dev/null
@@ -1,190 +0,0 @@
-.TH "KOPANO\-MSR.CFG" "5" "November 2016" "Kopano 8" "Kopano Core user reference"
-.\" http://bugs.debian.org/507673
-.ie \n(.g .ds Aq \(aq
-.el       .ds Aq '
-.\" disable hyphenation
-.nh
-.\" disable justification (adjust text to left margin only)
-.ad l
-.SH "NAME"
-kopano-msr.cfg \- The Kopano MSR configuration file
-.SH "SYNOPSIS"
-.PP
-\fBmsr.cfg\fR
-.SH "DESCRIPTION"
-.PP
-The configuration file for the Kopano MSR Service.
-.SH "FILE FORMAT"
-.PP
-The file consists of one big section, but parameters can be grouped by functionality.
-.PP
-The parameters are written in the form:
-.PP
-\fBname\fR
-=
-\fIvalue\fR
-.PP
-The file is line\-based. Each newline\-terminated line represents either a comment, nothing, a parameter or a directive. A line beginning with \fB#\fP is considered a comment, and will be ignored by Kopano. Parameter names are case sensitive. Lines beginning with \fB!\fP are directives.
-.PP
-Directives are written in the form:
-.PP
-!\fBdirective\fR
-\fI[argument(s)] \fR
-.PP
-The following directives exist:
-.PP
-\fBinclude\fR
-.RS 4
-Include and process
-\fIargument\fR
-.sp
-Example: !include common.cfg
-.RE
-.SH "EXPLANATION OF THE SERVICE SETTINGS PARAMETERS"
-.PP
-\fBstate_path\fR
-.RS 4
-Directory under which to maintain synchronization states.
-.sp
-Default:
-\fI/var/lib/kopano/msr/\fR
-.RE
-.PP
-\fBrun_as_user\fR
-.RS 4
-After correctly starting, the server process will become this user, dropping root privileges. Note that the log file needs to be writeable by this user, and the directory too to create new logfiles after logrotation. This can also be achieved by setting the correct group and permissions.
-.sp
-Default value is empty, not changing the user after starting.
-.RE
-.PP
-\fBrun_as_group\fR
-.RS 4
-After correctly starting, the server process will become this group, dropping root privileges.
-.sp
-Default value is empty, not changing the group after starting.
-.RE
-.PP
-\fBpid_file\fR
-.RS 4
-Write the process ID number to this file. This is used by the init.d script to correctly stop/restart the service.
-.sp
-Default:
-\fI/var/run/kopano/msr.pid\fR
-.RE
-.PP
-\fBrunning_path\fR
-.RS 4
-Change directory to this path when running in daemonize mode. When using the \fB\-F\fP switch to run in the foreground the directory will not be changed.
-.sp
-Default:
-\fI/\fR
-.RE
-.SH "EXPLANATION OF THE SERVER SETTINGS PARAMETERS"
-.PP
-\fBserver_socket\fR
-.RS 4
-Socket to find the connection to the Kopano server.
-.sp
-Default:
-\fIfile:///var/run/kopano/server.sock\fR
-.RE
-.PP
-\fBsslkey_file\fR
-.RS 4
-The file containing the private key and certificate. Please read the SSL section in the
-\fBkopano-server\fR(8)
-manual on how to create this file.
-.sp
-Default:
-\fI/etc/kopano/ssl/msr.pem\fR
-.RE
-.PP
-\fBsslkey_pass\fR
-.RS 4
-Enter your password here when your key file contains a password to be readable.
-.sp
-No default set.
-.RE
-.SH "EXPLANATION OF THE LISTEN SETTINGS PARAMETERS"
-.PP
-\fBserver_bind_name\fR
-.RS 4
-Connection path where other processes can connect to talk to the kopano-msr service.
-.sp
-Use
-\fIhttp://0.0.0.0:port\fR
-to listen as an HTTP service on all IPv4 interfaces on the given
-\fIport\fR
-number.
-.sp
-Default:
-\fIfile:///var/run/kopano/msr.sock\fR
-.RE
-.PP
-\fBssl_private_key_file\fR
-.RS 4
-kopano\-msr will use this file as private key for SSL TLS. This file can be created with:
-\fBopenssl genrsa \-out /etc/kopano/msr/privkey.pem 2048\fR.
-.sp
-Default:
-\fI/etc/kopano/msr/privkey.pem\fR
-.RE
-.PP
-\fBssl_certificate_file\fR
-.RS 4
-kopano\-msr will use this file as certificate for SSL TLS. A self\-signed certificate can be created with:
-\fBopenssl req \-new \-x509 \-key /etc/kopano/msr/privkey.pem \-out /etc/kopano/msr/cert.pem \-days 1095\fR.
-.sp
-Default:
-\fI/etc/kopano/msr/cert.pem\fR
-.RE
-.SH "EXPLANATION OF THE LOG SETTINGS PARAMETERS"
-.PP
-\fBlog_method\fR
-.RS 4
-The method which should be used for logging. Valid values are:
-.PP
-\fIsyslog\fR
-.RS 4
-Use the Linux system log. All messages will be written to the mail facility. See also
-\fBsyslog.conf\fR(5).
-.RE
-.PP
-\fIfile\fR
-.RS 4
-Log to a file. The filename will be specified in
-\fBlog_file\fR.
-.RE
-.sp
-Default:
-\fIfile\fR
-.RE
-.PP
-\fBlog_level\fR
-.RS 4
-The level of output for logging in the range from 0 to 5. 0 means no logging, 5 means full logging.
-.sp
-Default:
-\fI3\fR
-.RE
-.PP
-\fBlog_file\fR
-.RS 4
-When logging to a file, specify the filename in this parameter. Use
-\fB\-\fP
-(minus sign) for stderr output.
-.sp
-Default:
-\fI\-\fP
-.RE
-.SH "EXPLANATION OF THE MSR SETTINGS PARAMETERS"
-.PP
-\fBworker_processes\fR
-.RS 4
-Maximum number of stores to process in parallel
-.sp
-Default: 1
-.RE
-.SH "SEE ALSO"
-.PP
-\fBkopano-msr\fR(8)
diff --git a/installer/linux/Makefile.am b/installer/linux/Makefile.am
index 15e986b34..6186d344a 100644
--- a/installer/linux/Makefile.am
+++ b/installer/linux/Makefile.am
@@ -44,7 +44,7 @@ endif # ENABLE_BASE
 
 if ENABLE_PYTHON
 dist_sbin_SCRIPTS += kopano-autorespond
-config_files += autorespond.cfg backup.cfg migration-pst.cfg msr.cfg presence.cfg search.cfg spamd.cfg
+config_files += autorespond.cfg backup.cfg migration-pst.cfg presence.cfg search.cfg spamd.cfg
 dist_sysconf_apparmor_DATA += usr.sbin.kopano-search
 dist_doc_DATA += ${top_srcdir}/tools/python-scripts/update-resource-recipients
 kgwdocdir = ${docdir}/../kopano-gateway
diff --git a/installer/linux/msr.cfg b/installer/linux/msr.cfg
deleted file mode 100644
index bc90d25b1..000000000
--- a/installer/linux/msr.cfg
+++ /dev/null
@@ -1,63 +0,0 @@
-##############################################################
-# MSR SERVICE SETTINGS
-
-# Location of sync state files
-#state_path = /var/lib/kopano/msr/
-
-# run as specific user
-#run_as_user         = kopano
-
-# run as specific group
-#run_as_group        = kopano
-
-# control pid file
-#pid_file            =   /var/run/kopano/msr.pid
-
-# run server in this path (when not using the -F switch)
-#running_path = /var/lib/kopano/empty
-
-##############################################################
-# SERVER SETTINGS
-
-# Socket to find the connection to the storage server.
-# Use https to reach servers over the network
-#server_socket   =   file:///var/run/kopano/server.sock
-
-# Login to the storage server using this SSL Key
-#sslkey_file         = /etc/kopano/ssl/msr.pem
-
-# The password of the SSL Key
-#sslkey_pass         = replace-with-server-cert-password
-
-##############################################################
-# LISTEN SETTINGS
-#
-
-# binding address
-# To setup for multi-server, use: http://0.0.0.0:port or https://0.0.0.0:port
-#server_bind_name = file:///var/run/kopano/msr.sock
-
-# File with RSA key for SSL, used then server_bind_name uses https
-#ssl_private_key_file = /etc/kopano/msr/privkey.pem
-
-# File with certificate for SSL, used then server_bind_name uses https
-#ssl_certificate_file = /etc/kopano/msr/cert.pem
-
-##############################################################
-# LOG SETTINGS
-
-# Logging method (syslog, file)
-#log_method          =   file
-
-# Loglevel (0(none), 1(crit), 2(err), 3(warn), 4(notice), 5(info), 6(debug))
-#log_level           =   3
-
-# Logfile for log_method = file, use '-' for stderr
-# Default: -
-#log_file = /var/log/kopano/msr.log
-
-##############################################################
-# MSR SETTINGS
-
-# maximum number of stores to backup in parallel
-#worker_processes   =   1
-- 
2.21.0

