Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9037C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B422B2064B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCkgS13T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgGQIkS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 04:40:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42989 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725864AbgGQIkS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 04:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594975216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5c/aaAStOXPOEWCYfpTREuudixuTM2JeHlYigmTtaYM=;
        b=YCkgS13T5ZhcbOosu+AN2PRXk8+eOq3K5iOo9HgNKqXOgl+OWOUqMHR48sjqW1L1w8k3Ur
        XEvMkXISJJR4dgiKUHLCsszkoaKlRUL3YBziGU1tcZSUKFmkJfb8a8AEYudq/iBrcthU3c
        T5bSCbGMurB1NZFnAMxjvymDNq7nBuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-hcSeYmGNNNykha0nL2M_NA-1; Fri, 17 Jul 2020 04:39:53 -0400
X-MC-Unique: hcSeYmGNNNykha0nL2M_NA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF018800465;
        Fri, 17 Jul 2020 08:39:52 +0000 (UTC)
Received: from lithium.redhat.com (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E4D56FED1;
        Fri, 17 Jul 2020 08:39:51 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     gscrivan@redhat.com, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v3] iptables: accept lock file name at runtime
Date:   Fri, 17 Jul 2020 10:39:40 +0200
Message-Id: <20200717083940.618618-1-gscrivan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

allow users to override at runtime the lock file to use through the
XTABLES_LOCKFILE environment variable.

It allows to use iptables when the user has granted enough
capabilities (e.g. a user+network namespace) to configure the network
but that lacks access to the XT_LOCK_NAME (by default placed under
/run).

$ XTABLES_LOCKFILE=/tmp/xtables unshare -rn iptables ...

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 configure.ac           |  1 +
 iptables/iptables.8.in |  8 ++++++++
 iptables/xshared.c     | 11 ++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 31a8bb26..d37752a2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -219,6 +219,7 @@ AC_SUBST([libxtables_vmajor])
 
 AC_DEFINE_UNQUOTED([XT_LOCK_NAME], "${xt_lock_name}",
 	[Location of the iptables lock file])
+AC_SUBST([XT_LOCK_NAME], "${xt_lock_name}")
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 054564b3..999cf339 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -397,6 +397,14 @@ corresponding to that rule's position in the chain.
 \fB\-\-modprobe=\fP\fIcommand\fP
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
+
+.SH LOCK FILE
+iptables uses the \fI@XT_LOCK_NAME@\fP file to take an exclusive lock at
+launch.
+
+The \fBXTABLES_LOCKFILE\fP environment variable can be used to override
+the default setting.
+
 .SH MATCH AND TARGET EXTENSIONS
 .PP
 iptables can use extended packet matching and target modules.
diff --git a/iptables/xshared.c b/iptables/xshared.c
index c1d1371a..7d97637f 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -249,15 +249,20 @@ void xs_init_match(struct xtables_match *match)
 static int xtables_lock(int wait, struct timeval *wait_interval)
 {
 	struct timeval time_left, wait_time;
+	const char *lock_file;
 	int fd, i = 0;
 
 	time_left.tv_sec = wait;
 	time_left.tv_usec = 0;
 
-	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
+	lock_file = getenv("XTABLES_LOCKFILE");
+	if (lock_file == NULL || lock_file[0] == '\0')
+		lock_file = XT_LOCK_NAME;
+
+	fd = open(lock_file, O_CREAT, 0600);
 	if (fd < 0) {
 		fprintf(stderr, "Fatal: can't open lock file %s: %s\n",
-			XT_LOCK_NAME, strerror(errno));
+			lock_file, strerror(errno));
 		return XT_LOCK_FAILED;
 	}
 
@@ -265,7 +270,7 @@ static int xtables_lock(int wait, struct timeval *wait_interval)
 		if (flock(fd, LOCK_EX) == 0)
 			return fd;
 
-		fprintf(stderr, "Can't lock %s: %s\n", XT_LOCK_NAME,
+		fprintf(stderr, "Can't lock %s: %s\n", lock_file,
 			strerror(errno));
 		return XT_LOCK_BUSY;
 	}
-- 
2.26.2

