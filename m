Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E887AC3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBFDE2190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="N+w/RyK8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbfIAVCV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:21 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53742 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbfIAVCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9JQ+mOxBFBwK0COzvyCNej2ZoTWLKofYvp3dBheUR58=; b=N+w/RyK8KsDK4nmHR6uKX5X/IO
        MFslhyp6bqAInnh/k4rjir6wfC9VAMemwbmPAV7wHq9r53yk1M9tY3zIa6GUBZmJ6GtRRRgOgFd4U
        Rn/OAhg9bfMw/Yod35mkEja9GRSeXnZhYcvINiVy8DfT2BQWwlkjFuBFTR0uQZ21nO4gcOMu+M9cg
        VQRke4bzdasbvBwxMb0eyFKROgpScMpvqLNYw+T6N3RG+lwMoWps47rSeGzOd9jfjQdyqbIZAwSzy
        STmE7HjJzcVk3VSyCJ5t9IJUisvqEtTwcxaW8PvY3+AVXZoQaY/Ntya3yI9+r+uqHNfHdlRmMyCew
        zhjdVtlg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wor-0002Uf-8l; Sun, 01 Sep 2019 21:51:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 20/29] netfilter: wrap inline synproxy function in CONFIG_NETFILTER_SYNPROXY check.
Date:   Sun,  1 Sep 2019 21:51:16 +0100
Message-Id: <20190901205126.6935-21-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
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

