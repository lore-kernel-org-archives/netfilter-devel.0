Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F27C001B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 11:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjHJLZy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjHJLZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 07:25:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C2D10D
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 04:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i+r2P3NlqaWb7nJIjVPdSu6LKrbO+kxob5IHJrybgvM=; b=Lt6WfLsIXjT6DT8Oh5N3ZPAfBO
        B38bgvtMlpW+fpcm4bmDg+C7Q3Yj2TroCPg2VL7P4xq5wFsPqzkPv8id9A1JwFlxxyhyPWGP3izV6
        M+uo97FFbYK8wMqiBS0XNqSV9ICHTibyxKeDdv67E5kpIXw/27t1T6bElR4Y+61qNasKha/rO5USk
        1G6yy5miQQHAxoNQMZZKQN41YqLK563T5eomCFHybn3GZvE5D6VIX0csuUWCiHm2kF+T08QSKZ7BW
        V+LLAE5jj8cvR5L2vSl5mqaWs36AFjRgcurZ05URAbR8L6SlF8H20aRKoFNJVQw6bxgBFFw+cS53c
        P8GdrRgg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qU3nb-0004R8-BZ; Thu, 10 Aug 2023 13:25:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Gaurav Gupta <g.gupta@samsung.com>
Subject: [iptables PATCH] Use SOCK_CLOEXEC/O_CLOEXEC where available
Date:   Thu, 10 Aug 2023 13:25:42 +0200
Message-Id: <20230810112542.21382-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need for the explicit fcntl() call, request the behaviour when
opening the descriptor.

One fcntl() call setting FD_CLOEXEC remains in extensions/libxt_bpf.c,
the indirect syscall seems not to support passing the flag directly.

Reported-by: Gaurav Gupta <g.gupta@samsung.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1104
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_set.h |  8 +-------
 libiptc/libiptc.c      |  8 +-------
 libxtables/xtables.c   | 15 ++-------------
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 597bf7ebe575a..685bfab955597 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -10,7 +10,7 @@
 static int
 get_version(unsigned *version)
 {
-	int res, sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
+	int res, sockfd = socket(AF_INET, SOCK_RAW | SOCK_CLOEXEC, IPPROTO_RAW);
 	struct ip_set_req_version req_version;
 	socklen_t size = sizeof(req_version);
 	
@@ -18,12 +18,6 @@ get_version(unsigned *version)
 		xtables_error(OTHER_PROBLEM,
 			      "Can't open socket to ipset.\n");
 
-	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) == -1) {
-		xtables_error(OTHER_PROBLEM,
-			      "Could not set close on exec: %s\n",
-			      strerror(errno));
-	}
-
 	req_version.op = IP_SET_OP_VERSION;
 	res = getsockopt(sockfd, SOL_IP, SO_IP_SET, &req_version, &size);
 	if (res != 0)
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 29ff356f2324e..e475063367c26 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1318,16 +1318,10 @@ TC_INIT(const char *tablename)
 		return NULL;
 	}
 
-	sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
+	sockfd = socket(TC_AF, SOCK_RAW | SOCK_CLOEXEC, IPPROTO_RAW);
 	if (sockfd < 0)
 		return NULL;
 
-	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) == -1) {
-		fprintf(stderr, "Could not set close on exec: %s\n",
-			strerror(errno));
-		abort();
-	}
-
 	s = sizeof(info);
 
 	strcpy(info.name, tablename);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index e3e444acbbaa2..ba9ceaeb3da41 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -481,14 +481,9 @@ static char *get_modprobe(void)
 	char *ret;
 	int count;
 
-	procfile = open(PROC_SYS_MODPROBE, O_RDONLY);
+	procfile = open(PROC_SYS_MODPROBE, O_RDONLY | O_CLOEXEC);
 	if (procfile < 0)
 		return NULL;
-	if (fcntl(procfile, F_SETFD, FD_CLOEXEC) == -1) {
-		fprintf(stderr, "Could not set close on exec: %s\n",
-			strerror(errno));
-		exit(1);
-	}
 
 	ret = malloc(PATH_MAX);
 	if (ret) {
@@ -1023,7 +1018,7 @@ int xtables_compatible_revision(const char *name, uint8_t revision, int opt)
 	socklen_t s = sizeof(rev);
 	int max_rev, sockfd;
 
-	sockfd = socket(afinfo->family, SOCK_RAW, IPPROTO_RAW);
+	sockfd = socket(afinfo->family, SOCK_RAW | SOCK_CLOEXEC, IPPROTO_RAW);
 	if (sockfd < 0) {
 		if (errno == EPERM) {
 			/* revision 0 is always supported. */
@@ -1039,12 +1034,6 @@ int xtables_compatible_revision(const char *name, uint8_t revision, int opt)
 		exit(1);
 	}
 
-	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) == -1) {
-		fprintf(stderr, "Could not set close on exec: %s\n",
-			strerror(errno));
-		exit(1);
-	}
-
 	xtables_load_ko(xtables_modprobe_program, true);
 
 	strncpy(rev.name, name, XT_EXTENSION_MAXNAMELEN - 1);
-- 
2.40.0

