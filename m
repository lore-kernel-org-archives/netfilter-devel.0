Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FF8C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F27D20717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="rAjGSOG1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbfIMIRr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:47 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60808 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIRr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l9bZDRfs3gp89WF4IBLip4aLCVLmdrc6gzB2P1045tw=; b=rAjGSOG1C3QmJAV5PTXCClNulR
        ti3/xLpQTYSnU3I3AHVYY8nOfGcwhxHHBE8MZrT9WcO5NjPLSsK+nm+P7SlnLZ/9LbN8QPHuTDIzt
        Q1nmJUhbfQzqnEil+RzY4Zmv4fxPfnbXf1QlYaaJkvBNovsdmRGGvbOioltX4eFIuvphwcQ6zi5vt
        +DnseBFEwhRAi0xMPsIzMHOjdeRRjhNR55Ir+o00X3v31CIJxpHMLtP47J54A74f82mCZECBptlf/
        87Gbngpw6T939Iu2p4WW4yRprXw9Za7Fn4HAQbT6UfR9dQSNBQYThjeXmA5AUun2nBSB/82KRKoOv
        9WwVREOQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghm-0005yL-Tt; Fri, 13 Sep 2019 09:13:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 18/18] netfilter: remove two unused functions from nf_conntrack_timestamp.h.
Date:   Fri, 13 Sep 2019 09:13:18 +0100
Message-Id: <20190913081318.16071-19-jeremy@azazel.net>
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

Two inline functions defined in nf_conntrack_timestamp.h,
`nf_ct_tstamp_enabled` and `nf_ct_set_tstamp`, are not called anywhere.
Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_timestamp.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 2b8aeba649aa..820ea34b6029 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -38,22 +38,6 @@ struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
 #endif
 };
 
-static inline bool nf_ct_tstamp_enabled(struct net *net)
-{
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return net->ct.sysctl_tstamp != 0;
-#else
-	return false;
-#endif
-}
-
-static inline void nf_ct_set_tstamp(struct net *net, bool enable)
-{
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	net->ct.sysctl_tstamp = enable;
-#endif
-}
-
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 void nf_conntrack_tstamp_pernet_init(struct net *net);
 
-- 
2.23.0

