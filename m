Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75422C04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 20:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BEA2206B6
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 20:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="DCWicPc0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfESUxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 16:53:43 -0400
Received: from mx1.riseup.net ([198.252.153.129]:51796 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfESUxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 16:53:42 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 315D11A29B5
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558299222; bh=u6zYW7pNbj69YEP4b1jftzY5DBzUptOtV7MRRrw8eFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCWicPc0BHWpsqM+bIYHeyfz7O7Zc0QJRauNypqSDKoByoB/PIETH96UcXhvoDwbG
         aKlh0Q2MZ2yfjjUrclnhOMrDhmtbWoiQMQg7bUW2fduAxiELGeuavt2Okn8TToqNwT
         MuuAb5NSxNLBsYFQEVN/HLTk+hvUqZG3W8dRWUAA=
X-Riseup-User-ID: E20F36DFCE1EFC971C6244EEEBF564A42A28A83245C37A37056629CAF7339023
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 5B190120025;
        Sun, 19 May 2019 13:53:41 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v2 2/4] netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
Date:   Sun, 19 May 2019 22:52:59 +0200
Message-Id: <20190519205259.2821-3-ffmancera@riseup.net>
In-Reply-To: <20190519205259.2821-1-ffmancera@riseup.net>
References: <20190519205259.2821-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a prerequisite for the new infrastructure module NF_SYNPROXY. The new
module is needed to avoid duplicated code for the SYNPROXY nftables support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/linux/netfilter_ipv6.h | 3 +++
 net/ipv6/netfilter.c           | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 12113e502656..f440aaade612 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -8,6 +8,7 @@
 #define __LINUX_IP6_NETFILTER_H
 
 #include <uapi/linux/netfilter_ipv6.h>
+#include <net/tcp.h>
 
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
@@ -35,6 +36,8 @@ struct nf_ipv6_ops {
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
 #endif
+	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
+				    const struct tcphdr *th, u16 *mssp);
 	void (*route_input)(struct sk_buff *skb);
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 1240ccd57f39..c62eb5cdfbad 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -116,6 +116,7 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
 #endif
+	.cookie_init_sequence	= __cookie_v6_init_sequence,
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-- 
2.20.1

