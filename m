From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH 2/2] ip{,6}tables-restore: Don't accept wait-interval without wait
Date: Wed, 20 Sep 2017 19:34:36 +0200
Message-ID: <20170920173436.20221-3-phil@nwl.cc>
References: <20170920173436.20221-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41528 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdITRew (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 13:34:52 -0400
In-Reply-To: <20170920173436.20221-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If -W <val> was given, error out if -w wasn't since that doesn't make
sense.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables-restore.c | 5 +++++
 iptables/iptables-restore.c  | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index eaa2bcbc3856e..47310f20b9363 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -273,6 +273,11 @@ int ip6tables_restore_main(int argc, char *argv[])
 	}
 	else in = stdin;
 
+	if (!wait_interval.tv_sec && !wait) {
+		fprintf(stderr, "Option --wait-interval requires option --wait\n");
+		exit(1);
+	}
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), in)) {
 		int ret = 0;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 9dbfc572a7cec..074552af5dc74 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -271,6 +271,11 @@ iptables_restore_main(int argc, char *argv[])
 	}
 	else in = stdin;
 
+	if (!wait_interval.tv_sec && !wait) {
+		fprintf(stderr, "Option --wait-interval requires option --wait\n");
+		exit(1);
+	}
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), in)) {
 		int ret = 0;
-- 
2.13.1

