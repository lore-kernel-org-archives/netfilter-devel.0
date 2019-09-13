Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1965C4CEC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C56920717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="LSRavKyg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbfIMIRw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:52 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60838 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIRv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=suBi3EK0NUFSYiLEdBtipLa4u36T6gyTfF8nTl4kYU0=; b=LSRavKygsf77C0Wn78cFC2VCZk
        qrXRD2FuqwyfRYDGm4S/Lr6xrzDEDf+Y9ZF3nXwi1WjtWtpJUgPDCt6B7+xGt9LnSLWkVMLGxUFZC
        aoFKdEl3uH2t1iMeToJnGUYgrZ4xqwooI+34qQL/xFAJRx/THPD2sJiOpI7jXnO2aM8+tFMbtszMW
        OvZxbvSqtao+D5QPETm2lB2IeHrYOYhsZ1mKnfSj/FIG2L3onN7uoeVdsix6AHMnM1hyAoKy2/zE7
        oQO884ASJUxHMhfFFVUn98yz5yFPeuoCZ9cMnc733adQCmfp1iw81WCrAv56h7c2l/XJDI7JV6G9d
        ouJ+oCbA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghm-0005yL-As; Fri, 13 Sep 2019 09:13:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 15/18] netfilter: remove CONFIG_NF_CONNTRACK check from nf_conntrack_acct.h.
Date:   Fri, 13 Sep 2019 09:13:15 +0100
Message-Id: <20190913081318.16071-16-jeremy@azazel.net>
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

There is a superfluous `#if IS_ENABLED(CONFIG_NF_CONNTRACK)` check
wrapping some function declarations.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_acct.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 5b5287bb49db..f7a060c6eb28 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -65,11 +65,9 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
 #endif
 }
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 void nf_conntrack_acct_pernet_init(struct net *net);
 
 int nf_conntrack_acct_init(void);
 void nf_conntrack_acct_fini(void);
-#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 
 #endif /* _NF_CONNTRACK_ACCT_H */
-- 
2.23.0

