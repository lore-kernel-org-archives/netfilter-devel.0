From: Phil Sutter <phil@nwl.cc>
Subject: [ebtables PATCH] Fix locking if LOCKDIR does not exist
Date: Mon, 15 Jan 2018 16:27:31 +0100
Message-ID: <20180115152731.29337-1-phil@nwl.cc>
Cc: Tangchen <tang.chen@huawei.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44202 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbeAOP1n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 10:27:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The previous conversion to using flock() missed a crucial bit of code
which tries to create LOCKDIR once in case opening the lock failed -
This patch reestablishes the old behaviour.

Reported-by: Tangchen (UVP) <tang.chen@huawei.com>
Fixes: 6a826591878db ("Use flock() for --concurrent option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libebtc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/libebtc.c b/libebtc.c
index c0ff8ccfa66db..d47424872dc51 100644
--- a/libebtc.c
+++ b/libebtc.c
@@ -143,10 +143,16 @@ int use_lockfd;
  * or -2 on any other error. */
 static int lock_file()
 {
-	int fd = open(LOCKFILE, O_CREAT, 00600);
-
-	if (fd < 0)
-		return -2;
+	int fd, try = 0;
+
+retry:
+	fd = open(LOCKFILE, O_CREAT, 00600);
+	if (fd < 0) {
+		if (try == 1 || mkdir(LOCKDIR, 00700))
+			return -2;
+		try = 1;
+		goto retry;
+	}
 	return flock(fd, LOCK_EX);
 }
 
-- 
2.15.1

