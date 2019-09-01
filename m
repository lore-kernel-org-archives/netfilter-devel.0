Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC29C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F25C2190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IMArA8Aa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfIAVCF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:05 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53648 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbfIAVCF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MPYpBrgQsBCiU2yjfTCQqeEnAnfS7m8K5/K+/Nd4rAw=; b=IMArA8AaqpkzrWtc/Zk7OhzhCe
        2DNRw7ILFK+ngCSAMbcm7ofS0xV16UwzBsHyhSp7oAvPQrl0lwEdvv/1wqHNop7RTuKyrqLQjIUA+
        l0R4Vxv7NKQy3lcSbn/K8xp74nmypCcO1+dqUiESSN41LV5MK2tywa2itGdMhid7bmB+VnyjsfIU9
        40p9PVaFGgVJ/zcc2l7wpCZM2HzsL0ZP/SOZoSu+jZwITDwrY/66gBg30oAZ4y4emlkxWwLAIb0pM
        JL7AtZCo1uFXfEh58+fL+cN4a9VlnxDfGK0NsXcOK+s5aji+ynainPNhYLNQsEXmcn3N8DVzr3LLI
        u3PSPSwQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Woq-0002Uf-Nd; Sun, 01 Sep 2019 21:51:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 17/29] netfilter: use consistent style when defining inline functions in nf_conntrack_ecache.h.
Date:   Sun,  1 Sep 2019 21:51:13 +0100
Message-Id: <20190901205126.6935-18-jeremy@azazel.net>
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

