Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87243C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C27722CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="eVTOhSDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfIBXcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:19 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44010 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9JQ+mOxBFBwK0COzvyCNej2ZoTWLKofYvp3dBheUR58=; b=eVTOhSDk80mWG8iqoCDtw/Yihn
        eaMyAX1BFNnGfzKVhY+1t1rADHpC67vfxbokU6dzLoWQVLjtts2JYTFaCOYHCPnqekH6IZf/uIbbu
        AmAex6FKGDV7CDuOLtPzXvWKnP31PUraHPj9vGf4l9ViIwQpQ7V9/+/UEMNoyOLOCMWsyxLV+3xvT
        YkTXLAi3HXT80tyrq0pbtlt+53cGroK904GR9hLMXwnPqH+xgLrQfQaBHJ0zr1yS2dhaLCLgIrNp6
        NHcQVDaExVQQYE40vpbFpqHl/QaCn+ModoUqSuwnGYcq3igUJM8AwxXF2xOvWnU1aWC5zjuX9WA+R
        /Hlr/TOg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPR-0004la-Uy; Tue, 03 Sep 2019 00:06:54 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 21/30] netfilter: wrap inline synproxy function in CONFIG_NETFILTER_SYNPROXY check.
Date:   Tue,  3 Sep 2019 00:06:41 +0100
Message-Id: <20190902230650.14621-22-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_synproxy.h contains three inline functions.  The contents
of two of them are wrapped in CONFIG_NETFILTER_SYNPROXY checks and just
return NULL if it is not enabled.  The third does nothing if they return
NULL, so wrap its contents as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index c22f0c11cc82..6a3ab081e4bf 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -32,6 +32,7 @@ static inline struct nf_conn_synproxy *nfct_synproxy_ext_add(struct nf_conn *ct)
 static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 				      const struct nf_conn *tmpl)
 {
+#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
 	if (tmpl && nfct_synproxy(tmpl)) {
 		if (!nfct_seqadj_ext_add(ct))
 			return false;
@@ -39,6 +40,7 @@ static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 		if (!nfct_synproxy_ext_add(ct))
 			return false;
 	}
+#endif
 
 	return true;
 }
-- 
2.23.0.rc1

