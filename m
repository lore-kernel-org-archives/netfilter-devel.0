From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 05/13] Constify data structures
Date: Thu, 4 Oct 2007 12:12:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209460.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58023 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbXJDKMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:12:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 9DAE81C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:12:06 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Constify more data structures. Make functions static.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_LOG.c     |    2 +-
 extensions/libip6t_REJECT.c  |    2 +-
 extensions/libip6t_policy.c  |    2 +-
 extensions/libipt_LOG.c      |    2 +-
 extensions/libipt_policy.c   |    2 +-
 extensions/libipt_realm.c    |    4 ++--
 extensions/libxt_CLASSIFY.c  |    2 +-
 extensions/libxt_dccp.c      |    2 +-
 extensions/libxt_hashlimit.c |    2 +-
 extensions/libxt_limit.c     |    2 +-
 extensions/libxt_sctp.c      |    2 +-
 extensions/libxt_tcp.c       |    2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

Index: iptables/extensions/libip6t_LOG.c
===================================================================
--- iptables.orig/extensions/libip6t_LOG.c
+++ iptables/extensions/libip6t_LOG.c
@@ -57,7 +57,7 @@ struct ip6t_log_names {
 	unsigned int level;
 };
 
-static struct ip6t_log_names ip6t_log_names[]
+static const struct ip6t_log_names ip6t_log_names[]
 = { { .name = "alert",   .level = LOG_ALERT },
     { .name = "crit",    .level = LOG_CRIT },
     { .name = "debug",   .level = LOG_DEBUG },
Index: iptables/extensions/libip6t_REJECT.c
===================================================================
--- iptables.orig/extensions/libip6t_REJECT.c
+++ iptables/extensions/libip6t_REJECT.c
@@ -145,7 +145,7 @@ static void save(const void *ip,
 	printf("--reject-with %s ", reject_table[i].name);
 }
 
-struct ip6tables_target reject = {
+static struct ip6tables_target reject = {
 	.name = "REJECT",
 	.version	= IPTABLES_VERSION,
 	.size 		= IP6T_ALIGN(sizeof(struct ip6t_reject_info)),
Index: iptables/extensions/libip6t_policy.c
===================================================================
--- iptables.orig/extensions/libip6t_policy.c
+++ iptables/extensions/libip6t_policy.c
@@ -452,7 +452,7 @@ static void save(const void *ip, const s
 	}
 }
 
-struct ip6tables_match policy = {
+static struct ip6tables_match policy = {
 	.name		= "policy",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
Index: iptables/extensions/libipt_LOG.c
===================================================================
--- iptables.orig/extensions/libipt_LOG.c
+++ iptables/extensions/libipt_LOG.c
@@ -57,7 +57,7 @@ struct ipt_log_names {
 	unsigned int level;
 };
 
-static struct ipt_log_names ipt_log_names[]
+static const struct ipt_log_names ipt_log_names[]
 = { { .name = "alert",   .level = LOG_ALERT },
     { .name = "crit",    .level = LOG_CRIT },
     { .name = "debug",   .level = LOG_DEBUG },
Index: iptables/extensions/libipt_policy.c
===================================================================
--- iptables.orig/extensions/libipt_policy.c
+++ iptables/extensions/libipt_policy.c
@@ -410,7 +410,7 @@ static void save(const void *ip, const s
 	}
 }
 
-struct iptables_match policy = {
+static struct iptables_match policy = {
 	.name		= "policy",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_policy_info)),
Index: iptables/extensions/libipt_realm.c
===================================================================
--- iptables.orig/extensions/libipt_realm.c
+++ iptables/extensions/libipt_realm.c
@@ -116,7 +116,7 @@ static void load_realms(void)
 }
 
 /* get realm id for name, -1 if error/not found */
-int realm_name2id(const char* name)
+static int realm_name2id(const char* name)
 {
 	struct realmname* cur;
 
@@ -134,7 +134,7 @@ int realm_name2id(const char* name)
 }
 
 /* get realm name for id, NULL if error/not found */
-const char* realm_id2name(int id)
+static const char *realm_id2name(int id)
 {
 	struct realmname* cur;
 
Index: iptables/extensions/libxt_CLASSIFY.c
===================================================================
--- iptables.orig/extensions/libxt_CLASSIFY.c
+++ iptables/extensions/libxt_CLASSIFY.c
@@ -26,7 +26,7 @@ static const struct option opts[] = {
 	{ }
 };
 
-int string_to_priority(const char *s, unsigned int *p)
+static int string_to_priority(const char *s, unsigned int *p)
 {
 	unsigned int i, j;
 
Index: iptables/extensions/libxt_dccp.c
===================================================================
--- iptables.orig/extensions/libxt_dccp.c
+++ iptables/extensions/libxt_dccp.c
@@ -81,7 +81,7 @@ parse_dccp_ports(const char *portstring,
 	free(buffer);
 }
 
-static char *dccp_pkt_types[] = {
+static const char *const dccp_pkt_types[] = {
 	[DCCP_PKT_REQUEST] 	= "REQUEST",
 	[DCCP_PKT_RESPONSE]	= "RESPONSE",
 	[DCCP_PKT_DATA]		= "DATA",
Index: iptables/extensions/libxt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.c
+++ iptables/extensions/libxt_hashlimit.c
@@ -249,7 +249,7 @@ static void final_check(unsigned int fla
 				"You have to specify --hashlimit-name");
 }
 
-static struct rates
+static const struct rates
 {
 	const char *name;
 	u_int32_t mult;
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -126,7 +126,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static struct rates
+static const struct rates
 {
 	const char *name;
 	u_int32_t mult;
Index: iptables/extensions/libxt_sctp.c
===================================================================
--- iptables.orig/extensions/libxt_sctp.c
+++ iptables/extensions/libxt_sctp.c
@@ -110,7 +110,7 @@ struct sctp_chunk_names {
 };
 
 /*'ALL' and 'NONE' will be treated specially. */
-static struct sctp_chunk_names sctp_chunk_names[]
+static const struct sctp_chunk_names sctp_chunk_names[]
 = { { .name = "DATA", 		.chunk_type = 0,   .valid_flags = "-----UBE"},
     { .name = "INIT", 		.chunk_type = 1,   .valid_flags = "--------"},
     { .name = "INIT_ACK", 	.chunk_type = 2,   .valid_flags = "--------"},
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -66,7 +66,7 @@ struct tcp_flag_names {
 	unsigned int flag;
 };
 
-static struct tcp_flag_names tcp_flag_names[]
+static const struct tcp_flag_names tcp_flag_names[]
 = { { "FIN", 0x01 },
     { "SYN", 0x02 },
     { "RST", 0x04 },
