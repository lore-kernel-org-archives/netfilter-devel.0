Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DD1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E66461101
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhKFVBP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVBP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE266C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:33 -0700 (PDT)
Received: from localhost ([::1]:58776 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlk-00047K-71; Sat, 06 Nov 2021 21:58:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/10] xshared: Share save_rule_details() with legacy
Date:   Sat,  6 Nov 2021 21:57:50 +0100
Message-Id: <20211106205756.14529-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function combines printing of input and output interfaces and
protocol parameter, all being IP family independent. Extend the function
to print fragment option ('-f'), too if requested. While being at it,
drop unused iptables_command_state parameter and reorder the remaining
ones a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c  | 23 +++--------------------
 iptables/iptables.c   | 28 ++++------------------------
 iptables/nft-ipv4.c   | 13 ++++---------
 iptables/nft-ipv6.c   |  6 +++---
 iptables/nft-shared.c | 29 -----------------------------
 iptables/nft-shared.h |  6 ------
 iptables/xshared.c    | 32 ++++++++++++++++++++++++++++++++
 iptables/xshared.h    |  4 ++++
 8 files changed, 50 insertions(+), 91 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 1c9b076196e8f..eacbf704f9769 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -707,19 +707,6 @@ list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	return found;
 }
 
-static void print_proto(uint16_t proto, int invert)
-{
-	if (proto) {
-		const char *pname = proto_to_name(proto, 0);
-		const char *invertstr = invert ? " !" : "";
-
-		if (pname)
-			printf("%s -p %s", invertstr, pname);
-		else
-			printf("%s -p %u", invertstr, proto);
-	}
-}
-
 static int print_match_save(const struct xt_entry_match *e,
 			const struct ip6t_ip6 *ip)
 {
@@ -795,13 +782,9 @@ void print_rule6(const struct ip6t_entry *e,
 	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
 			e->ipv6.invflags & IP6T_INV_DSTIP);
 
-	save_iface('i', e->ipv6.iniface, e->ipv6.iniface_mask,
-		    e->ipv6.invflags & IP6T_INV_VIA_IN);
-
-	save_iface('o', e->ipv6.outiface, e->ipv6.outiface_mask,
-		    e->ipv6.invflags & IP6T_INV_VIA_OUT);
-
-	print_proto(e->ipv6.proto, e->ipv6.invflags & XT_INV_PROTO);
+	save_rule_details(e->ipv6.iniface, e->ipv6.iniface_mask,
+			  e->ipv6.outiface, e->ipv6.outiface_mask,
+			  e->ipv6.proto, 0, e->ipv6.invflags);
 
 #if 0
 	/* not definied in ipv6
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 7802bd6d95bd0..85fb7bdcd0ca1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -699,19 +699,6 @@ list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	return found;
 }
 
-static void print_proto(uint16_t proto, int invert)
-{
-	if (proto) {
-		const char *pname = proto_to_name(proto, 0);
-		const char *invertstr = invert ? " !" : "";
-
-		if (pname)
-			printf("%s -p %s", invertstr, pname);
-		else
-			printf("%s -p %u", invertstr, proto);
-	}
-}
-
 #define IP_PARTS_NATIVE(n)			\
 (unsigned int)((n)>>24)&0xFF,			\
 (unsigned int)((n)>>16)&0xFF,			\
@@ -804,17 +791,10 @@ void print_rule4(const struct ipt_entry *e,
 	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
 			e->ip.invflags & IPT_INV_DSTIP);
 
-	save_iface('i', e->ip.iniface, e->ip.iniface_mask,
-		    e->ip.invflags & IPT_INV_VIA_IN);
-
-	save_iface('o', e->ip.outiface, e->ip.outiface_mask,
-		    e->ip.invflags & IPT_INV_VIA_OUT);
-
-	print_proto(e->ip.proto, e->ip.invflags & XT_INV_PROTO);
-
-	if (e->ip.flags & IPT_F_FRAG)
-		printf("%s -f",
-		       e->ip.invflags & IPT_INV_FRAG ? " !" : "");
+	save_rule_details(e->ip.iniface, e->ip.iniface_mask,
+			  e->ip.outiface, e->ip.outiface_mask,
+			  e->ip.proto, e->ip.flags & IPT_F_FRAG,
+			  e->ip.invflags);
 
 	/* Print matchinfo part */
 	if (e->target_offset)
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 287112d0e6b99..39d6e61232cdb 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -317,15 +317,10 @@ static void nft_ipv4_save_rule(const void *data, unsigned int format)
 	save_ipv4_addr('d', &cs->fw.ip.dst, cs->fw.ip.dmsk.s_addr,
 		       cs->fw.ip.invflags & IPT_INV_DSTIP);
 
-	save_rule_details(cs, cs->fw.ip.invflags, cs->fw.ip.proto,
-			  cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
-			  cs->fw.ip.outiface, cs->fw.ip.outiface_mask);
-
-	if (cs->fw.ip.flags & IPT_F_FRAG) {
-		if (cs->fw.ip.invflags & IPT_INV_FRAG)
-			printf(" !");
-		printf(" -f");
-	}
+	save_rule_details(cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+			  cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
+			  cs->fw.ip.proto, cs->fw.ip.flags & IPT_F_FRAG,
+			  cs->fw.ip.invflags);
 
 	save_matches_and_target(cs, cs->fw.ip.flags & IPT_F_GOTO,
 				&cs->fw, format);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 845937b180b06..0c73cedd71c96 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -253,9 +253,9 @@ static void nft_ipv6_save_rule(const void *data, unsigned int format)
 	save_ipv6_addr('d', &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
 		       cs->fw6.ipv6.invflags & IP6T_INV_DSTIP);
 
-	save_rule_details(cs, cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
-			  cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
-			  cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask);
+	save_rule_details(cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
+			  cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask,
+			  cs->fw6.ipv6.proto, 0, cs->fw6.ipv6.invflags);
 
 	save_matches_and_target(cs, cs->fw6.ipv6.flags & IP6T_F_GOTO,
 				&cs->fw6, format);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b86cc086bed1c..168c224627fd0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -785,35 +785,6 @@ void print_rule_details(const struct iptables_command_state *cs,
 	}
 }
 
-void save_rule_details(const struct iptables_command_state *cs,
-		       uint8_t invflags, uint16_t proto,
-		       const char *iniface,
-		       unsigned const char *iniface_mask,
-		       const char *outiface,
-		       unsigned const char *outiface_mask)
-{
-	if (iniface != NULL) {
-		save_iface('i', iniface, iniface_mask,
-			    invflags & IPT_INV_VIA_IN);
-	}
-	if (outiface != NULL) {
-		save_iface('o', outiface, outiface_mask,
-			    invflags & IPT_INV_VIA_OUT);
-	}
-
-	if (proto > 0) {
-		const char *pname = proto_to_name(proto, 0);
-
-		if (invflags & XT_INV_PROTO)
-			printf(" !");
-
-		if (pname)
-			printf(" -p %s", pname);
-		else
-			printf(" -p %u", proto);
-	}
-}
-
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy)
 {
 	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 339c46e7f5b06..cac5757ff0708 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -173,12 +173,6 @@ void print_rule_details(const struct iptables_command_state *cs,
 			unsigned int num, unsigned int format);
 void print_matches_and_target(struct iptables_command_state *cs,
 			      unsigned int format);
-void save_rule_details(const struct iptables_command_state *cs,
-		       uint8_t invflags, uint16_t proto,
-		       const char *iniface,
-		       unsigned const char *iniface_mask,
-		       const char *outiface,
-		       unsigned const char *outiface_mask);
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy);
 void save_matches_and_target(const struct iptables_command_state *cs,
 			     bool goto_flag, const void *fw,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index db03aaaa324b0..db701ead4811f 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -941,3 +941,35 @@ void parse_chain(const char *chainname)
 			xtables_error(PARAMETER_PROBLEM,
 				      "Invalid chain name `%s'", chainname);
 }
+
+void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
+		       const char *outiface, unsigned const char *outiface_mask,
+		       uint16_t proto, int frag, uint8_t invflags)
+{
+	if (iniface != NULL) {
+		save_iface('i', iniface, iniface_mask,
+			    invflags & IPT_INV_VIA_IN);
+	}
+	if (outiface != NULL) {
+		save_iface('o', outiface, outiface_mask,
+			    invflags & IPT_INV_VIA_OUT);
+	}
+
+	if (proto > 0) {
+		const char *pname = proto_to_name(proto, 0);
+
+		if (invflags & XT_INV_PROTO)
+			printf(" !");
+
+		if (pname)
+			printf(" -p %s", pname);
+		else
+			printf(" -p %u", proto);
+	}
+
+	if (frag) {
+		if (invflags & IPT_INV_FRAG)
+			printf(" !");
+		printf(" -f");
+	}
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 3281ce584476c..484ade126404c 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -242,4 +242,8 @@ void parse_chain(const char *chainname);
 void generic_opt_check(int command, int options);
 char opt2char(int option);
 
+void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
+		       const char *outiface, unsigned const char *outiface_mask,
+		       uint16_t proto, int frag, uint8_t invflags);
+
 #endif /* IPTABLES_XSHARED_H */
-- 
2.33.0

