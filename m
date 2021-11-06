Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F3BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7702D611EE
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhKFVBn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVBn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BA0C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:59:01 -0700 (PDT)
Received: from localhost ([::1]:58806 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSmB-00048p-1G; Sat, 06 Nov 2021 21:58:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/10] nft: Change whitespace printing in save_rule callback
Date:   Sat,  6 Nov 2021 21:57:48 +0100
Message-Id: <20211106205756.14529-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This aligns whitespace printing with legacy iptables' print_rule4() in
order to prepare for further code-sharing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    |  1 +
 iptables/nft-bridge.c | 10 ++++++++--
 iptables/nft-ipv4.c   |  6 +++---
 iptables/nft-ipv6.c   |  8 ++++----
 iptables/nft-shared.c | 26 ++++++++++++--------------
 iptables/nft.c        |  4 ++--
 6 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 32eb91add4f1e..b7536e61a255f 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -479,6 +479,7 @@ nft_arp_save_rule(const void *data, unsigned int format)
 
 	format |= FMT_NUMERIC;
 
+	printf(" ");
 	nft_arp_print_rule_details(cs, format);
 	if (cs->target && cs->target->save)
 		cs->target->save(&cs->fw, cs->target->t);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 11f3df3582aa5..cc2a48dbf7741 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -601,7 +601,7 @@ static void print_protocol(uint16_t ethproto, bool invert, unsigned int bitmask)
 		printf("%s ", ent->e_name);
 }
 
-static void nft_bridge_save_rule(const void *data, unsigned int format)
+static void __nft_bridge_save_rule(const void *data, unsigned int format)
 {
 	const struct iptables_command_state *cs = data;
 
@@ -652,6 +652,12 @@ static void nft_bridge_save_rule(const void *data, unsigned int format)
 		fputc('\n', stdout);
 }
 
+static void nft_bridge_save_rule(const void *data, unsigned int format)
+{
+	printf(" ");
+	__nft_bridge_save_rule(data, format);
+}
+
 static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 				  unsigned int num, unsigned int format)
 {
@@ -661,7 +667,7 @@ static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 		printf("%d ", num);
 
 	nft_rule_to_ebtables_command_state(h, r, &cs);
-	nft_bridge_save_rule(&cs, format);
+	__nft_bridge_save_rule(&cs, format);
 	ebt_cs_clean(&cs);
 }
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index febd7673af4f8..287112d0e6b99 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -303,7 +303,7 @@ static void save_ipv4_addr(char letter, const struct in_addr *addr,
 	if (!mask && !invert && !addr->s_addr)
 		return;
 
-	printf("%s-%c %s/%s ", invert ? "! " : "", letter,
+	printf("%s -%c %s/%s", invert ? " !" : "", letter,
 	       inet_ntop(AF_INET, addr, addrbuf, sizeof(addrbuf)),
 	       mask_to_str(mask));
 }
@@ -323,8 +323,8 @@ static void nft_ipv4_save_rule(const void *data, unsigned int format)
 
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		if (cs->fw.ip.invflags & IPT_INV_FRAG)
-			printf("! ");
-		printf("-f ");
+			printf(" !");
+		printf(" -f");
 	}
 
 	save_matches_and_target(cs, cs->fw.ip.flags & IPT_F_GOTO,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index f0e64bbd4ab23..845937b180b06 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -234,14 +234,14 @@ static void save_ipv6_addr(char letter, const struct in6_addr *addr,
 	if (!invert && l == 0)
 		return;
 
-	printf("%s-%c %s",
-		invert ? "! " : "", letter,
+	printf("%s -%c %s",
+		invert ? " !" : "", letter,
 		inet_ntop(AF_INET6, addr, addr_str, sizeof(addr_str)));
 
 	if (l == -1)
-		printf("/%s ", inet_ntop(AF_INET6, mask, addr_str, sizeof(addr_str)));
+		printf("/%s", inet_ntop(AF_INET6, mask, addr_str, sizeof(addr_str)));
 	else
-		printf("/%d ", l);
+		printf("/%d", l);
 }
 
 static void nft_ipv6_save_rule(const void *data, unsigned int format)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 72727270026ee..082cc0e2df745 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -793,7 +793,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask, int inv)
 	if (mask[0] == 0)
 		return;
 
-	printf("%s-%c ", inv ? "! " : "", letter);
+	printf("%s -%c ", inv ? " !" : "", letter);
 
 	for (i = 0; i < IFNAMSIZ; i++) {
 		if (mask[i] != 0) {
@@ -805,8 +805,6 @@ print_iface(char letter, const char *iface, const unsigned char *mask, int inv)
 				break;
 		}
 	}
-
-	printf(" ");
 }
 
 void save_rule_details(const struct iptables_command_state *cs,
@@ -829,12 +827,12 @@ void save_rule_details(const struct iptables_command_state *cs,
 		const char *pname = proto_to_name(proto, 0);
 
 		if (invflags & XT_INV_PROTO)
-			printf("! ");
+			printf(" !");
 
 		if (pname)
-			printf("-p %s ", pname);
+			printf(" -p %s", pname);
 		else
-			printf("-p %u ", proto);
+			printf(" -p %u", proto);
 	}
 }
 
@@ -856,33 +854,33 @@ void save_matches_and_target(const struct iptables_command_state *cs,
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
 		if (matchp->match->alias) {
-			printf("-m %s",
+			printf(" -m %s",
 			       matchp->match->alias(matchp->match->m));
 		} else
-			printf("-m %s", matchp->match->name);
+			printf(" -m %s", matchp->match->name);
 
 		if (matchp->match->save != NULL) {
 			/* cs->fw union makes the trick */
 			matchp->match->save(fw, matchp->match->m);
 		}
-		printf(" ");
 	}
 
 	if ((format & (FMT_NOCOUNTS | FMT_C_COUNTS)) == FMT_C_COUNTS)
-		printf("-c %llu %llu ",
+		printf(" -c %llu %llu",
 		       (unsigned long long)cs->counters.pcnt,
 		       (unsigned long long)cs->counters.bcnt);
 
 	if (cs->target != NULL) {
 		if (cs->target->alias) {
-			printf("-j %s", cs->target->alias(cs->target->t));
+			printf(" -j %s", cs->target->alias(cs->target->t));
 		} else
-			printf("-j %s", cs->jumpto);
+			printf(" -j %s", cs->jumpto);
 
-		if (cs->target->save != NULL)
+		if (cs->target->save != NULL) {
 			cs->target->save(fw, cs->target->t);
+		}
 	} else if (strlen(cs->jumpto) > 0) {
-		printf("-%c %s", goto_flag ? 'g' : 'j', cs->jumpto);
+		printf(" -%c %s", goto_flag ? 'g' : 'j', cs->jumpto);
 	}
 
 	printf("\n");
diff --git a/iptables/nft.c b/iptables/nft.c
index 1d3f3a3da1cbb..282d417f3bc85 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1513,10 +1513,10 @@ nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 	/* print chain name */
 	switch(type) {
 	case NFT_RULE_APPEND:
-		printf("-A %s ", chain);
+		printf("-A %s", chain);
 		break;
 	case NFT_RULE_DEL:
-		printf("-D %s ", chain);
+		printf("-D %s", chain);
 		break;
 	}
 
-- 
2.33.0

