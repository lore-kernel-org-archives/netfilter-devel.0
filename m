Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2123EE14B2
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 16:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbjIFQ4f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241497AbjIFQ4e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 12:56:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBC3199A
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 09:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fus59mgn6qgmWV5mFvn+lwddI1cwRqVPr6hLGBNCHhE=; b=Ni8hJC6o/JKIi4PDJa2pkMHYzx
        sn8sAtP7YwOw4er/Pjp7Dq+tkksVS/sOZr1rQ60x5vhwh2a0ZBamIh2sNq6JG0NX6woSYD3dlxyEf
        FOHG6VVMo5Q1/qRIHYFSGp/sqM37GGWxR/1CNm6HA8bq/KY56jBraEKywI51Di83PjYwAEgO6SoT+
        DM68A9mWkhN7jMfwh2lBA5S313bPvkSUlC2qyrwYbS5JG7YZne6P3z5sfxzSmqE9Z07RvTeShpsLT
        SsBm9uqbR3T4otNt2ZzYwKbO+IJ4x+SCxatyhdl4obpcXffnMHv41DmE5WcQJNYP2O9raK7LUjrHO
        EssleB+w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qdvpD-00087z-T9
        for netfilter-devel@vger.kernel.org; Wed, 06 Sep 2023 18:56:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix for useless meta expressions in rule
Date:   Wed,  6 Sep 2023 19:07:51 +0200
Message-ID: <20230906170751.23040-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A relict of legacy iptables' mandatory matching on interfaces and IP
addresses is support for the '-i +' notation, basically a "match any
input interface". Trying to make things better than its predecessor,
iptables-nft boldly optimizes that nop away - not entirely though, the
meta expression loading the interface name was left in place. While not
a problem (apart from pointless overhead) in current HEAD, v1.8.7 would
trip over this as a following cmp expression (for another match) was
incorrectly linked to that stale meta expression, loading strange values
into the respective interface name field.

While being at it, merge and generalize the functions into a common one
for use with ebtables' NFT_META_BRI_(I|O)IFNAME matches, too.

Fixes: 0a8635183edd0 ("xtables-compat: ignore '+' interface name")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1702
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_standard.t  |  4 ++++
 extensions/libip6t_standard.t |  3 +++
 extensions/libxt_standard.t   |  2 ++
 iptables/nft-arp.c            |  4 ++--
 iptables/nft-bridge.c         | 38 ++++-------------------------
 iptables/nft-ipv4.c           |  4 ++--
 iptables/nft-ipv6.c           |  4 ++--
 iptables/nft-shared.c         | 45 ++++++++++++-----------------------
 iptables/nft-shared.h         |  4 ++--
 9 files changed, 36 insertions(+), 72 deletions(-)

diff --git a/extensions/libebt_standard.t b/extensions/libebt_standard.t
index 97cb3baaf6d21..370a12f4a2cec 100644
--- a/extensions/libebt_standard.t
+++ b/extensions/libebt_standard.t
@@ -14,6 +14,10 @@
 -o foobar;=;FAIL
 --logical-in br0;=;OK
 --logical-out br1;=;FAIL
+-i + -d 00:0f:ee:d0:ba:be;-d 00:0f:ee:d0:ba:be;OK
+-i + -p ip;-p IPv4;OK
+--logical-in + -d 00:0f:ee:d0:ba:be;-d 00:0f:ee:d0:ba:be;OK
+--logical-in + -p ip;-p IPv4;OK
 :FORWARD
 -i foobar;=;OK
 -o foobar;=;OK
diff --git a/extensions/libip6t_standard.t b/extensions/libip6t_standard.t
index a528af10ea152..0c559cc5021f6 100644
--- a/extensions/libip6t_standard.t
+++ b/extensions/libip6t_standard.t
@@ -3,3 +3,6 @@
 ! -d ::;! -d ::/128;OK
 ! -s ::;! -s ::/128;OK
 -s ::/64;=;OK
+:INPUT
+-i + -d c0::fe;-d c0::fe/128;OK
+-i + -p tcp;-p tcp;OK
diff --git a/extensions/libxt_standard.t b/extensions/libxt_standard.t
index 6ed978e442b80..7c83cfa3ba232 100644
--- a/extensions/libxt_standard.t
+++ b/extensions/libxt_standard.t
@@ -24,3 +24,5 @@
 :FORWARD
 --protocol=tcp --source=1.2.3.4 --destination=5.6.7.8/32 --in-interface=eth0 --out-interface=eth1 --jump=ACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
 -ptcp -s1.2.3.4 -d5.6.7.8/32 -ieth0 -oeth1 -jACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
+-i + -d 1.2.3.4;-d 1.2.3.4/32;OK
+-i + -p tcp;-p tcp;OK
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 9868966a03688..aed39ebdd5166 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -49,12 +49,12 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 	if (fw->arp.iniface[0] != '\0') {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_IN);
-		add_iniface(h, r, fw->arp.iniface, op);
+		add_iface(h, r, fw->arp.iniface, NFT_META_IIFNAME, op);
 	}
 
 	if (fw->arp.outiface[0] != '\0') {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_OUT);
-		add_outiface(h, r, fw->arp.outiface, op);
+		add_iface(h, r, fw->arp.outiface, NFT_META_OIFNAME, op);
 	}
 
 	if (fw->arp.arhrd != 0 ||
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 391a8ab723c1c..d9a8ad2b0f373 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -65,36 +65,6 @@ static void ebt_print_mac_and_mask(const unsigned char *mac, const unsigned char
 		xtables_print_mac_and_mask(mac, mask);
 }
 
-static void add_logical_iniface(struct nft_handle *h, struct nftnl_rule *r,
-				char *iface, uint32_t op)
-{
-	int iface_len;
-	uint8_t reg;
-
-	iface_len = strlen(iface);
-
-	add_meta(h, r, NFT_META_BRI_IIFNAME, &reg);
-	if (iface[iface_len - 1] == '+')
-		add_cmp_ptr(r, op, iface, iface_len - 1, reg);
-	else
-		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
-}
-
-static void add_logical_outiface(struct nft_handle *h, struct nftnl_rule *r,
-				 char *iface, uint32_t op)
-{
-	int iface_len;
-	uint8_t reg;
-
-	iface_len = strlen(iface);
-
-	add_meta(h, r, NFT_META_BRI_OIFNAME, &reg);
-	if (iface[iface_len - 1] == '+')
-		add_cmp_ptr(r, op, iface, iface_len - 1, reg);
-	else
-		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
-}
-
 static int add_meta_broute(struct nftnl_rule *r)
 {
 	struct nftnl_expr *expr;
@@ -180,22 +150,22 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 	if (fw->in[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_IIN);
-		add_iniface(h, r, fw->in, op);
+		add_iface(h, r, fw->in, NFT_META_IIFNAME, op);
 	}
 
 	if (fw->out[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_IOUT);
-		add_outiface(h, r, fw->out, op);
+		add_iface(h, r, fw->out, NFT_META_OIFNAME, op);
 	}
 
 	if (fw->logical_in[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_ILOGICALIN);
-		add_logical_iniface(h, r, fw->logical_in, op);
+		add_iface(h, r, fw->logical_in, NFT_META_BRI_IIFNAME, op);
 	}
 
 	if (fw->logical_out[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_ILOGICALOUT);
-		add_logical_outiface(h, r, fw->logical_out, op);
+		add_iface(h, r, fw->logical_out, NFT_META_BRI_OIFNAME, op);
 	}
 
 	if ((fw->bitmask & EBT_NOPROTO) == 0) {
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 2f10220edd509..75912847aea3e 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -51,12 +51,12 @@ static int nft_ipv4_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 	if (cs->fw.ip.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_VIA_IN);
-		add_iniface(h, r, cs->fw.ip.iniface, op);
+		add_iface(h, r, cs->fw.ip.iniface, NFT_META_IIFNAME, op);
 	}
 
 	if (cs->fw.ip.outiface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_VIA_OUT);
-		add_outiface(h, r, cs->fw.ip.outiface, op);
+		add_iface(h, r, cs->fw.ip.outiface, NFT_META_OIFNAME, op);
 	}
 
 	if (cs->fw.ip.proto != 0) {
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index d53f87c1d26e3..5aef365b79f2a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -54,12 +54,12 @@ static int nft_ipv6_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 	if (cs->fw6.ipv6.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_IN);
-		add_iniface(h, r, cs->fw6.ipv6.iniface, op);
+		add_iface(h, r, cs->fw6.ipv6.iniface, NFT_META_IIFNAME, op);
 	}
 
 	if (cs->fw6.ipv6.outiface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_OUT);
-		add_outiface(h, r, cs->fw6.ipv6.outiface, op);
+		add_iface(h, r, cs->fw6.ipv6.outiface, NFT_META_OIFNAME, op);
 	}
 
 	if (cs->fw6.ipv6.proto != 0) {
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 34ca9d16569d0..6775578b1e36b 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -147,44 +147,29 @@ void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op, uint8_t sreg)
 	add_cmp_ptr(r, op, &val, sizeof(val), sreg);
 }
 
-void add_iniface(struct nft_handle *h, struct nftnl_rule *r,
-		 char *iface, uint32_t op)
+void add_iface(struct nft_handle *h, struct nftnl_rule *r,
+	       char *iface, uint32_t key, uint32_t op)
 {
-	int iface_len;
+	int iface_len = strlen(iface);
 	uint8_t reg;
 
-	iface_len = strlen(iface);
 
-	add_meta(h, r, NFT_META_IIFNAME, &reg);
 	if (iface[iface_len - 1] == '+') {
-		if (iface_len > 1)
-			add_cmp_ptr(r, op, iface, iface_len - 1, reg);
-		else if (op != NFT_CMP_EQ)
-			add_cmp_ptr(r, NFT_CMP_EQ, "INVAL/D",
-				    strlen("INVAL/D") + 1, reg);
+		if (iface_len > 1) {
+			iface_len -= 1;
+		} else if (op != NFT_CMP_EQ) {
+			op = NFT_CMP_EQ;
+			iface = "INVAL/D";
+			iface_len = strlen(iface) + 1;
+		} else {
+			return; /* -o + */
+		}
 	} else {
-		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
+		iface_len += 1;
 	}
-}
-
-void add_outiface(struct nft_handle *h, struct nftnl_rule *r,
-		  char *iface, uint32_t op)
-{
-	int iface_len;
-	uint8_t reg;
 
-	iface_len = strlen(iface);
-
-	add_meta(h, r, NFT_META_OIFNAME, &reg);
-	if (iface[iface_len - 1] == '+') {
-		if (iface_len > 1)
-			add_cmp_ptr(r, op, iface, iface_len - 1, reg);
-		else if (op != NFT_CMP_EQ)
-			add_cmp_ptr(r, NFT_CMP_EQ, "INVAL/D",
-				    strlen("INVAL/D") + 1, reg);
-	} else {
-		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
-	}
+	add_meta(h, r, key, &reg);
+	add_cmp_ptr(r, op, iface, iface_len, reg);
 }
 
 void add_addr(struct nft_handle *h, struct nftnl_rule *r,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 4f47058d2ec5c..51d1e4609a3b6 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -95,8 +95,8 @@ void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len, uint
 void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op, uint8_t sreg);
 void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op, uint8_t sreg);
 void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op, uint8_t sreg);
-void add_iniface(struct nft_handle *h, struct nftnl_rule *r, char *iface, uint32_t op);
-void add_outiface(struct nft_handle *h, struct nftnl_rule *r, char *iface, uint32_t op);
+void add_iface(struct nft_handle *h, struct nftnl_rule *r,
+	       char *iface, uint32_t key, uint32_t op);
 void add_addr(struct nft_handle *h, struct nftnl_rule *r, enum nft_payload_bases base, int offset,
 	      void *data, void *mask, size_t len, uint32_t op);
 void add_proto(struct nft_handle *h, struct nftnl_rule *r, int offset, size_t len,
-- 
2.41.0

