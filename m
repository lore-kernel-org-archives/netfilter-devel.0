Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19A9C4CEC5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13C420717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="VPSnAxxf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfIMIRs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:48 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60812 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIRs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5UG2feS4iy8LRfiHgHa4SL8czyMb/lbnkOan7sTh9e0=; b=VPSnAxxf+8tWkCG64mpmRcw2LQ
        nbxh2axkgfJvN+2vnmQICbYSvIJW6l5WJ8nq9Ey/nU+LbITBnztJdADJ6o+tCnxsxkJqfwCq+1TO1
        2gCuiHQ6fHw0wKJ3yZ6St5qpU7BjdPykt5TPGmS5YoVYhfSbfYanFLWIi3nDk2SG+E0Y3wyy5jCSf
        ThGf13lSVp5jfFB98ZaX5j8v4CrcQOpqts3LBoQuCihKsmdnEhHBzQdtPX0/Vm5/vGiH7U66QrXy1
        AOjXOQ5TlpbYkl2XneSfdtF07PP5SVxSo+lTB66g/HZ8b4Qg05nZ2gB0mKwrEsy/aSbdzqGK6+han
        05dlLFMQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghl-0005yL-Vq; Fri, 13 Sep 2019 09:13:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 13/18] netfilter: update stub br_nf_pre_routing_ipv6 parameter to `void *priv`.
Date:   Fri, 13 Sep 2019 09:13:13 +0100
Message-Id: <20190913081318.16071-14-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913081318.16071-1-jeremy@azazel.net>
References: <20190913081318.16071-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The real br_nf_pre_routing_ipv6 function, defined when CONFIG_IPV6 is
enabled, expects `void *priv`, not `const struct nf_hook_ops *ops`.
Update the stub br_nf_pre_routing_ipv6, defined when CONFIG_IPV6 is
disabled, to match.

Fixes: 06198b34a3e0 ("netfilter: Pass priv instead of nf_hook_ops to netfilter hooks")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/br_netfilter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 2a613c84d49f..c53909fd22cd 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -68,7 +68,7 @@ static inline int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 }
 
 static inline unsigned int
-br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
+br_nf_pre_routing_ipv6(void *priv, struct sk_buff *skb,
 		       const struct nf_hook_state *state)
 {
 	return NF_ACCEPT;
-- 
2.23.0

