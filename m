From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables: use IPC semaphore instead of abstract unix sockets
Date: Sun, 18 Jan 2015 22:13:36 +0100
Message-ID: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
Cc: kernel@linuxace.com, lennart@poettering.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42753 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbbARVKq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2015 16:10:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Abstract unix sockets cannot be used to synchronize several concurrent
instances of iptables since an unpriviledged process can create them and
prevent the legitimate iptables instance from running.

This patch introduces a semaphore that is identified by the path to the
iptables binary, it also relies on SEM_UNDO so the kernel performs the
up() operation at process exit to avoid races with signals. This also
avoid file locks that require a writable filesystem.

Fixes: 93587a0 ("ip[6]tables: Add locking to prevent concurrent instances")
Reported-by: Lennart Poettering <lennart@poettering.net>
Cc: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xshared.c |  122 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 105 insertions(+), 17 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index b18022e..80eed2c 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -9,12 +9,15 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <unistd.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/ipc.h>
+#include <sys/sem.h>
+#include <string.h>
+#include <errno.h>
 #include <xtables.h>
 #include "xshared.h"
 
-#define XT_SOCKET_NAME "xtables"
-#define XT_SOCKET_LEN 8
-
 /*
  * Print out any special helps. A user might like to be able to add a --help
  * to the commandline, and see expected results. So we call help for all
@@ -243,24 +246,109 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
+static int xtables_check_owner(int semid)
+{
+	int ret;
+	struct semid_ds ds;
+
+	ret = semctl(semid, 0, IPC_STAT, &ds);
+	if (ret < 0) {
+		if (errno == EACCES)
+			return 0;
+
+		goto err;
+	}
+
+	/* I don't own this semaphore, release it and create it again */
+	if (ds.sem_perm.cuid != 0)
+		goto err;
+
+	return 0;
+err:
+	/* delete this semaphore and try again */
+	ret = semctl(semid, 0, IPC_RMID);
+	if (ret < 0)
+		return 0;
+
+	return -1;
+}
+
+static bool xtables_sem_down(int semid, int wait)
+{
+	struct sembuf down = {
+		.sem_num	= 0,
+		.sem_op		= -1,
+		.sem_flg	= IPC_NOWAIT | SEM_UNDO,
+	};
+	int ret;
+
+	ret = semop(semid, &down, 1);
+	if (ret < 0 && errno == EAGAIN)
+		return false;
+
+	return true;
+}
+
+static int xtables_sem_up(int semid)
+{
+	struct sembuf up = {
+		.sem_num	= 0,
+		.sem_op		= 1,
+	};
+	int ret;
+
+	ret = semop(semid, &up, 1);
+	if (ret < 0)
+		perror("xtables cannot up semaphore");
+
+	return ret;
+}
+
+static int xtables_sem_create(void)
+{
+	int semid, key;
+	char iptables_path[PATH_MAX], proc_path[PATH_MAX];
+	ssize_t ret;
+again:
+	snprintf(proc_path, sizeof(proc_path), "/proc/%u/exe", getpid());
+	proc_path[sizeof(proc_path) - 1] = '\0';
+	ret = readlink(proc_path, iptables_path, sizeof(iptables_path));
+	if (ret < 0)
+		return -1;
+
+	key = ftok(iptables_path, 1);
+	semid = semget(key, 1, 0600 | IPC_CREAT | IPC_EXCL);
+	if (semid < 0) {
+		semid = semget(key, 1, 0);
+		if (semid < 0)
+			return -1;
+
+		if (xtables_check_owner(semid) < 0)
+			goto again;
+	} else {
+		if (xtables_check_owner(semid) < 0)
+			goto again;
+
+		/* Linux initializes IPC semaphore counters to zero after
+		 * semget(), set this counter to one initially.
+		 */
+		xtables_sem_up(semid);
+	}
+	return semid;
+}
+
 bool xtables_lock(int wait)
 {
-	int i = 0, ret, xt_socket;
-	struct sockaddr_un xt_addr;
-	int waited = 0;
-
-	memset(&xt_addr, 0, sizeof(xt_addr));
-	xt_addr.sun_family = AF_UNIX;
-	strcpy(xt_addr.sun_path+1, XT_SOCKET_NAME);
-	xt_socket = socket(AF_UNIX, SOCK_STREAM, 0);
-	/* If we can't even create a socket, fall back to prior (lockless) behavior */
-	if (xt_socket < 0)
+	int semid, waited = 0, i = 0;
+
+	semid = xtables_sem_create();
+	if (semid < 0) {
+		perror("Cannot get iptables semaphore, giving up on locking");
 		return true;
+	}
 
-	while (1) {
-		ret = bind(xt_socket, (struct sockaddr*)&xt_addr,
-			   offsetof(struct sockaddr_un, sun_path)+XT_SOCKET_LEN);
-		if (ret == 0)
+        while (1) {
+		if (xtables_sem_down(semid, wait))
 			return true;
 		else if (wait >= 0 && waited >= wait)
 			return false;
-- 
1.7.10.4

