Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B12C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B5D322CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="d4kkBsIV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfIBXcd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:33 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44104 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MPYpBrgQsBCiU2yjfTCQqeEnAnfS7m8K5/K+/Nd4rAw=; b=d4kkBsIVIXLTiclqcwUYJZyeA/
        b0JSvYH2Zr09mAVbkNYwL9LkGGrtTC09wdy/59wNejMsGcIurNroz8VDutrW5m6Tt2X+UW3ntSj9V
        AlU3zfLylRuZ0fW2olwe8JUOtz8cKis35qT9kE6Uw33m4tkahyS6wguCFbnSGGe0BALfaMGw6bXHH
        c0nNj7ykOfHGoAo5en3qtJOFq02j7p5Bicg3johZJYq4YTBNoipXRQzGpSdnx5L+yQAfMmm2Q1QOV
        DXS4sZu+Xqy3S1SXp6f2BRyLS54GfeK5GNCbY7/q6EZO2suxvsSERh7kEctMQ4y8gLC0AyERtz8w9
        jVJ/OiFA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPR-0004la-Et; Tue, 03 Sep 2019 00:06:53 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 18/30] netfilter: use consistent style when defining inline functions in nf_conntrack_ecache.h.
Date:   Tue,  3 Sep 2019 00:06:38 +0100
Message-Id: <20190902230650.14621-19-jeremy@azazel.net>
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

The header contains some inline functions defined as:

  static inline f (...)
  {
  #ifdef CONFIG_NF_CONNTRACK_EVENTS
    ...
  #else
    ...
  #endif
  }

and a few others as:

  #ifdef CONFIG_NF_CONNTRACK_EVENTS
  static inline f (...)
  {
    ...
  }
  #else
  static inline f (...)
  {
    ...
  }
  #endif

Prefer the former style, which is more numerous.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_ecache.h | 82 +++++++++++++--------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0815bfadfefe..eb81f9195e28 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -64,6 +64,7 @@ nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+
 /* This structure is passed to event handler */
 struct nf_ct_event {
 	struct nf_conn *ct;
@@ -84,9 +85,26 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 				  u32 portid, int report);
 
+#else
+
+static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct)
+{
+}
+
+static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
+						struct nf_conn *ct,
+						u32 portid,
+						int report)
+{
+	return 0;
+}
+
+#endif
+
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
@@ -98,31 +116,42 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 		return;
 
 	set_bit(event, &e->cache);
+#endif
 }
 
 static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 portid, int report)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	const struct net *net = nf_ct_net(ct);
 
 	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
 		return 0;
 
 	return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
+#else
+	return 0;
+#endif
 }
 
 static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	const struct net *net = nf_ct_net(ct);
 
 	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
 		return 0;
 
 	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
+#else
+	return 0;
+#endif
 }
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+
 struct nf_exp_event {
 	struct nf_conntrack_expect *exp;
 	u32 portid;
@@ -148,41 +177,18 @@ void nf_conntrack_ecache_pernet_fini(struct net *net);
 int nf_conntrack_ecache_init(void);
 void nf_conntrack_ecache_fini(void);
 
-static inline void nf_conntrack_ecache_delayed_work(struct net *net)
+#else /* CONFIG_NF_CONNTRACK_EVENTS */
+
+static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
+					     struct nf_conntrack_expect *exp,
+					     u32 portid,
+					     int report)
 {
-	if (!delayed_work_pending(&net->ct.ecache_dwork)) {
-		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
-		net->ct.ecache_dwork_pending = true;
-	}
 }
 
-static inline void nf_conntrack_ecache_work(struct net *net)
+static inline void nf_conntrack_ecache_pernet_init(struct net *net)
 {
-	if (net->ct.ecache_dwork_pending) {
-		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &net->ct.ecache_dwork, 0);
-	}
 }
-#else /* CONFIG_NF_CONNTRACK_EVENTS */
-static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
-					    struct nf_conn *ct) {}
-static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
-						struct nf_conn *ct,
-						u32 portid,
-						int report) { return 0; }
-static inline int nf_conntrack_event(enum ip_conntrack_events event,
-				     struct nf_conn *ct) { return 0; }
-static inline int nf_conntrack_event_report(enum ip_conntrack_events event,
-					    struct nf_conn *ct,
-					    u32 portid,
-					    int report) { return 0; }
-static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
-static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
-					     struct nf_conntrack_expect *exp,
- 					     u32 portid,
- 					     int report) {}
-
-static inline void nf_conntrack_ecache_pernet_init(struct net *net) {}
 
 static inline void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
@@ -197,14 +203,26 @@ static inline void nf_conntrack_ecache_fini(void)
 {
 }
 
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
+
 static inline void nf_conntrack_ecache_delayed_work(struct net *net)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	if (!delayed_work_pending(&net->ct.ecache_dwork)) {
+		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
+		net->ct.ecache_dwork_pending = true;
+	}
+#endif
 }
 
 static inline void nf_conntrack_ecache_work(struct net *net)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	if (net->ct.ecache_dwork_pending) {
+		net->ct.ecache_dwork_pending = false;
+		mod_delayed_work(system_wq, &net->ct.ecache_dwork, 0);
+	}
+#endif
 }
-#endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 #endif /*_NF_CONNTRACK_ECACHE_H*/
-
-- 
2.23.0.rc1

