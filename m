Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C17C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 16:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E24672053B
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 16:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="QHZUzdV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLCQHz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:07:55 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38536 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfLCQHz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 11:07:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so4115928wmi.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Dec 2019 08:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FUE83SVWT74e+XuiA1hPEA44Hl/NhBaIjA2wjyvMJpk=;
        b=QHZUzdV7y4hoNccV4BLu+5zRq4j/ZRc2negNlyE7S9AiaPm2wXxqyYztc8xK7DZEfS
         yvRlboTpMVDLof2SNOPomQgHoDAxpFkOYW+5NglSR5ajojKIK42S1TRA3Trze8iIAP31
         ISJR988tcdsvbGC/CrQSGPs8ru1B0TnVGgq78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FUE83SVWT74e+XuiA1hPEA44Hl/NhBaIjA2wjyvMJpk=;
        b=pRnzz6NWAPrV9vSUSv9LI+kSyN7POipp4xRtBdJidhHYpdzjbLTOlgl3V8+Q/rQAgA
         oFsPPflSmw9x+eZkNeyuTURoIpFL8ab402UgLxlKYYVtitrZj07z9lj0wTrpVIjjsPFf
         yam5LZAU0LHlapBENh8ifD1KMA9aEvJ7Tz8WYr6wkEHn8oL26MAXuPDDurDamT58nibg
         Ri/yAXTgjsXvLkkES8mXlTqrtlW3FJ25j37HSiYbBaLEAZp41Ue3Msm2Z/CbhpfqNIrU
         Ic/sTST8uveuuu5yQzRl7/3u7t3CsHLd+/AJ3/CTB8wJwmAbU5JCkgKexxh2YRgnwLvt
         FB3A==
X-Gm-Message-State: APjAAAVI1Q3NoBRH0h/EgazXpaYSFFmQHbTqXlkLd3GMmAJJmnkMFjSW
        Fge77YtAfZt5aEKNk0o4+IQtDQAZ031aAQ==
X-Google-Smtp-Source: APXvYqy4ezRlpWBCdFDKjzFa3dzWlaZOyL9ZN2Yj5l8F5fby2HHNLaLV+UsUue/tMqEFLbOByxvaWw==
X-Received: by 2002:a7b:c955:: with SMTP id i21mr22800243wml.172.1575389272292;
        Tue, 03 Dec 2019 08:07:52 -0800 (PST)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1243:8e00::dc83])
        by smtp.gmail.com with ESMTPSA id r6sm4160607wrq.92.2019.12.03.08.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 08:07:51 -0800 (PST)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netfilter-devel@vger.kernel.org
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH 1/1] netfilter: connmark: introduce set-dscpmark
Date:   Tue,  3 Dec 2019 16:06:53 +0000
Message-Id: <20191203160652.44396-2-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
In-Reply-To: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

set-dscpmark is a method of storing the DSCP of an ip packet into
conntrack mark.  In combination with a suitable tc filter action
(act_ctinfo) DSCP values are able to be stored in the mark on egress and
restored on ingress across links that otherwise alter or bleach DSCP.

This is useful for qdiscs such as CAKE which are able to shape according
to policies based on DSCP.

Ingress classification is traditionally a challenging task since
iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
lookups, hence are unable to see internal IPv4 addresses as used on the
typical home masquerading gateway.

x_tables CONNMARK set-dscpmark target solves the problem of storing the
DSCP to the conntrack mark in a way suitable for the new act_ctinfo tc
action to restore.

The set-dscpmark option accepts 2 parameters, a 32bit 'dscpmask' and a
32bit 'statemask'.  The dscp mask must be 6 contiguous bits and
represents the area where the DSCP will be stored in the connmark.  The
state mask is a minimum 1 bit length mask that must not overlap with the
dscpmask.  It represents a flag which is set when the DSCP has been
stored in the conntrack mark. This is useful to implement a 'one shot'
iptables based classification where the 'complicated' iptables rules are
only run once to classify the connection on initial (egress) packet and
subsequent packets are all marked/restored with the same DSCP.  A state
mask of zero disables the setting of a status bit/s.

example syntax with a suitably modified iptables user space application:

iptables -A QOS_MARK_eth0 -t mangle -j CONNMARK --set-dscpmark 0xfc000000/0x01000000

Would store the DSCP in the top 6 bits of the 32bit mark field, and use
the LSB of the top byte as the 'DSCP has been stored' marker.

|----0xFC----conntrack mark----000000---|
| Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
| DSCP       | unused | flag  |unused   |
|-----------------------0x01---000000---|
      ^                   ^
      |                   |
      ---|             Conditional flag
         |             set this when dscp
|-ip diffserv-|        stored in mark
| 6 bits      |
|-------------|

an identically configured tc action to restore looks like:

tc filter show dev eth0 ingress
filter parent ffff: protocol all pref 10 u32 chain 0
filter parent ffff: protocol all pref 10 u32 chain 0 fh 800: ht divisor 1
filter parent ffff: protocol all pref 10 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1: not_in_hw
  match 00000000/00000000 at 0
	action order 1: ctinfo zone 0 pipe
	 index 2 ref 1 bind 1 dscp 0xfc000000/0x1000000

	action order 2: mirred (Egress Redirect to device ifb4eth0) stolen
	index 1 ref 1 bind 1

|----0xFC----conntrack mark----000000---|
| Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
| DSCP       | unused | flag  |unused   |
|-----------------------0x01---000000---|
      |                   |
      |                   |
      ---|             Conditional flag
         v             only restore if set
|-ip diffserv-|
| 6 bits      |
|-------------|

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 include/uapi/linux/netfilter/xt_connmark.h | 10 ++++
 net/netfilter/xt_connmark.c                | 57 ++++++++++++++++++----
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index 1aa5c955ee1e..a1585e7ecbe1 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -19,6 +19,11 @@ enum {
 	XT_CONNMARK_RESTORE
 };
 
+enum {
+	XT_CONNMARK_VALUE = BIT(0),
+	XT_CONNMARK_DSCP = BIT(1)
+};
+
 enum {
 	D_SHIFT_LEFT = 0,
 	D_SHIFT_RIGHT,
@@ -34,6 +39,11 @@ struct xt_connmark_tginfo2 {
 	__u8 shift_dir, shift_bits, mode;
 };
 
+struct xt_connmark_tginfo3 {
+	__u32 ctmark, ctmask, nfmask;
+	__u8 shift_dir, shift_bits, mode, func;
+};
+
 struct xt_connmark_mtinfo1 {
 	__u32 mark, mask;
 	__u8 invert;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index eec2f3a88d73..188fd2495121 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -24,12 +24,13 @@ MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
 static unsigned int
-connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
+connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo3 *info)
 {
 	enum ip_conntrack_info ctinfo;
 	u_int32_t new_targetmark;
 	struct nf_conn *ct;
 	u_int32_t newmark;
+	u_int8_t dscp;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct == NULL)
@@ -37,12 +38,24 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
-		newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
-		if (info->shift_dir == D_SHIFT_RIGHT)
-			newmark >>= info->shift_bits;
-		else
-			newmark <<= info->shift_bits;
-
+		newmark = ct->mark;
+		if (info->func & XT_CONNMARK_VALUE) {
+			newmark = (newmark & ~info->ctmask) ^ info->ctmark;
+			if (info->shift_dir == D_SHIFT_RIGHT)
+				newmark >>= info->shift_bits;
+			else
+				newmark <<= info->shift_bits;
+		} else if (info->func & XT_CONNMARK_DSCP) {
+			if (skb->protocol == htons(ETH_P_IP))
+				dscp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
+			else if (skb->protocol == htons(ETH_P_IPV6))
+				dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
+			else	/* protocol doesn't have diffserv */
+				break;
+
+			newmark = (newmark & ~info->ctmark) |
+				  (info->ctmask | (dscp << info->shift_bits));
+		}
 		if (ct->mark != newmark) {
 			ct->mark = newmark;
 			nf_conntrack_event_cache(IPCT_MARK, ct);
@@ -81,20 +94,36 @@ static unsigned int
 connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_connmark_tginfo1 *info = par->targinfo;
-	const struct xt_connmark_tginfo2 info2 = {
+	const struct xt_connmark_tginfo3 info3 = {
 		.ctmark	= info->ctmark,
 		.ctmask	= info->ctmask,
 		.nfmask	= info->nfmask,
 		.mode	= info->mode,
+		.func	= XT_CONNMARK_VALUE
 	};
 
-	return connmark_tg_shift(skb, &info2);
+	return connmark_tg_shift(skb, &info3);
 }
 
 static unsigned int
 connmark_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_connmark_tginfo2 *info = par->targinfo;
+	const struct xt_connmark_tginfo3 info3 = {
+		.ctmark	= info->ctmark,
+		.ctmask	= info->ctmask,
+		.nfmask	= info->nfmask,
+		.mode	= info->mode,
+		.func	= XT_CONNMARK_VALUE
+	};
+
+	return connmark_tg_shift(skb, &info3);
+}
+
+static unsigned int
+connmark_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_connmark_tginfo3 *info = par->targinfo;
 
 	return connmark_tg_shift(skb, info);
 }
@@ -165,6 +194,16 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
 		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "CONNMARK",
+		.revision       = 3,
+		.family         = NFPROTO_UNSPEC,
+		.checkentry     = connmark_tg_check,
+		.target         = connmark_tg_v3,
+		.targetsize     = sizeof(struct xt_connmark_tginfo3),
+		.destroy        = connmark_tg_destroy,
+		.me             = THIS_MODULE,
 	}
 };
 
-- 
2.21.0 (Apple Git-122.2)

