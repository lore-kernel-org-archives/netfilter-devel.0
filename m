Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38098C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FEE761360
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhFBPZx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhFBPZw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:25:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE79C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:08 -0700 (PDT)
Received: from localhost ([::1]:43080 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSj0-0007Nk-EY; Wed, 02 Jun 2021 17:24:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 8/9] libxtables: Introduce xtables_strdup() and use it everywhere
Date:   Wed,  2 Jun 2021 17:24:02 +0200
Message-Id: <20210602152403.5689-9-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602152403.5689-1-phil@nwl.cc>
References: <20210602152403.5689-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This wraps strdup(), checking for errors.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.c          |  3 ++-
 extensions/libebt_ip6.c         |  2 +-
 extensions/libebt_stp.c         |  3 ++-
 extensions/libip6t_DNAT.c       |  4 +---
 extensions/libip6t_SNAT.c       |  4 +---
 extensions/libip6t_dst.c        |  8 +++-----
 extensions/libip6t_hbh.c        |  7 +++----
 extensions/libip6t_ipv6header.c |  2 +-
 extensions/libip6t_mh.c         |  2 +-
 extensions/libip6t_rt.c         |  7 +++----
 extensions/libipt_DNAT.c        |  8 ++------
 extensions/libipt_SNAT.c        |  4 +---
 extensions/libxt_dccp.c         |  2 +-
 extensions/libxt_hashlimit.c    |  5 +----
 extensions/libxt_iprange.c      |  4 +---
 extensions/libxt_multiport.c    |  6 ++----
 extensions/libxt_sctp.c         |  4 ++--
 extensions/libxt_set.h          |  4 ++--
 extensions/libxt_tcp.c          |  4 ++--
 include/xtables.h               |  1 +
 iptables/iptables-xml.c         |  4 ++--
 iptables/nft-cache.c            |  4 ++--
 iptables/nft-cmd.c              | 13 +++++++------
 iptables/xshared.c              |  2 +-
 libxtables/xtables.c            | 12 ++++++++++++
 libxtables/xtoptions.c          | 14 +++-----------
 26 files changed, 60 insertions(+), 73 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index acb9bfcdbbd9f..51649ffb3c305 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -175,7 +175,8 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 	char *buffer;
 	char *cp;
 
-	buffer = strdup(portstring);
+	buffer = xtables_strdup(portstring);
+
 	if ((cp = strchr(buffer, ':')) == NULL)
 		ports[0] = ports[1] = xtables_parse_port(buffer, NULL);
 	else {
diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index 3cc39271d4658..a686a285c3cb8 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -93,7 +93,7 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 	char *buffer;
 	char *cp;
 
-	buffer = strdup(portstring);
+	buffer = xtables_strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
 		ports[0] = ports[1] = xtables_parse_port(buffer, NULL);
 	else {
diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 81ba572c33c1a..3e9e24474eb61 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -90,7 +90,8 @@ static int parse_range(const char *portstring, void *lower, void *upper,
 	uint32_t low_nr, upp_nr;
 	int ret = 0;
 
-	buffer = strdup(portstring);
+	buffer = xtables_strdup(portstring);
+
 	if ((cp = strchr(buffer, ':')) == NULL) {
 		low_nr = strtoul(buffer, &end, 10);
 		if (*end || low_nr < min || low_nr > max) {
diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 89c5ceb153250..f1ad81436316b 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -58,9 +58,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range2 *range, int rev)
 	char *arg, *start, *end = NULL, *colon = NULL, *dash, *error;
 	const struct in6_addr *ip;
 
-	arg = strdup(orig_arg);
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
+	arg = xtables_strdup(orig_arg);
 
 	start = strchr(arg, '[');
 	if (start == NULL) {
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 7d74b3d76a93c..6d19614c7c708 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -52,9 +52,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 	char *arg, *start, *end = NULL, *colon = NULL, *dash, *error;
 	const struct in6_addr *ip;
 
-	arg = strdup(orig_arg);
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
+	arg = xtables_strdup(orig_arg);
 
 	start = strchr(arg, '[');
 	if (start == NULL) {
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index fe7e3403468ce..bf0e3e436665d 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -57,11 +57,9 @@ parse_options(const char *optsstr, uint16_t *opts)
 {
         char *buffer, *cp, *next, *range;
         unsigned int i;
-	
-	buffer = strdup(optsstr);
-        if (!buffer)
-		xtables_error(OTHER_PROBLEM, "strdup failed");
-			
+
+	buffer = xtables_strdup(optsstr);
+
         for (cp = buffer, i = 0; cp && i < IP6T_OPTS_OPTSNR; cp = next, i++)
         {
                 next = strchr(cp, ',');
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 4cebecfd3d2f5..74e87cda7eea1 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -57,10 +57,9 @@ parse_options(const char *optsstr, uint16_t *opts)
 {
         char *buffer, *cp, *next, *range;
         unsigned int i;
-	
-	buffer = strdup(optsstr);
-	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
-			
+
+	buffer = xtables_strdup(optsstr);
+
         for (cp=buffer, i=0; cp && i<IP6T_OPTS_OPTSNR; cp=next,i++)
         {
                 next=strchr(cp, ',');
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 6f03087bb79d8..9e34562966f8b 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -147,7 +147,7 @@ parse_header(const char *flags) {
         char *ptr;
         char *buffer;
 
-        buffer = strdup(flags);
+        buffer = xtables_strdup(flags);
 
         for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) 
 		ret |= add_proto_to_mask(name_to_proto(ptr));
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index f4c0fd9fc0bca..64675405ac724 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -107,7 +107,7 @@ static void parse_mh_types(const char *mhtype, uint8_t *types)
 	char *buffer;
 	char *cp;
 
-	buffer = strdup(mhtype);
+	buffer = xtables_strdup(mhtype);
 	if ((cp = strchr(buffer, ':')) == NULL)
 		types[0] = types[1] = name_to_type(buffer);
 	else {
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 3cb3b249d8995..9708b5a0c42f3 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -73,10 +73,9 @@ parse_addresses(const char *addrstr, struct in6_addr *addrp)
 {
         char *buffer, *cp, *next;
         unsigned int i;
-	
-	buffer = strdup(addrstr);
-	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
-			
+
+	buffer = xtables_strdup(addrstr);
+
         for (cp=buffer, i=0; cp && i<IP6T_RT_HOPS; cp=next,i++)
         {
                 next=strchr(cp, ',');
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 4907a2e83d066..5b33fd23f6e36 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -79,9 +79,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
-	arg = strdup(orig_arg);
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
+	arg = xtables_strdup(orig_arg);
 	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
 
@@ -302,9 +300,7 @@ parse_to_v2(const char *orig_arg, int portok, struct nf_nat_range2 *range)
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
-	arg = strdup(orig_arg);
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
+	arg = xtables_strdup(orig_arg);
 
 	colon = strchr(arg, ':');
 	if (colon) {
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index e92d811c2bc93..c655439ec9192 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -73,9 +73,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
-	arg = strdup(orig_arg);
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
+	arg = xtables_strdup(orig_arg);
 	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index aea3e20be4818..abd420fcc0032 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -85,7 +85,7 @@ parse_dccp_types(const char *typestring)
 	uint16_t typemask = 0;
 	char *ptr, *buffer;
 
-	buffer = strdup(typestring);
+	buffer = xtables_strdup(typestring);
 
 	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
 		unsigned int i;
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 7f1d2a402c4fd..3f3c43010ee2a 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -508,10 +508,7 @@ static void hashlimit_mt6_init(struct xt_entry_match *match)
 static int parse_mode(uint32_t *mode, const char *option_arg)
 {
 	char *tok;
-	char *arg = strdup(option_arg);
-
-	if (!arg)
-		return -1;
+	char *arg = xtables_strdup(option_arg);
 
 	for (tok = strtok(arg, ",|");
 	     tok;
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 8be2481497b8d..04ce7b364f1c6 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -73,11 +73,9 @@ iprange_parse_spec(const char *from, const char *to, union nf_inet_addr *range,
 static void iprange_parse_range(const char *oarg, union nf_inet_addr *range,
 				uint8_t family, const char *optname)
 {
-	char *arg = strdup(oarg);
+	char *arg = xtables_strdup(oarg);
 	char *dash;
 
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
 	dash = strchr(arg, '-');
 	if (dash == NULL) {
 		iprange_parse_spec(arg, arg, range, family, optname);
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 07ad4cfd4e519..4a42fa38238b9 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -87,8 +87,7 @@ parse_multi_ports(const char *portstring, uint16_t *ports, const char *proto)
 	char *buffer, *cp, *next;
 	unsigned int i;
 
-	buffer = strdup(portstring);
-	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
+	buffer = xtables_strdup(portstring);
 
 	for (cp=buffer, i=0; cp && i<XT_MULTI_PORTS; cp=next,i++)
 	{
@@ -109,8 +108,7 @@ parse_multi_ports_v1(const char *portstring,
 	char *buffer, *cp, *next, *range;
 	unsigned int i;
 
-	buffer = strdup(portstring);
-	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
+	buffer = xtables_strdup(portstring);
 
 	for (i=0; i<XT_MULTI_PORTS; i++)
 		multiinfo->pflags[i] = 0;
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 5d8ab85cacf42..a4c5415f2036e 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -69,7 +69,7 @@ parse_sctp_ports(const char *portstring,
 	char *buffer;
 	char *cp;
 
-	buffer = strdup(portstring);
+	buffer = xtables_strdup(portstring);
 	DEBUGP("%s\n", portstring);
 	if ((cp = strchr(buffer, ':')) == NULL) {
 		ports[0] = ports[1] = xtables_parse_port(buffer, "sctp");
@@ -164,7 +164,7 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 	int found = 0;
 	char *chunk_flags;
 
-	buffer = strdup(chunks);
+	buffer = xtables_strdup(chunks);
 	DEBUGP("Buffer: %s\n", buffer);
 
 	SCTP_CHUNKMAP_RESET(einfo->chunkmap);
diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 41dfbd30fc7c1..ad895a7504d9d 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -141,7 +141,7 @@ get_set_byname(const char *setname, struct xt_set_info *info)
 static void
 parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
 {
-	char *saved = strdup(opt_arg);
+	char *saved = xtables_strdup(opt_arg);
 	char *ptr, *tmp = saved;
 	int i = 0;
 	
@@ -167,7 +167,7 @@ parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
 static void
 parse_dirs(const char *opt_arg, struct xt_set_info *info)
 {
-	char *saved = strdup(opt_arg);
+	char *saved = xtables_strdup(opt_arg);
 	char *ptr, *tmp = saved;
 	
 	while (info->dim < IPSET_DIM_MAX && tmp != NULL) {
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 58f3c0a0c3c28..383e4db5b5e23 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -43,7 +43,7 @@ parse_tcp_ports(const char *portstring, uint16_t *ports)
 	char *buffer;
 	char *cp;
 
-	buffer = strdup(portstring);
+	buffer = xtables_strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
 		ports[0] = ports[1] = xtables_parse_port(buffer, "tcp");
 	else {
@@ -83,7 +83,7 @@ parse_tcp_flag(const char *flags)
 	char *ptr;
 	char *buffer;
 
-	buffer = strdup(flags);
+	buffer = xtables_strdup(flags);
 
 	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
 		unsigned int i;
diff --git a/include/xtables.h b/include/xtables.h
index 1fd5f63ac4b69..5b13f348f768d 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -453,6 +453,7 @@ extern void xtables_set_nfproto(uint8_t);
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
 extern void *xtables_realloc(void *, size_t);
+char *xtables_strdup(const char *);
 
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 98d03dda98d2b..6cf059fb67292 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -213,8 +213,8 @@ saveChain(char *chain, char *policy, struct xt_counters *ctr)
 			   "%s: line %u chain name invalid\n",
 			   prog_name, line);
 
-	chains[nextChain].chain = strdup(chain);
-	chains[nextChain].policy = strdup(policy);
+	chains[nextChain].chain = xtables_strdup(chain);
+	chains[nextChain].policy = xtables_strdup(policy);
 	chains[nextChain].count = *ctr;
 	chains[nextChain].created = 0;
 	nextChain++;
diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 8fbf9727826d8..2c88301cc7445 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -40,7 +40,7 @@ static void cache_chain_list_insert(struct list_head *list, const char *name)
 	}
 
 	new = xtables_malloc(sizeof(*new));
-	new->name = strdup(name);
+	new->name = xtables_strdup(name);
 	list_add_tail(&new->head, pos ? &pos->head : list);
 }
 
@@ -56,7 +56,7 @@ void nft_cache_level_set(struct nft_handle *h, int level,
 		return;
 
 	if (!req->table)
-		req->table = strdup(cmd->table);
+		req->table = xtables_strdup(cmd->table);
 	else
 		assert(!strcmp(req->table, cmd->table));
 
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index c3f6c14e0b99e..a0c76a795e59c 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -11,6 +11,7 @@
 
 #include <stdlib.h>
 #include <string.h>
+#include <xtables.h>
 #include "nft.h"
 #include "nft-cmd.h"
 
@@ -27,9 +28,9 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 		return NULL;
 
 	cmd->command = command;
-	cmd->table = strdup(table);
+	cmd->table = xtables_strdup(table);
 	if (chain)
-		cmd->chain = strdup(chain);
+		cmd->chain = xtables_strdup(chain);
 	cmd->rulenum = rulenum;
 	cmd->verbose = verbose;
 
@@ -43,7 +44,7 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 		cmd->obj.rule = rule;
 
 		if (!state->target && strlen(state->jumpto) > 0)
-			cmd->jumpto = strdup(state->jumpto);
+			cmd->jumpto = xtables_strdup(state->jumpto);
 	}
 
 	list_add_tail(&cmd->head, &h->cmd_list);
@@ -238,7 +239,7 @@ int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
 	if (!cmd)
 		return 0;
 
-	cmd->rename = strdup(newname);
+	cmd->rename = xtables_strdup(newname);
 
 	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
@@ -304,7 +305,7 @@ int nft_cmd_chain_set(struct nft_handle *h, const char *table,
 	if (!cmd)
 		return 0;
 
-	cmd->policy = strdup(policy);
+	cmd->policy = xtables_strdup(policy);
 	if (counters)
 		cmd->counters = *counters;
 
@@ -389,7 +390,7 @@ int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 	if (!cmd)
 		return 0;
 
-	cmd->policy = strdup(policy);
+	cmd->policy = xtables_strdup(policy);
 
 	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 49a88de518466..ed3e9c5a4426a 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -435,7 +435,7 @@ void add_argv(struct argv_store *store, const char *what, int quoted)
 		xtables_error(PARAMETER_PROBLEM,
 			      "Trying to store NULL argument\n");
 
-	store->argv[store->argc] = strdup(what);
+	store->argv[store->argc] = xtables_strdup(what);
 	store->argvattr[store->argc] = quoted;
 	store->argv[++store->argc] = NULL;
 }
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 82815cae70576..77bc1493116c7 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -369,6 +369,18 @@ void *xtables_realloc(void *ptr, size_t size)
 	return p;
 }
 
+char *xtables_strdup(const char *s)
+{
+	char *dup = strdup(s);
+
+	if (!dup) {
+		perror("ip[6]tables: strdup failed");
+		exit(1);
+	}
+
+	return dup;
+}
+
 static char *get_modprobe(void)
 {
 	int procfile;
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 0dcdf607f4678..9d3ac5c8066cb 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -604,9 +604,7 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 	unsigned int maxiter;
 	int value;
 
-	wp_arg = lo_arg = strdup(cb->arg);
-	if (lo_arg == NULL)
-		xt_params->exit_err(RESOURCE_PROBLEM, "strdup");
+	wp_arg = lo_arg = xtables_strdup(cb->arg);
 
 	maxiter = entry->size / esize;
 	if (maxiter == 0)
@@ -747,9 +745,7 @@ static void xtopt_parse_hostmask(struct xt_option_call *cb)
 		xtopt_parse_host(cb);
 		return;
 	}
-	work = strdup(orig_arg);
-	if (work == NULL)
-		xt_params->exit_err(PARAMETER_PROBLEM, "strdup");
+	work = xtables_strdup(orig_arg);
 	p = strchr(work, '/'); /* by def this can't be NULL now */
 	*p++ = '\0';
 	/*
@@ -1139,11 +1135,7 @@ struct xtables_lmap *xtables_lmap_init(const char *file)
 			goto out;
 		}
 		lmap_this->id   = id;
-		lmap_this->name = strdup(cur);
-		if (lmap_this->name == NULL) {
-			free(lmap_this);
-			goto out;
-		}
+		lmap_this->name = xtables_strdup(cur);
 		lmap_this->next = NULL;
 
 		if (lmap_prev != NULL)
-- 
2.31.1

