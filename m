Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1A4C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A1E20717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WtGw4EJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbfIMIRz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:55 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60860 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIRz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vuF/n1pz6gqNyviqtDeIo83rpfftq0pPG6oRy/vYmxY=; b=WtGw4EJH7Am93azkRUl8BdcAZ8
        xxBVHJdZCjM8RlYohLQ/oV6HuGvMLlL4Zyo0rDEF7/UvduhgXYLZpqoCTivEdydRvWrubPL8yq11x
        G/lbglVFy9HIRnjjot0cK3bU4e4b1GrRv7gneIG2Lmel7NxjtEEZFhWLHlfb5WyYYSTjkMR0oCnow
        IfHk5lb/G0cookO//PMfowqS/0wfg4XNDlAAh01ci2V0BUIl35myJeGGjoou05MYdxwPIguMAHrOX
        /prwpTeWdJY7ho+VBs9cvG9M8b7OS0apER0K9pt0obYVD74U2iLcXBCsk27i5U2VWv8zzkjTdDPYO
        b20QcDQw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghl-0005yL-HV; Fri, 13 Sep 2019 09:13:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 10/18] netfilter: use consistent style when defining inline functions in nf_conntrack_ecache.h.
Date:   Fri, 13 Sep 2019 09:13:10 +0100
Message-Id: <20190913081318.16071-11-jeremy@azazel.net>
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
2.23.0

