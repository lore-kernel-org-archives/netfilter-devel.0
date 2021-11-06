Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1C3C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D57F8610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhKFVBh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVBg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C120C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:55 -0700 (PDT)
Received: from localhost ([::1]:58800 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSm5-00048b-Mi; Sat, 06 Nov 2021 21:58:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/10] xshared: Share print_rule_details() with legacy
Date:   Sat,  6 Nov 2021 21:57:52 +0100
Message-Id: <20211106205756.14529-7-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have to pass pointer to counters directly since different fields are
being used for some reason.

Since proto_to_name() is not used outside of xshared.c anymore, make it
static.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c  | 21 ++-------------------
 iptables/iptables.c   | 21 ++-------------------
 iptables/nft-ipv4.c   |  4 ++--
 iptables/nft-ipv6.c   |  5 ++---
 iptables/nft-shared.c | 27 ---------------------------
 iptables/nft-shared.h |  4 ----
 iptables/xshared.c    | 27 ++++++++++++++++++++++++++-
 iptables/xshared.h    |  4 +++-
 8 files changed, 37 insertions(+), 76 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 5c118626a5d23..e0cc4e898fe6a 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -329,25 +329,8 @@ print_firewall(const struct ip6t_entry *fw,
 
 	t = ip6t_get_target((struct ip6t_entry *)fw);
 
-	if (format & FMT_LINENUMBERS)
-		printf(FMT("%-4u ", "%u "), num);
-
-	if (!(format & FMT_NOCOUNTS)) {
-		xtables_print_num(fw->counters.pcnt, format);
-		xtables_print_num(fw->counters.bcnt, format);
-	}
-
-	if (!(format & FMT_NOTARGET))
-		printf(FMT("%-9s ", "%s "), targname);
-
-	fputc(fw->ipv6.invflags & XT_INV_PROTO ? '!' : ' ', stdout);
-	{
-		const char *pname = proto_to_name(fw->ipv6.proto, format&FMT_NUMERIC);
-		if (pname)
-			printf(FMT("%-5s", "%s "), pname);
-		else
-			printf(FMT("%-5hu", "%hu "), fw->ipv6.proto);
-	}
+	print_rule_details(num, &fw->counters, targname, fw->ipv6.proto,
+			   fw->ipv6.flags, fw->ipv6.invflags, format);
 
 	if (format & FMT_OPTIONS) {
 		if (format & FMT_NOTABLE)
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 0d8beb04c0f99..29da40b1328d4 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -322,25 +322,8 @@ print_firewall(const struct ipt_entry *fw,
 	t = ipt_get_target((struct ipt_entry *)fw);
 	flags = fw->ip.flags;
 
-	if (format & FMT_LINENUMBERS)
-		printf(FMT("%-4u ", "%u "), num);
-
-	if (!(format & FMT_NOCOUNTS)) {
-		xtables_print_num(fw->counters.pcnt, format);
-		xtables_print_num(fw->counters.bcnt, format);
-	}
-
-	if (!(format & FMT_NOTARGET))
-		printf(FMT("%-9s ", "%s "), targname);
-
-	fputc(fw->ip.invflags & XT_INV_PROTO ? '!' : ' ', stdout);
-	{
-		const char *pname = proto_to_name(fw->ip.proto, format&FMT_NUMERIC);
-		if (pname)
-			printf(FMT("%-5s", "%s "), pname);
-		else
-			printf(FMT("%-5hu", "%hu "), fw->ip.proto);
-	}
+	print_rule_details(num, &fw->counters, targname, fw->ip.proto,
+			   fw->ip.flags, fw->ip.invflags, format);
 
 	if (format & FMT_OPTIONS) {
 		if (format & FMT_NOTABLE)
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index dcc009cf67a81..6b044642bd775 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -246,8 +246,8 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 
 	nft_rule_to_iptables_command_state(h, r, &cs);
 
-	print_rule_details(&cs, cs.jumpto, cs.fw.ip.flags,
-			   cs.fw.ip.invflags, cs.fw.ip.proto, num, format);
+	print_rule_details(num, &cs.counters, cs.jumpto, cs.fw.ip.proto,
+			   cs.fw.ip.flags, cs.fw.ip.invflags, format);
 	print_fragment(cs.fw.ip.flags, cs.fw.ip.invflags, format);
 	print_ifaces(cs.fw.ip.iniface, cs.fw.ip.outiface, cs.fw.ip.invflags,
 		     format);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0b35e0457a067..cb83f9e132e24 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -198,9 +198,8 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 
 	nft_rule_to_iptables_command_state(h, r, &cs);
 
-	print_rule_details(&cs, cs.jumpto, cs.fw6.ipv6.flags,
-			   cs.fw6.ipv6.invflags, cs.fw6.ipv6.proto,
-			   num, format);
+	print_rule_details(num, &cs.counters, cs.jumpto, cs.fw6.ipv6.proto,
+			   cs.fw6.ipv6.flags, cs.fw6.ipv6.invflags, format);
 	if (format & FMT_OPTIONS) {
 		if (format & FMT_NOTABLE)
 			fputs("opt ", stdout);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 168c224627fd0..eb0070075d9eb 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -758,33 +758,6 @@ void print_header(unsigned int format, const char *chain, const char *pol,
 	printf("\n");
 }
 
-void print_rule_details(const struct iptables_command_state *cs,
-			const char *targname, uint8_t flags,
-			uint8_t invflags, uint8_t proto,
-			unsigned int num, unsigned int format)
-{
-	if (format & FMT_LINENUMBERS)
-		printf(FMT("%-4u ", "%u "), num);
-
-	if (!(format & FMT_NOCOUNTS)) {
-		xtables_print_num(cs->counters.pcnt, format);
-		xtables_print_num(cs->counters.bcnt, format);
-	}
-
-	if (!(format & FMT_NOTARGET))
-		printf(FMT("%-9s ", "%s "), targname ? targname : "");
-
-	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
-	{
-		const char *pname =
-			proto_to_name(proto, format&FMT_NUMERIC);
-		if (pname)
-			printf(FMT("%-5s", "%s "), pname);
-		else
-			printf(FMT("%-5hu", "%hu "), proto);
-	}
-}
-
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy)
 {
 	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index cac5757ff0708..e18df20d9fc38 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -167,10 +167,6 @@ void nft_clear_iptables_command_state(struct iptables_command_state *cs);
 void print_header(unsigned int format, const char *chain, const char *pol,
 		  const struct xt_counters *counters, bool basechain,
 		  uint32_t refs, uint32_t entries);
-void print_rule_details(const struct iptables_command_state *cs,
-			const char *targname, uint8_t flags,
-			uint8_t invflags, uint8_t proto,
-			unsigned int num, unsigned int format);
 void print_matches_and_target(struct iptables_command_state *cs,
 			      unsigned int format);
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 3e06960fcf015..7f2e1a32914b0 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -48,7 +48,7 @@ void print_extension_helps(const struct xtables_target *t,
 	}
 }
 
-const char *
+static const char *
 proto_to_name(uint16_t proto, int nolookup)
 {
 	unsigned int i;
@@ -999,6 +999,31 @@ void parse_chain(const char *chainname)
 				      "Invalid chain name `%s'", chainname);
 }
 
+void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
+			const char *targname, uint8_t proto, uint8_t flags,
+			uint8_t invflags, unsigned int format)
+{
+	const char *pname = proto_to_name(proto, format&FMT_NUMERIC);
+
+	if (format & FMT_LINENUMBERS)
+		printf(FMT("%-4u ", "%u "), linenum);
+
+	if (!(format & FMT_NOCOUNTS)) {
+		xtables_print_num(ctrs->pcnt, format);
+		xtables_print_num(ctrs->bcnt, format);
+	}
+
+	if (!(format & FMT_NOTARGET))
+		printf(FMT("%-9s ", "%s "), targname ? targname : "");
+
+	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
+
+	if (pname)
+		printf(FMT("%-5s", "%s "), pname);
+	else
+		printf(FMT("%-5hu", "%hu "), proto);
+}
+
 void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
 		       const char *outiface, unsigned const char *outiface_mask,
 		       uint16_t proto, int frag, uint8_t invflags)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 46ad5a2962c71..9f0fa1438bdd3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -164,7 +164,6 @@ enum {
 
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
-extern const char *proto_to_name(uint16_t, int);
 extern int command_default(struct iptables_command_state *,
 	struct xtables_globals *, bool invert);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
@@ -246,6 +245,9 @@ void parse_chain(const char *chainname);
 void generic_opt_check(int command, int options);
 char opt2char(int option);
 
+void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
+			const char *targname, uint8_t proto, uint8_t flags,
+			uint8_t invflags, unsigned int format);
 void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
 		       const char *outiface, unsigned const char *outiface_mask,
 		       uint16_t proto, int frag, uint8_t invflags);
-- 
2.33.0

