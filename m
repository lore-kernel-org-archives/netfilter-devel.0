From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 5/8] iptables: Coverity: UNINIT
Date: Fri, 10 Jun 2011 15:25:59 +0200
Message-ID: <1307712362-17727-6-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab1FJN0r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQkJ8009056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:47 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

extensions/libxt_multiport.c:102: var_decl: Declaring variable "m" without initializer.
extensions/libxt_multiport.c:127: uninit_use: Using uninitialized value "m".

xtables.c:1496: var_decl: Declaring variable "n" without initializer.
xtables.c:1568: uninit_use: Using uninitialized value "n".

iptables-restore.c:128: var_decl: Declaring variable "curtable" without initializer.
iptables-restore.c:454: uninit_use_in_call: Using uninitialized element
                        of array "curtable" when calling "strcmp".
---
 extensions/libxt_multiport.c |    2 --
 iptables/iptables-restore.c  |    2 +-
 iptables/xtables.c           |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 03af5a9..63f96d9 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -108,7 +108,6 @@ parse_multi_ports_v1(const char *portstring,
 {
 	char *buffer, *cp, *next, *range;
 	unsigned int i;
-	uint16_t m;
 
 	buffer = strdup(portstring);
 	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
@@ -133,7 +132,6 @@ parse_multi_ports_v1(const char *portstring,
 			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
 				xtables_error(PARAMETER_PROBLEM,
 					   "invalid portrange specified");
-			m <<= 1;
 		}
  	}
 	multiinfo->count = i;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 1cb833c..5df0ef2 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -451,7 +451,7 @@ main(int argc, char *argv[])
 			free_argv();
 			fflush(stdout);
 		}
-		if (tablename && (strcmp(tablename, curtable) != 0))
+		if (tablename && curtable && (strcmp(tablename, curtable) != 0))
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
diff --git a/iptables/xtables.c b/iptables/xtables.c
index acfcf8b..ee38421 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1605,7 +1605,7 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 	static const struct in6_addr zero_addr;
 	struct in6_addr *addrp;
 	char buf[256], *p;
-	unsigned int len, i, j, n, count = 1;
+	unsigned int len, i, j, n = 0, count = 1;
 	const char *loop = name;
 
 	while ((loop = strchr(loop, ',')) != NULL) {
-- 
1.7.5.2

