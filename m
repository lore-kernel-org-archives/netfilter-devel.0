From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] iptables: replace open-coded sizeof by ARRAY_SIZE
Date: Tue, 26 May 2009 13:26:25 +0200
Message-ID: <1243337187-18216-4-git-send-email-jengelh@medozas.de>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34628 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZEZL0a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:26:30 -0400
In-Reply-To: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/dscp_helper.c        |    6 ++----
 extensions/libip6t_LOG.c        |   12 +++---------
 extensions/libip6t_REJECT.c     |   11 ++++-------
 extensions/libip6t_icmp6.c      |   11 ++++-------
 extensions/libip6t_ipv6header.c |   16 +++++-----------
 extensions/libip6t_mh.c         |    7 +++----
 extensions/libipt_LOG.c         |   12 +++---------
 extensions/libipt_REJECT.c      |    9 ++++-----
 extensions/libipt_icmp.c        |   11 ++++-------
 extensions/libxt_dccp.c         |    5 ++---
 extensions/libxt_hashlimit.c    |    3 +--
 extensions/libxt_limit.c        |    3 +--
 extensions/libxt_pkttype.c      |   12 +++---------
 extensions/libxt_sctp.c         |   18 ++----------------
 extensions/libxt_tcp.c          |    9 +++------
 ip6tables-restore.c             |    2 +-
 iptables-restore.c              |    2 +-
 iptables-xml.c                  |    2 +-
 18 files changed, 47 insertions(+), 104 deletions(-)

diff --git a/extensions/dscp_helper.c b/extensions/dscp_helper.c
index 8fa0f4a..75b1fec 100644
--- a/extensions/dscp_helper.c
+++ b/extensions/dscp_helper.c
@@ -51,7 +51,7 @@ class_to_dscp(const char *name)
 {
 	unsigned int i;
 
-	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
+	for (i = 0; i < ARRAY_SIZE(ds_classes); i++) {
 		if (!strncasecmp(name, ds_classes[i].name,
 					strlen(ds_classes[i].name)))
 			return ds_classes[i].dscp;
@@ -68,11 +68,9 @@ dscp_to_name(unsigned int dscp)
 {
 	int i;
 
-	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
+	for (i = 0; i < ARRAY_SIZE(ds_classes); ++i) 
 		if (dscp == ds_classes[i].dscp)
 			return ds_classes[i].name;
-	}
-
 
 	xtables_error(PARAMETER_PROBLEM,
 			"Invalid DSCP value `%d'\n", dscp);
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 390cb97..f713201 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -72,9 +72,7 @@ parse_level(const char *level)
 	if (!xtables_strtoui(level, NULL, &lev, 0, 7)) {
 		unsigned int i = 0;
 
-		for (i = 0;
-		     i < sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(ip6t_log_names); ++i)
 			if (strncasecmp(level, ip6t_log_names[i].name,
 					strlen(level)) == 0) {
 				if (set++)
@@ -83,7 +81,6 @@ parse_level(const char *level)
 						   level);
 				lev = ip6t_log_names[i].level;
 			}
-		}
 
 		if (!set)
 			xtables_error(PARAMETER_PROBLEM,
@@ -201,15 +198,12 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
 		printf("flags %u level %u ",
 		       loginfo->logflags, loginfo->level);
 	else {
-		for (i = 0;
-		     i < sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(ip6t_log_names); ++i)
 			if (loginfo->level == ip6t_log_names[i].level) {
 				printf("level %s ", ip6t_log_names[i].name);
 				break;
 			}
-		}
-		if (i == sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names))
+		if (i == ARRAY_SIZE(ip6t_log_names))
 			printf("UNKNOWN level %u ", loginfo->level);
 		if (loginfo->logflags & IP6T_LOG_TCPSEQ)
 			printf("tcp-sequence ");
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 527f595..9ad3b68 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -43,7 +43,7 @@ print_reject_types(void)
 
 	printf("Valid reject types:\n");
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i) {
 		printf("    %-25s\t%s\n", reject_table[i].name, reject_table[i].desc);
 		printf("    %-25s\talias\n", reject_table[i].alias);
 	}
@@ -79,7 +79,6 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct ip6t_reject_info *reject = 
 		(struct ip6t_reject_info *)(*target)->data;
-	unsigned int limit = sizeof(reject_table)/sizeof(struct reject_names);
 	unsigned int i;
 
 	switch(c) {
@@ -87,13 +86,12 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
-		for (i = 0; i < limit; i++) {
+		for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
 			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
 			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
 				reject->with = reject_table[i].with;
 				return 1;
 			}
-		}
 		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
 	default:
 		/* Fall through */
@@ -109,10 +107,9 @@ static void REJECT_print(const void *ip, const struct xt_entry_target *target,
 		= (const struct ip6t_reject_info *)target->data;
 	unsigned int i;
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
 		if (reject_table[i].with == reject->with)
 			break;
-	}
 	printf("reject-with %s ", reject_table[i].name);
 }
 
@@ -122,7 +119,7 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 		= (const struct ip6t_reject_info *)target->data;
 	unsigned int i;
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++)
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
 		if (reject_table[i].with == reject->with)
 			break;
 
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 0678aac..e41a670 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -59,7 +59,7 @@ print_icmpv6types(void)
 	unsigned int i;
 	printf("Valid ICMPv6 Types:");
 
-	for (i = 0; i < sizeof(icmpv6_codes)/sizeof(struct icmpv6_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(icmpv6_codes); ++i) {
 		if (i && icmpv6_codes[i].type == icmpv6_codes[i-1].type) {
 			if (icmpv6_codes[i].code_min == icmpv6_codes[i-1].code_min
 			    && (icmpv6_codes[i].code_max
@@ -91,7 +91,7 @@ static const struct option icmp6_opts[] = {
 static void
 parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 {
-	unsigned int limit = sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
+	static const unsigned int limit = ARRAY_SIZE(icmpv6_codes);
 	unsigned int match = limit;
 	unsigned int i;
 
@@ -181,16 +181,13 @@ static void print_icmpv6type(u_int8_t type,
 	if (!numeric) {
 		unsigned int i;
 
-		for (i = 0;
-		     i < sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(icmpv6_codes); ++i)
 			if (icmpv6_codes[i].type == type
 			    && icmpv6_codes[i].code_min == code_min
 			    && icmpv6_codes[i].code_max == code_max)
 				break;
-		}
 
-		if (i != sizeof(icmpv6_codes)/sizeof(struct icmpv6_names)) {
+		if (i != ARRAY_SIZE(icmpv6_codes)) {
 			printf("%s%s ",
 			       invert ? "!" : "",
 			       icmpv6_codes[i].name);
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 479b313..2674c8f 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -77,7 +77,7 @@ proto_to_name(u_int8_t proto, int nolookup)
                         return pent->p_name;
         }
 
-        for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
+        for (i = 0; i < ARRAY_SIZE(chain_protos); ++i)
                 if (chain_protos[i].num == proto)
                         return chain_protos[i].name;
 
@@ -94,16 +94,13 @@ name_to_proto(const char *s)
         	proto = pent->p_proto;
         else {
         	unsigned int i;
-        	for (i = 0;
-        		i < sizeof(chain_protos)/sizeof(struct pprot);
-        		i++) {
+        	for (i = 0; i < ARRAY_SIZE(chain_protos); ++i)
         		if (strcmp(s, chain_protos[i].name) == 0) {
         			proto = chain_protos[i].num;
         			break;
         		}
-        	}
 
-        	if (i == sizeof(chain_protos)/sizeof(struct pprot))
+		if (i == ARRAY_SIZE(chain_protos))
 			xtables_error(PARAMETER_PROBLEM,
         			"unknown header `%s' specified",
         			s);
@@ -116,16 +113,13 @@ static unsigned int
 add_proto_to_mask(int proto){
 	unsigned int i=0, flag=0;
 
-	for (i = 0;
-		i < sizeof(chain_flags)/sizeof(struct numflag);
-		i++) {
+	for (i = 0; i < ARRAY_SIZE(chain_flags); ++i)
 			if (proto == chain_flags[i].proto){
 				flag = chain_flags[i].flag;
 				break;
 			}
-	}
 
-	if (i == sizeof(chain_flags)/sizeof(struct numflag))
+	if (i == ARRAY_SIZE(chain_flags))
 		xtables_error(PARAMETER_PROBLEM,
 		"unknown header `%d' specified",
 		proto);
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 9711f76..47d5544 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -48,7 +48,7 @@ static void print_types_all(void)
 	unsigned int i;
 	printf("Valid MH types:");
 
-	for (i = 0; i < sizeof(mh_names)/sizeof(struct mh_name); i++) {
+	for (i = 0; i < ARRAY_SIZE(mh_names); ++i) {
 		if (i && mh_names[i].type == mh_names[i-1].type)
 			printf(" (%s)", mh_names[i].name);
 		else
@@ -75,7 +75,7 @@ static void mh_init(struct xt_entry_match *m)
 static unsigned int name_to_type(const char *name)
 {
 	int namelen = strlen(name);
-	unsigned int limit = sizeof(mh_names)/sizeof(struct mh_name);
+	static const unsigned int limit = ARRAY_SIZE(mh_names);
 	unsigned int match = limit;
 	unsigned int i;
 
@@ -151,10 +151,9 @@ static const char *type_to_name(u_int8_t type)
 {
 	unsigned int i;
 
-	for (i = 0; i < sizeof(mh_names)/sizeof(struct mh_name); i++) {
+	for (i = 0; i < ARRAY_SIZE(mh_names); ++i)
 		if (mh_names[i].type == type)
 			return mh_names[i].name;
-	}
 
 	return NULL;
 }
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index ebcb574..5b90033 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -72,9 +72,7 @@ parse_level(const char *level)
 	if (!xtables_strtoui(level, NULL, &lev, 0, 7)) {
 		unsigned int i = 0;
 
-		for (i = 0;
-		     i < sizeof(ipt_log_names) / sizeof(struct ipt_log_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(ipt_log_names); ++i)
 			if (strncasecmp(level, ipt_log_names[i].name,
 					strlen(level)) == 0) {
 				if (set++)
@@ -83,7 +81,6 @@ parse_level(const char *level)
 						   level);
 				lev = ipt_log_names[i].level;
 			}
-		}
 
 		if (!set)
 			xtables_error(PARAMETER_PROBLEM,
@@ -201,15 +198,12 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
 		printf("flags %u level %u ",
 		       loginfo->logflags, loginfo->level);
 	else {
-		for (i = 0;
-		     i < sizeof(ipt_log_names) / sizeof(struct ipt_log_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(ipt_log_names); ++i)
 			if (loginfo->level == ipt_log_names[i].level) {
 				printf("level %s ", ipt_log_names[i].name);
 				break;
 			}
-		}
-		if (i == sizeof(ipt_log_names) / sizeof(struct ipt_log_names))
+		if (i == ARRAY_SIZE(ipt_log_names))
 			printf("UNKNOWN level %u ", loginfo->level);
 		if (loginfo->logflags & IPT_LOG_TCPSEQ)
 			printf("tcp-sequence ");
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 5b23f54..888ff39 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -56,7 +56,7 @@ print_reject_types(void)
 
 	printf("Valid reject types:\n");
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i) {
 		printf("    %-25s\t%s\n", reject_table[i].name, reject_table[i].desc);
 		printf("    %-25s\talias\n", reject_table[i].alias);
 	}
@@ -93,7 +93,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
-	unsigned int limit = sizeof(reject_table)/sizeof(struct reject_names);
+	static const unsigned int limit = ARRAY_SIZE(reject_table);
 	unsigned int i;
 
 	switch(c) {
@@ -128,10 +128,9 @@ static void REJECT_print(const void *ip, const struct xt_entry_target *target,
 		= (const struct ipt_reject_info *)target->data;
 	unsigned int i;
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
 		if (reject_table[i].with == reject->with)
 			break;
-	}
 	printf("reject-with %s ", reject_table[i].name);
 }
 
@@ -141,7 +140,7 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 		= (const struct ipt_reject_info *)target->data;
 	unsigned int i;
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++)
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
 		if (reject_table[i].with == reject->with)
 			break;
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 15c1787..5667955 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -83,7 +83,7 @@ print_icmptypes(void)
 	unsigned int i;
 	printf("Valid ICMP Types:");
 
-	for (i = 0; i < sizeof(icmp_codes)/sizeof(struct icmp_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(icmp_codes); ++i) {
 		if (i && icmp_codes[i].type == icmp_codes[i-1].type) {
 			if (icmp_codes[i].code_min == icmp_codes[i-1].code_min
 			    && (icmp_codes[i].code_max
@@ -115,7 +115,7 @@ static const struct option icmp_opts[] = {
 static void 
 parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 {
-	unsigned int limit = sizeof(icmp_codes)/sizeof(struct icmp_names);
+	static const unsigned int limit = ARRAY_SIZE(icmp_codes);
 	unsigned int match = limit;
 	unsigned int i;
 
@@ -206,16 +206,13 @@ static void print_icmptype(u_int8_t type,
 	if (!numeric) {
 		unsigned int i;
 
-		for (i = 0;
-		     i < sizeof(icmp_codes)/sizeof(struct icmp_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(icmp_codes); ++i)
 			if (icmp_codes[i].type == type
 			    && icmp_codes[i].code_min == code_min
 			    && icmp_codes[i].code_max == code_max)
 				break;
-		}
 
-		if (i != sizeof(icmp_codes)/sizeof(struct icmp_names)) {
+		if (i != ARRAY_SIZE(icmp_codes)) {
 			printf("%s%s ",
 			       invert ? "!" : "",
 			       icmp_codes[i].name);
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 413624e..7321145 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -102,13 +102,12 @@ parse_dccp_types(const char *typestring)
 
 	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
 		unsigned int i;
-		for (i = 0; i < sizeof(dccp_pkt_types)/sizeof(char *); i++) {
+		for (i = 0; i < ARRAY_SIZE(dccp_pkt_types); ++i)
 			if (!strcasecmp(dccp_pkt_types[i], ptr)) {
 				typemask |= (1 << i);
 				break;
 			}
-		}
-		if (i == sizeof(dccp_pkt_types)/sizeof(char *))
+		if (i == ARRAY_SIZE(dccp_pkt_types))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown DCCP type `%s'", ptr);
 	}
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index aa56c65..84dd786 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -485,11 +485,10 @@ static void print_rate(u_int32_t period)
 {
 	unsigned int i;
 
-	for (i = 1; i < sizeof(rates)/sizeof(struct rates); i++) {
+	for (i = 1; i < ARRAY_SIZE(rates); ++i)
 		if (period > rates[i].mult
             || rates[i].mult/period < rates[i].mult%period)
 			break;
-	}
 
 	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
 }
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 18224f3..498f009 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -132,11 +132,10 @@ static void print_rate(u_int32_t period)
 {
 	unsigned int i;
 
-	for (i = 1; i < sizeof(rates)/sizeof(struct rates); i++) {
+	for (i = 1; i < ARRAY_SIZE(rates); ++i)
 		if (period > rates[i].mult
             || rates[i].mult/period < rates[i].mult%period)
 			break;
-	}
 
 	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
 }
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 50af3ed..e3db2aa 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -46,11 +46,9 @@ static void print_types(void)
 	unsigned int	i;
 	
 	printf("Valid packet types:\n");
-	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
-	{
+	for (i = 0; i < ARRAY_SIZE(supported_types); ++i)
 		if(supported_types[i].printhelp == 1)
 			printf("\t%-14s\t\t%s\n", supported_types[i].name, supported_types[i].help);
-	}
 	printf("\n");
 }
 
@@ -71,14 +69,12 @@ static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
 {
 	unsigned int	i;
 	
-	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
-	{
+	for (i = 0; i < ARRAY_SIZE(supported_types); ++i)
 		if(strcasecmp(pkttype, supported_types[i].name)==0)
 		{
 			info->pkttype=supported_types[i].pkttype;
 			return;
 		}
-	}
 	
 	xtables_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
 }
@@ -115,14 +111,12 @@ static void print_pkttype(const struct xt_pkttype_info *info)
 {
 	unsigned int	i;
 	
-	for (i = 0; i < sizeof(supported_types)/sizeof(struct pkttypes); i++)
-	{
+	for (i = 0; i < ARRAY_SIZE(supported_types); ++i)
 		if(supported_types[i].pkttype==info->pkttype)
 		{
 			printf("%s ", supported_types[i].name);
 			return;
 		}
-	}
 
 	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
 }
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index b889406..829eade 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -17,20 +17,8 @@
 #include <netinet/in.h>
 #include <xtables.h>
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
-
 #include <linux/netfilter/xt_sctp.h>
 
-/* Some ZS!#@:$%*#$! has replaced the ELEMCOUNT macro in ipt_sctp.h with
- * ARRAY_SIZE without noticing that this file is used from userspace,
- * and userspace doesn't have ARRAY_SIZE */
-
-#ifndef ELEMCOUNT
-#define ELEMCOUNT ARRAY_SIZE
-#endif
-
 #if 0
 #define DEBUGP(format, first...) printf(format, ##first)
 #define static
@@ -198,7 +186,7 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 			*chunk_flags++ = 0;
 		}
 		
-		for (i = 0; i < ELEMCOUNT(sctp_chunk_names); i++) {
+		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
 			if (strcasecmp(sctp_chunk_names[i].name, ptr) == 0) {
 				DEBUGP("Chunk num %d\n", sctp_chunk_names[i].chunk_type);
 				SCTP_CHUNKMAP_SET(einfo->chunkmap, 
@@ -206,7 +194,6 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 				found = 1;
 				break;
 			}
-		}
 		if (!found)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown sctp chunk `%s'", ptr);
@@ -389,10 +376,9 @@ print_chunk(u_int32_t chunknum, int numeric)
 	else {
 		int i;
 
-		for (i = 0; i < ELEMCOUNT(sctp_chunk_names); i++) {
+		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
 			if (sctp_chunk_names[i].chunk_type == chunknum)
 				printf("%s", sctp_chunk_names[chunknum].name);
-		}
 	}
 }
 
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index d2ad53b..5ea9ebd 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -86,18 +86,15 @@ parse_tcp_flag(const char *flags)
 
 	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
 		unsigned int i;
-		for (i = 0;
-		     i < sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names);
-		     i++) {
+		for (i = 0; i < ARRAY_SIZE(tcp_flag_names); ++i)
 			if (strcasecmp(tcp_flag_names[i].name, ptr) == 0) {
 				ret |= tcp_flag_names[i].flag;
 				break;
 			}
-		}
-		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
+		if (i == ARRAY_SIZE(tcp_flag_names))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown TCP flag `%s'", ptr);
-		}
+	}
 
 	free(buffer);
 	return ret;
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 324dd1f..1d5efea 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -99,7 +99,7 @@ static int newargc;
  * returns true if argument added, false otherwise */
 static int add_argv(char *what) {
 	DEBUGP("add_argv: %s\n", what);
-	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
+	if (what && newargc + 1 < ARRAY_SIZE(newargv)) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
diff --git a/iptables-restore.c b/iptables-restore.c
index f1c5e3e..2a797cc 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -99,7 +99,7 @@ static int newargc;
  * returns true if argument added, false otherwise */
 static int add_argv(char *what) {
 	DEBUGP("add_argv: %s\n", what);
-	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
+	if (what && newargc + 1 < ARRAY_SIZE(newargv)) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
diff --git a/iptables-xml.c b/iptables-xml.c
index 543715b..e5d1941 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -110,7 +110,7 @@ static int
 add_argv(char *what, int quoted)
 {
 	DEBUGP("add_argv: %d %s\n", newargc, what);
-	if (what && ((newargc + 1) < sizeof(newargv) / sizeof(char *))) {
+	if (what && newargc + 1 < ARRAY_SIZE(newargv)) {
 		newargv[newargc] = strdup(what);
 		newargvattr[newargc] = quoted;
 		newargc++;
-- 
1.6.3.1

