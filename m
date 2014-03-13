From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 3/3] iptables: save - fix getopt_long()'s optstring
Date: Thu, 13 Mar 2014 17:01:21 +0100
Message-ID: <1394726481-6001-3-git-send-email-jpopelka@redhat.com>
References: <1394726481-6001-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaCMQBf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:01:35 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2DG1VJP027201
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2014 12:01:31 -0400
In-Reply-To: <1394726481-6001-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables/ip6tables-save.c | 2 +-
 iptables/iptables-save.c  | 2 +-
 iptables/xtables-save.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index a86a64a..cf56c63 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -137,7 +137,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cdt:M:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 2999c7f..ed81dfd 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -136,7 +136,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cdt:M:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 42d2907..d732377 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -104,7 +104,7 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcdt:46", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cdt:M:46", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = true;
-- 
1.8.5.3

