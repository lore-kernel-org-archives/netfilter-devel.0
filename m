Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1BBC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8EF6120A
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhKFVB1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVB0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99565C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:44 -0700 (PDT)
Received: from localhost ([::1]:58788 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlv-00047z-1u; Sat, 06 Nov 2021 21:58:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/10] xshared: Share print_iface() function
Date:   Sat,  6 Nov 2021 21:57:49 +0100
Message-Id: <20211106205756.14529-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the three identical copies into one and name it 'save_iface' (as
the printed syntax is for "save"-format). Leave arptables alone for now,
its rather complicated whitespace printing doesn't allow for use of the
shared function. Also keep ebtables' custom implementation, it is used
for the --logical-in/--logical-out long-options, too. Apart from that,
ebtables-nft does not use a mask, at all.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c  | 30 ++----------------------------
 iptables/iptables.c   | 30 ++----------------------------
 iptables/nft-shared.c | 26 ++------------------------
 iptables/xshared.c    | 25 +++++++++++++++++++++++++
 iptables/xshared.h    |  2 ++
 5 files changed, 33 insertions(+), 80 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index ec0ae759875e7..1c9b076196e8f 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -707,32 +707,6 @@ list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	return found;
 }
 
-/* This assumes that mask is contiguous, and byte-bounded. */
-static void
-print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
-	unsigned int i;
-
-	if (mask[0] == 0)
-		return;
-
-	printf("%s -%c ", invert ? " !" : "", letter);
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-		} else {
-			/* we can access iface[i-1] here, because
-			 * a few lines above we make sure that mask[0] != 0 */
-			if (iface[i-1] != '\0')
-				printf("+");
-			break;
-		}
-	}
-}
-
 static void print_proto(uint16_t proto, int invert)
 {
 	if (proto) {
@@ -821,10 +795,10 @@ void print_rule6(const struct ip6t_entry *e,
 	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
 			e->ipv6.invflags & IP6T_INV_DSTIP);
 
-	print_iface('i', e->ipv6.iniface, e->ipv6.iniface_mask,
+	save_iface('i', e->ipv6.iniface, e->ipv6.iniface_mask,
 		    e->ipv6.invflags & IP6T_INV_VIA_IN);
 
-	print_iface('o', e->ipv6.outiface, e->ipv6.outiface_mask,
+	save_iface('o', e->ipv6.outiface, e->ipv6.outiface_mask,
 		    e->ipv6.invflags & IP6T_INV_VIA_OUT);
 
 	print_proto(e->ipv6.proto, e->ipv6.invflags & XT_INV_PROTO);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 246526a55a3c9..7802bd6d95bd0 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -720,32 +720,6 @@ static void print_proto(uint16_t proto, int invert)
 
 #define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
 
-/* This assumes that mask is contiguous, and byte-bounded. */
-static void
-print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
-	unsigned int i;
-
-	if (mask[0] == 0)
-		return;
-
-	printf("%s -%c ", invert ? " !" : "", letter);
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-		} else {
-			/* we can access iface[i-1] here, because
-			 * a few lines above we make sure that mask[0] != 0 */
-			if (iface[i-1] != '\0')
-				printf("+");
-			break;
-		}
-	}
-}
-
 static int print_match_save(const struct xt_entry_match *e,
 			const struct ipt_ip *ip)
 {
@@ -830,10 +804,10 @@ void print_rule4(const struct ipt_entry *e,
 	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
 			e->ip.invflags & IPT_INV_DSTIP);
 
-	print_iface('i', e->ip.iniface, e->ip.iniface_mask,
+	save_iface('i', e->ip.iniface, e->ip.iniface_mask,
 		    e->ip.invflags & IPT_INV_VIA_IN);
 
-	print_iface('o', e->ip.outiface, e->ip.outiface_mask,
+	save_iface('o', e->ip.outiface, e->ip.outiface_mask,
 		    e->ip.invflags & IPT_INV_VIA_OUT);
 
 	print_proto(e->ip.proto, e->ip.invflags & XT_INV_PROTO);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 082cc0e2df745..b86cc086bed1c 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -785,28 +785,6 @@ void print_rule_details(const struct iptables_command_state *cs,
 	}
 }
 
-static void
-print_iface(char letter, const char *iface, const unsigned char *mask, int inv)
-{
-	unsigned int i;
-
-	if (mask[0] == 0)
-		return;
-
-	printf("%s -%c ", inv ? " !" : "", letter);
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-			} else {
-				if (iface[i-1] != '\0')
-					printf("+");
-				break;
-		}
-	}
-}
-
 void save_rule_details(const struct iptables_command_state *cs,
 		       uint8_t invflags, uint16_t proto,
 		       const char *iniface,
@@ -815,11 +793,11 @@ void save_rule_details(const struct iptables_command_state *cs,
 		       unsigned const char *outiface_mask)
 {
 	if (iniface != NULL) {
-		print_iface('i', iniface, iniface_mask,
+		save_iface('i', iniface, iniface_mask,
 			    invflags & IPT_INV_VIA_IN);
 	}
 	if (outiface != NULL) {
-		print_iface('o', outiface, outiface_mask,
+		save_iface('o', outiface, outiface_mask,
 			    invflags & IPT_INV_VIA_OUT);
 	}
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index bd545d6b31908..db03aaaa324b0 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -637,6 +637,31 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 	printf(FMT("%-6s ", "out %s "), iface);
 }
 
+/* This assumes that mask is contiguous, and byte-bounded. */
+void save_iface(char letter, const char *iface,
+		const unsigned char *mask, int invert)
+{
+	unsigned int i;
+
+	if (mask[0] == 0)
+		return;
+
+	printf("%s -%c ", invert ? " !" : "", letter);
+
+	for (i = 0; i < IFNAMSIZ; i++) {
+		if (mask[i] != 0) {
+			if (iface[i] != '\0')
+				printf("%c", iface[i]);
+		} else {
+			/* we can access iface[i-1] here, because
+			 * a few lines above we make sure that mask[0] != 0 */
+			if (iface[i-1] != '\0')
+				printf("+");
+			break;
+		}
+	}
+}
+
 void command_match(struct iptables_command_state *cs, bool invert)
 {
 	struct option *opts = xt_params->opts;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 6d6acbca13da2..3281ce584476c 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -226,6 +226,8 @@ void print_ipv6_addresses(const struct ip6t_entry *fw6, unsigned int format);
 
 void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 		  unsigned int format);
+void save_iface(char letter, const char *iface,
+		const unsigned char *mask, int invert);
 
 void command_match(struct iptables_command_state *cs, bool invert);
 const char *xt_parse_target(const char *targetname);
-- 
2.33.0

