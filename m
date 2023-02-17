Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF4FC64ED8
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBQQSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBQQRz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 11:17:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8711C149A3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 08:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dLwqDR4YTcPrBldGTJAo3/AabKplh4apZHvYBuRTnfA=; b=io9wlPYpxlCnu4WWYXLBHlslHF
        9GT5GwE93MMakPN4sKVigBVnEeeOU4S+km4hmmjAJ0e+3k8kaXwOiAbY3otrrgjqNysUTFM82aY/Y
        URVaRCnVhmf6orAJxwPG9AzO2ABHwgwEN0jICH4l7DTbrzHzFFYeLPjXqjo4o21Tuwcvw7HpZPscx
        delzcfV5u/ejjaBpjgDozFAGRtJPU60JYU66PpBL5sazKXMF59dr0Z4CKq/xCyh9MjgLDKU0lyMai
        t54D8ECbmEAe3dNT8bil+aoYM/GCHAM8h02SeTguNui+R2X3YIi9lGo8F7S4uztQ6JjUyNmVGgh54
        BJIEQoVg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT3Qa-0003W8-3m
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 17:17:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/6] extensions: libebt_ip: Translation has to match on ether type
Date:   Fri, 17 Feb 2023 17:17:13 +0100
Message-Id: <20230217161715.26120-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217161715.26120-1-phil@nwl.cc>
References: <20230217161715.26120-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On one hand, nft refuses th expression in bridge family if layer3
protocol has not been assured by a previous match. On the other, ebt_ip
kernel module will only match on IPv4 packets, so there might be a
functional change in the translation versus the original.

Instead of just always emitting an 'ether type' match, decide whether
it's actually needed - explicit "ip <something>" payload matches (or
icmp ones) cause implicit creation of a match on IPv4 by nft.

Fixes: 03ecffe6c2cc0 ("ebtables-compat: add initial translations")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.c      | 21 +++++++++++++++++++++
 extensions/libebt_ip.txlate |  6 +++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 8b381aa10b5b7..68f34bff97deb 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -432,6 +432,24 @@ static void brip_xlate_nh(struct xt_xlate *xl,
 				  xtables_ipmask_to_numeric(maskp));
 }
 
+static bool may_skip_ether_type_dep(uint8_t flags)
+{
+	/* these convert to "ip (s|d)addr" matches */
+	if (flags & (EBT_IP_SOURCE | EBT_IP_DEST))
+		return true;
+
+	/* icmp match triggers implicit ether type dependency in nft */
+	if (flags & EBT_IP_ICMP)
+		return true;
+
+	/* allow if "ip protocol" match is created by brip_xlate() */
+	if (flags & EBT_IP_PROTO &&
+	    !(flags & (EBT_IP_SPORT | EBT_IP_DPORT | EBT_IP_ICMP)))
+		return true;
+
+	return false;
+}
+
 static int brip_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_mt_params *params)
 {
@@ -441,6 +459,9 @@ static int brip_xlate(struct xt_xlate *xl,
 	brip_xlate_nh(xl, info, EBT_IP_SOURCE);
 	brip_xlate_nh(xl, info, EBT_IP_DEST);
 
+	if (!may_skip_ether_type_dep(info->bitmask))
+		xt_xlate_add(xl, "ether type ip ");
+
 	if (info->bitmask & EBT_IP_TOS) {
 		xt_xlate_add(xl, "@nh,8,8 ");
 		if (info->invflags & EBT_IP_TOS)
diff --git a/extensions/libebt_ip.txlate b/extensions/libebt_ip.txlate
index 562e3157d7b92..28996832225cb 100644
--- a/extensions/libebt_ip.txlate
+++ b/extensions/libebt_ip.txlate
@@ -5,13 +5,13 @@ ebtables-translate -I FORWARD -p ip --ip-dst 10.0.0.1
 nft 'insert rule bridge filter FORWARD ip daddr 10.0.0.1 counter'
 
 ebtables-translate -I OUTPUT 3 -p ip -o eth0 --ip-tos 0xff
-nft 'insert rule bridge filter OUTPUT oifname "eth0" @nh,8,8 0xff counter'
+nft 'insert rule bridge filter OUTPUT oifname "eth0" ether type ip @nh,8,8 0xff counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto tcp --ip-dport 22
-nft 'add rule bridge filter FORWARD tcp dport 22 counter'
+nft 'add rule bridge filter FORWARD ether type ip tcp dport 22 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto udp --ip-sport 1024:65535
-nft 'add rule bridge filter FORWARD udp sport 1024-65535 counter'
+nft 'add rule bridge filter FORWARD ether type ip udp sport 1024-65535 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto 253
 nft 'add rule bridge filter FORWARD ip protocol 253 counter'
-- 
2.38.0

