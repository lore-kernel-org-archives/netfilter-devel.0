Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1541EC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDBA520717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="a/jSRb3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbfIMIR5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:57 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60872 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIR5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+DPfBAu/SPNSpUV3nvs0e59K+xnn7xhNlZiEEd9i+PE=; b=a/jSRb3DdCoKDjnss8+NIvAT2G
        Ol5w4gjDIA5kPED5sEZ8yYdUf9XFcsUkOCMSCaCb5ycM2s7wunCB7gXG55x62mrN2acni+LbpvT9s
        Yof2KmwDTweNe4AAy21C6bQKUk/jtZE4SD/L/zMyKSZZWBgXJl69D7WPPa6BbUZpObLJxCV1CTKWa
        HIYjdLGPeFV5nzYkfhyt9cayxFZClatWWNgeZtwcuifeXJVyCxYKlmq837ePmKyx24uz2MCLYz2Ht
        V9AhJeMISjlRt+byH3cZYzJqttrz9fCeWGPCt+oxrfzQDzYJ3hz5ikTko5YRxkADAeznR/iDk7zcC
        BKCjCMKA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghl-0005yL-Qy; Fri, 13 Sep 2019 09:13:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 12/18] netfilter: wrap two inline functions in config checks.
Date:   Fri, 13 Sep 2019 09:13:12 +0100
Message-Id: <20190913081318.16071-13-jeremy@azazel.net>
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

nf_conntrack_synproxy.h contains three inline functions.  The contents
of two of them are wrapped in CONFIG_NETFILTER_SYNPROXY checks and just
return NULL if it is not enabled.  The third does nothing if they return
NULL, so wrap its contents as well.

nf_ct_timeout_data is only called if CONFIG_NETFILTER_TIMEOUT is
enabled.  Wrap its contents in a CONFIG_NETFILTER_TIMEOUT check like the
other inline functions in nf_conntrack_timeout.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 2 ++
 include/net/netfilter/nf_conntrack_timeout.h  | 4 ++++
 2 files changed, 6 insertions(+)

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
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 00a8fbb2d735..6dd72396f534 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -32,6 +32,7 @@ struct nf_conn_timeout {
 static inline unsigned int *
 nf_ct_timeout_data(const struct nf_conn_timeout *t)
 {
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	struct nf_ct_timeout *timeout;
 
 	timeout = rcu_dereference(t->timeout);
@@ -39,6 +40,9 @@ nf_ct_timeout_data(const struct nf_conn_timeout *t)
 		return NULL;
 
 	return (unsigned int *)timeout->data;
+#else
+	return NULL;
+#endif
 }
 
 static inline
-- 
2.23.0

