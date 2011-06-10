From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 7/8] iptables: Coverity: OVERRUN_STATIC
Date: Fri, 10 Jun 2011 15:26:01 +0200
Message-ID: <1307712362-17727-8-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1FJN0u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:50 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQoke009070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:50 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

extensions/libip6t_REJECT.c:114: overrun-local: Overrunning static array "reject_table",
                                 with 5 elements, at position 5 with index variable "i".

extensions/libip6t_REJECT.c:127: overrun-local: Overrunning static array "reject_table",
                                 with 5 elements, at position 5 with index variable "i".

extensions/libipt_REJECT.c:135: overrun-local: Overrunning static array "reject_table",
                                with 8 elements, at position 8 with index variable "i".

extensions/libipt_REJECT.c:148: overrun-local: Overrunning static array "reject_table",
                                with 8 elements, at position 8 with index variable "i".

extensions/libxt_sctp.c:419: overrun-call: Overrunning callee's array of size 18 by passing
                             index "i" of value 255 in call to function "print_chunk(i, numeric)".
extensions/libxt_sctp.c:383: index_parm: Directly indexing parameter.

libiptc/libiptc.c:1690: overrun-buffer-arg: Overrunning static array "t->target.u.user.name"
                        of size 29 bytes by passing it to a function which indexes it
                        with argument "30UL" at byte position 29.

libiptc/libiptc.c:1127: overrun-buffer-arg: Overrunning static array "t->target.u.user.name"
                        of size 29 bytes by passing it to a function which indexes it
                        with argument "30UL" at byte position 29.
---
 extensions/libip6t_REJECT.c |   13 +++++++------
 extensions/libipt_REJECT.c  |   11 ++++++-----
 extensions/libxt_sctp.c     |    2 +-
 libiptc/libiptc.c           |    4 ++--
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 8085321..aeba996 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -27,7 +27,7 @@ static const struct reject_names reject_table[] = {
 	{"icmp6-adm-prohibited", "adm-prohibited",
 		IP6T_ICMP6_ADM_PROHIBITED, "ICMPv6 administratively prohibited"},
 #if 0
-	{"icmp6-not-neighbor", "not-neighbor"},
+	{"icmp6-not-neighbor", "not-neighbor",
 		IP6T_ICMP6_NOT_NEIGHBOR, "ICMPv6 not a neighbor"},
 #endif
 	{"icmp6-addr-unreachable", "addr-unreach",
@@ -102,9 +102,10 @@ static void REJECT_print(const void *ip, const struct xt_entry_target *target,
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
-		if (reject_table[i].with == reject->with)
+		if (reject_table[i].with == reject->with) {
+			printf(" reject-with %s", reject_table[i].name);
 			break;
-	printf(" reject-with %s", reject_table[i].name);
+		}
 }
 
 static void REJECT_save(const void *ip, const struct xt_entry_target *target)
@@ -114,10 +115,10 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
-		if (reject_table[i].with == reject->with)
+		if (reject_table[i].with == reject->with) {
+			printf(" --reject-with %s", reject_table[i].name);
 			break;
-
-	printf(" --reject-with %s", reject_table[i].name);
+		}
 }
 
 static struct xtables_target reject_tg6_reg = {
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 362c65e..39ddeb5 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -122,9 +122,10 @@ static void REJECT_print(const void *ip, const struct xt_entry_target *target,
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
-		if (reject_table[i].with == reject->with)
+		if (reject_table[i].with == reject->with) {
+			printf(" reject-with %s", reject_table[i].name);
 			break;
-	printf(" reject-with %s", reject_table[i].name);
+		}
 }
 
 static void REJECT_save(const void *ip, const struct xt_entry_target *target)
@@ -134,10 +135,10 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
-		if (reject_table[i].with == reject->with)
+		if (reject_table[i].with == reject->with) {
+			printf(" --reject-with %s", reject_table[i].name);
 			break;
-
-	printf(" --reject-with %s", reject_table[i].name);
+		}
 }
 
 static struct xtables_target reject_tg_reg = {
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 5dbc36f..da9fb22 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -374,7 +374,7 @@ print_chunk(uint32_t chunknum, int numeric)
 
 		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
 			if (sctp_chunk_names[i].chunk_type == chunknum)
-				printf("%s", sctp_chunk_names[chunknum].name);
+				printf("%s", sctp_chunk_names[i].name);
 	}
 }
 
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index c2cb0bc..1a99047 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1121,7 +1121,7 @@ static inline int iptcc_compile_rule (struct xtc_handle *h, STRUCT_REPLACE *repl
 		STRUCT_STANDARD_TARGET *t;
 		t = (STRUCT_STANDARD_TARGET *)GET_TARGET(r->entry);
 		/* memset for memcmp convenience on delete/replace */
-		memset(t->target.u.user.name, 0, FUNCTION_MAXNAMELEN);
+		memset(t->target.u.user.name, 0, XT_EXTENSION_MAXNAMELEN);
 		strcpy(t->target.u.user.name, STANDARD_TARGET);
 		/* Jumps can only happen to builtin chains, so we
 		 * can safely assume that they always have a header */
@@ -1675,7 +1675,7 @@ iptcc_standard_map(struct rule_head *r, int verdict)
 		return 0;
 	}
 	/* memset for memcmp convenience on delete/replace */
-	memset(t->target.u.user.name, 0, FUNCTION_MAXNAMELEN);
+	memset(t->target.u.user.name, 0, XT_EXTENSION_MAXNAMELEN);
 	strcpy(t->target.u.user.name, STANDARD_TARGET);
 	t->verdict = verdict;
 
-- 
1.7.5.2

