Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C2AC54EE9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Sep 2022 22:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiI0WPh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Sep 2022 18:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiI0WPg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2022 18:15:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920098FD44
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2022 15:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HrnrErQg2cP0cWjkrRjjjhRhZYMguMJT+NSqWnHKRYk=; b=OBiNfEJ3CqThw/plz4DN++8thK
        0YYkW+SGh6MSYI4ZKweBaoUT+J0EAxajbV0fDNcS4rDiCCdtx/0jXL1Z7l2qimJtHVGmAPXnvWmQd
        0xBf7TFfKpSL9q5PiRrDjKP/LkaMTE92oKXPINOaIJWYz75jbjkWv6rVgviqpPLn7abfl4y2Ynsn4
        IWRiBcaa4oJjWrywF06tCKCwubz4SYw3tMu7pqQZqdbHSp1FHZsdBKeYoROzrLhcvZyP1owwgmBsK
        QqrmtZ4B8nsidLbMcE8lPgqdgbuHjCEMHofx7uAJ2U1eyr7qLeilt653AfeqDeut1/4CupjHCTE9h
        Ps3Qaknw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odIrT-00005P-KK
        for netfilter-devel@vger.kernel.org; Wed, 28 Sep 2022 00:15:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/5] ebtables: Support '-p Length'
Date:   Wed, 28 Sep 2022 00:15:12 +0200
Message-Id: <20220927221512.7400-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927221512.7400-1-phil@nwl.cc>
References: <20220927221512.7400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To match on Ethernet frames using the etherproto field as length value,
ebtables accepts the special protocol name "LENGTH". Implement this in
ebtables-nft using a native match for 'ether type < 0x0600'.

Since extension 802_3 matches are valid only with such Ethernet frames,
add a local add_match() wrapper which complains if the extension is used
without '-p Length' parameter. Legacy ebtables does this within the
extension's final_check callback, but it's not possible here due for lack of
fw->bitmask field access.

While being at it, add xlate support, adjust tests and make ebtables-nft
print the case-insensitive argument with capital 'L' like legacy
ebtables does.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/generic.txlate |  6 +++++
 extensions/libebt_802_3.t |  6 +++--
 iptables/nft-bridge.c     | 46 ++++++++++++++++++++++++++++++---------
 3 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index 9ae9a5b54c1b9..6779d6f86dec8 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -67,6 +67,12 @@ nft add rule bridge filter FORWARD iifname != "iname" meta ibrname "ilogname" oi
 ebtables-translate -I INPUT -p ip -d 1:2:3:4:5:6/ff:ff:ff:ff:00:00
 nft insert rule bridge filter INPUT ether type 0x800 ether daddr 01:02:03:04:00:00 and ff:ff:ff:ff:00:00 == 01:02:03:04:00:00 counter
 
+ebtables-translate -I INPUT -p Length
+nft insert rule bridge filter INPUT ether type < 0x0600 counter
+
+ebtables-translate -I INPUT -p ! Length
+nft insert rule bridge filter INPUT ether type >= 0x0600 counter
+
 # asterisk is not special in iptables and it is even a valid interface name
 iptables-translate -A FORWARD -i '*' -o 'eth*foo'
 nft add rule ip filter FORWARD iifname "\*" oifname "eth\*foo" counter
diff --git a/extensions/libebt_802_3.t b/extensions/libebt_802_3.t
index ddfb2f0a72baf..a138f35d2c756 100644
--- a/extensions/libebt_802_3.t
+++ b/extensions/libebt_802_3.t
@@ -1,3 +1,5 @@
 :INPUT,FORWARD,OUTPUT
---802_3-sap ! 0x0a -j CONTINUE;=;OK
---802_3-type 0x000a -j RETURN;=;OK
+--802_3-sap ! 0x0a -j CONTINUE;=;FAIL
+--802_3-type 0x000a -j RETURN;=;FAIL
+-p Length --802_3-sap ! 0x0a -j CONTINUE;=;OK
+-p Length --802_3-type 0x000a -j RETURN;=;OK
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 106bcc72889f6..33b0b85eaf935 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -100,6 +100,18 @@ static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 	return add_action(r, cs, false);
 }
 
+static int
+nft_bridge_add_match(struct nft_handle *h, const struct ebt_entry *fw,
+		     struct nftnl_rule *r, struct xt_entry_match *m)
+{
+	if (!strcmp(m->u.user.name, "802_3") &&
+	    !(fw->bitmask & EBT_802_3))
+		xtables_error(PARAMETER_PROBLEM,
+			      "For 802.3 DSAP/SSAP filtering the protocol must be LENGTH");
+
+	return add_match(h, r, m);
+}
+
 static int nft_bridge_add(struct nft_handle *h,
 			  struct nftnl_rule *r,
 			  struct iptables_command_state *cs)
@@ -143,19 +155,26 @@ static int nft_bridge_add(struct nft_handle *h,
 	}
 
 	if ((fw->bitmask & EBT_NOPROTO) == 0) {
+		uint16_t ethproto = fw->ethproto;
 		uint8_t reg;
 
 		op = nft_invflags2cmp(fw->invflags, EBT_IPROTO);
 		add_payload(h, r, offsetof(struct ethhdr, h_proto), 2,
 			    NFT_PAYLOAD_LL_HEADER, &reg);
-		add_cmp_u16(r, fw->ethproto, op, reg);
+
+		if (fw->bitmask & EBT_802_3) {
+			op = (op == NFT_CMP_EQ ? NFT_CMP_LT : NFT_CMP_GTE);
+			ethproto = htons(0x0600);
+		}
+
+		add_cmp_u16(r, ethproto, op, reg);
 	}
 
 	add_compat(r, fw->ethproto, fw->invflags & EBT_IPROTO);
 
 	for (iter = cs->match_list; iter; iter = iter->next) {
 		if (iter->ismatch) {
-			if (add_match(h, r, iter->u.match->m))
+			if (nft_bridge_add_match(h, fw, r, iter->u.match->m))
 				break;
 		} else {
 			if (add_target(r, iter->u.watcher->t))
@@ -212,6 +231,7 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 	struct ebt_entry *fw = &cs->eb;
 	unsigned char addr[ETH_ALEN];
 	unsigned short int ethproto;
+	uint8_t op;
 	bool inv;
 	int i;
 
@@ -248,8 +268,14 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 		fw->bitmask |= EBT_ISOURCE;
 		break;
 	case offsetof(struct ethhdr, h_proto):
-		get_cmp_data(e, &ethproto, sizeof(ethproto), &inv);
-		fw->ethproto = ethproto;
+		__get_cmp_data(e, &ethproto, sizeof(ethproto), &op);
+		if (ethproto == htons(0x0600)) {
+			fw->bitmask |= EBT_802_3;
+			inv = (op == NFT_CMP_GTE);
+		} else {
+			fw->ethproto = ethproto;
+			inv = (op == NFT_CMP_NEQ);
+		}
 		if (inv)
 			fw->invflags |= EBT_IPROTO;
 		fw->bitmask &= ~EBT_NOPROTO;
@@ -587,7 +613,7 @@ static void print_protocol(uint16_t ethproto, bool invert, unsigned int bitmask)
 		printf("! ");
 
 	if (bitmask & EBT_802_3) {
-		printf("length ");
+		printf("Length ");
 		return;
 	}
 
@@ -601,7 +627,7 @@ static void print_protocol(uint16_t ethproto, bool invert, unsigned int bitmask)
 static void __nft_bridge_save_rule(const struct iptables_command_state *cs,
 				   unsigned int format)
 {
-	if (cs->eb.ethproto)
+	if (!(cs->eb.bitmask & EBT_NOPROTO))
 		print_protocol(cs->eb.ethproto, cs->eb.invflags & EBT_IPROTO,
 			       cs->eb.bitmask);
 	if (cs->eb.bitmask & EBT_ISOURCE)
@@ -840,7 +866,10 @@ static int nft_bridge_xlate(const struct iptables_command_state *cs,
 	xlate_ifname(xl, "meta obrname", cs->eb.logical_out,
 		     cs->eb.invflags & EBT_ILOGICALOUT);
 
-	if ((cs->eb.bitmask & EBT_NOPROTO) == 0) {
+	if (cs->eb.bitmask & EBT_802_3) {
+		xt_xlate_add(xl, "ether type %s 0x0600 ",
+			     cs->eb.invflags & EBT_IPROTO ? ">=" : "<");
+	} else if ((cs->eb.bitmask & EBT_NOPROTO) == 0) {
 		const char *implicit = NULL;
 
 		switch (ntohs(cs->eb.ethproto)) {
@@ -863,9 +892,6 @@ static int nft_bridge_xlate(const struct iptables_command_state *cs,
 				     ntohs(cs->eb.ethproto));
 	}
 
-	if (cs->eb.bitmask & EBT_802_3)
-		return 0;
-
 	if (cs->eb.bitmask & EBT_ISOURCE)
 		nft_bridge_xlate_mac(xl, "saddr", cs->eb.invflags & EBT_ISOURCE,
 				     cs->eb.sourcemac, cs->eb.sourcemsk);
-- 
2.34.1

