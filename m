Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FD1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDEA2610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhKFVBc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbhKFVBb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF99EC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:49 -0700 (PDT)
Received: from localhost ([::1]:58794 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSm0-00048I-CH; Sat, 06 Nov 2021 21:58:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/10] xshared: Share print_fragment() with legacy
Date:   Sat,  6 Nov 2021 21:57:53 +0100
Message-Id: <20211106205756.14529-8-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also add a fake mode to make it suitable for ip6tables. This is required
because IPT_F_FRAG value clashes with IP6T_F_PROTO, so ip6tables rules
might seem to have IPT_F_FRAG bit set.

While being at it, drop the local variable 'flags' from
print_firewall().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c |  8 +-------
 iptables/iptables.c  | 10 +---------
 iptables/nft-ipv4.c  | 15 +--------------
 iptables/nft-ipv6.c  |  6 +-----
 iptables/xshared.c   | 18 ++++++++++++++++++
 iptables/xshared.h   |  3 +++
 6 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index e0cc4e898fe6a..3d304d441c10a 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -332,13 +332,7 @@ print_firewall(const struct ip6t_entry *fw,
 	print_rule_details(num, &fw->counters, targname, fw->ipv6.proto,
 			   fw->ipv6.flags, fw->ipv6.invflags, format);
 
-	if (format & FMT_OPTIONS) {
-		if (format & FMT_NOTABLE)
-			fputs("opt ", stdout);
-		fputc(' ', stdout); /* Invert flag of FRAG */
-		fputc(' ', stdout); /* -f */
-		fputc(' ', stdout);
-	}
+	print_fragment(fw->ipv6.flags, fw->ipv6.invflags, format, true);
 
 	print_ifaces(fw->ipv6.iniface, fw->ipv6.outiface,
 		     fw->ipv6.invflags, format);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 29da40b1328d4..12a5423ec271d 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -311,7 +311,6 @@ print_firewall(const struct ipt_entry *fw,
 {
 	struct xtables_target *target, *tg;
 	const struct xt_entry_target *t;
-	uint8_t flags;
 
 	if (!iptc_is_chain(targname, handle))
 		target = xtables_find_target(targname, XTF_TRY_LOAD);
@@ -320,18 +319,11 @@ print_firewall(const struct ipt_entry *fw,
 		         XTF_LOAD_MUST_SUCCEED);
 
 	t = ipt_get_target((struct ipt_entry *)fw);
-	flags = fw->ip.flags;
 
 	print_rule_details(num, &fw->counters, targname, fw->ip.proto,
 			   fw->ip.flags, fw->ip.invflags, format);
 
-	if (format & FMT_OPTIONS) {
-		if (format & FMT_NOTABLE)
-			fputs("opt ", stdout);
-		fputc(fw->ip.invflags & IPT_INV_FRAG ? '!' : '-', stdout);
-		fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
-		fputc(' ', stdout);
-	}
+	print_fragment(fw->ip.flags, fw->ip.invflags, format, false);
 
 	print_ifaces(fw->ip.iniface, fw->ip.outiface, fw->ip.invflags, format);
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 6b044642bd775..f36260980e829 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -226,19 +226,6 @@ static void nft_ipv4_parse_immediate(const char *jumpto, bool nft_goto,
 		cs->fw.ip.flags |= IPT_F_GOTO;
 }
 
-static void print_fragment(unsigned int flags, unsigned int invflags,
-			   unsigned int format)
-{
-	if (!(format & FMT_OPTIONS))
-		return;
-
-	if (format & FMT_NOTABLE)
-		fputs("opt ", stdout);
-	fputc(invflags & IPT_INV_FRAG ? '!' : '-', stdout);
-	fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
-	fputc(' ', stdout);
-}
-
 static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 				unsigned int num, unsigned int format)
 {
@@ -248,7 +235,7 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 
 	print_rule_details(num, &cs.counters, cs.jumpto, cs.fw.ip.proto,
 			   cs.fw.ip.flags, cs.fw.ip.invflags, format);
-	print_fragment(cs.fw.ip.flags, cs.fw.ip.invflags, format);
+	print_fragment(cs.fw.ip.flags, cs.fw.ip.invflags, format, false);
 	print_ifaces(cs.fw.ip.iniface, cs.fw.ip.outiface, cs.fw.ip.invflags,
 		     format);
 	print_ipv4_addresses(&cs.fw, format);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index cb83f9e132e24..132130880a43a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -200,11 +200,7 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 
 	print_rule_details(num, &cs.counters, cs.jumpto, cs.fw6.ipv6.proto,
 			   cs.fw6.ipv6.flags, cs.fw6.ipv6.invflags, format);
-	if (format & FMT_OPTIONS) {
-		if (format & FMT_NOTABLE)
-			fputs("opt ", stdout);
-		fputs("   ", stdout);
-	}
+	print_fragment(cs.fw6.ipv6.flags, cs.fw6.ipv6.invflags, format, true);
 	print_ifaces(cs.fw6.ipv6.iniface, cs.fw6.ipv6.outiface,
 		     cs.fw6.ipv6.invflags, format);
 	print_ipv6_addresses(&cs.fw6, format);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 7f2e1a32914b0..e8c8939cf8e3e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -669,6 +669,24 @@ void save_ipv6_addr(char letter, const struct in6_addr *addr,
 		printf("/%d", l);
 }
 
+void print_fragment(unsigned int flags, unsigned int invflags,
+		    unsigned int format, bool fake)
+{
+	if (!(format & FMT_OPTIONS))
+		return;
+
+	if (format & FMT_NOTABLE)
+		fputs("opt ", stdout);
+
+	if (fake) {
+		fputs("  ", stdout);
+	} else {
+		fputc(invflags & IPT_INV_FRAG ? '!' : '-', stdout);
+		fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
+	}
+	fputc(' ', stdout);
+}
+
 /* Luckily, IPT_INV_VIA_IN and IPT_INV_VIA_OUT
  * have the same values as IP6T_INV_VIA_IN and IP6T_INV_VIA_OUT
  * so this function serves for both iptables and ip6tables */
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 9f0fa1438bdd3..48f314cac8f45 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -232,6 +232,9 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 void save_iface(char letter, const char *iface,
 		const unsigned char *mask, int invert);
 
+void print_fragment(unsigned int flags, unsigned int invflags,
+		    unsigned int format, bool fake);
+
 void command_match(struct iptables_command_state *cs, bool invert);
 const char *xt_parse_target(const char *targetname);
 void command_jump(struct iptables_command_state *cs, const char *jumpto);
-- 
2.33.0

