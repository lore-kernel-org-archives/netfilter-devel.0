Return-Path: <SRS0=HFPz=AM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1CFC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 15:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC7A206C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 15:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgGAPSA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jul 2020 11:18:00 -0400
Received: from ja.ssi.bg ([178.16.129.10]:53136 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727887AbgGAPR7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 11:17:59 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 061FHmqs004803;
        Wed, 1 Jul 2020 18:17:48 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id 061FHl8t004802;
        Wed, 1 Jul 2020 18:17:47 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, YangYuxi <yx.atom1@gmail.com>
Subject: [PATCH net-next] ipvs: allow connection reuse for unconfirmed conntrack
Date:   Wed,  1 Jul 2020 18:17:19 +0300
Message-Id: <20200701151719.4751-1-ja@ssi.bg>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

YangYuxi is reporting that connection reuse
is causing one-second delay when SYN hits
existing connection in TIME_WAIT state.
Such delay was added to give time to expire
both the IPVS connection and the corresponding
conntrack. This was considered a rare case
at that time but it is causing problem for
some environments such as Kubernetes.

As nf_conntrack_tcp_packet() can decide to
release the conntrack in TIME_WAIT state and
to replace it with a fresh NEW conntrack, we
can use this to allow rescheduling just by
tuning our check: if the conntrack is
confirmed we can not schedule it to different
real server and the one-second delay still
applies but if new conntrack was created,
we are free to select new real server without
any delays.

YangYuxi lists some of the problem reports:

- One second connection delay in masquerading mode:
https://marc.info/?t=151683118100004&r=1&w=2

- IPVS low throughput #70747
https://github.com/kubernetes/kubernetes/issues/70747

- Apache Bench can fill up ipvs service proxy in seconds #544
https://github.com/cloudnativelabs/kube-router/issues/544

- Additional 1s latency in `host -> service IP -> pod`
https://github.com/kubernetes/kubernetes/issues/90854

Fixes: f719e3754ee2 ("ipvs: drop first packet to redirect conntrack")
Co-developed-by: YangYuxi <yx.atom1@gmail.com>
Signed-off-by: YangYuxi <yx.atom1@gmail.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 include/net/ip_vs.h             | 10 ++++------
 net/netfilter/ipvs/ip_vs_core.c | 12 +++++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 83be2d93b407..fe96aa462d05 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1624,18 +1624,16 @@ static inline void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 }
 #endif /* CONFIG_IP_VS_NFCT */
 
-/* Really using conntrack? */
-static inline bool ip_vs_conn_uses_conntrack(struct ip_vs_conn *cp,
-					     struct sk_buff *skb)
+/* Using old conntrack that can not be redirected to another real server? */
+static inline bool ip_vs_conn_uses_old_conntrack(struct ip_vs_conn *cp,
+						 struct sk_buff *skb)
 {
 #ifdef CONFIG_IP_VS_NFCT
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
-	if (!(cp->flags & IP_VS_CONN_F_NFCT))
-		return false;
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct)
+	if (ct && nf_ct_is_confirmed(ct))
 		return true;
 #endif
 	return false;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..517f6a2ac15a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2066,14 +2066,14 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 
 	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
-		bool uses_ct = false, resched = false;
+		bool old_ct = false, resched = false;
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
 			resched = true;
-			uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
+			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
-			uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
+			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 			if (!atomic_read(&cp->n_control)) {
 				resched = true;
 			} else {
@@ -2081,15 +2081,17 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 				 * that uses conntrack while it is still
 				 * referenced by controlled connection(s).
 				 */
-				resched = !uses_ct;
+				resched = !old_ct;
 			}
 		}
 
 		if (resched) {
+			if (!old_ct)
+				cp->flags &= ~IP_VS_CONN_F_NFCT;
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-			if (uses_ct)
+			if (old_ct)
 				return NF_DROP;
 			cp = NULL;
 		}
-- 
2.26.2

