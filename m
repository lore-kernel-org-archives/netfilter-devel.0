From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH] netfilter: ctnetlink: add zone size to length
Date: Thu, 12 Jun 2014 08:34:55 +0900
Message-ID: <CAGCkEt29_QnR1N9+oPQt7mX=6_0GF0oTsT4WgTz_ajGyef+Odg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58736 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaFKXe5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:34:57 -0400
Received: by mail-lb0-f173.google.com with SMTP id s7so33221lbd.18
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 16:34:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nf_conntrack_netlink.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c
b/net/netfilter/nf_conntrack_netlink.c
index 5857963..e279b76 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -597,6 +597,9 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_MARK
               + nla_total_size(sizeof(u_int32_t)) /* CTA_MARK */
 #endif
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+              + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE */
+#endif
               + ctnetlink_proto_size(ct)
               + ctnetlink_label_size(ct)
               ;
@@ -2040,6 +2043,9 @@ ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_MARK
               + nla_total_size(sizeof(u_int32_t)) /* CTA_MARK */
 #endif
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+              + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE */
+#endif
               + ctnetlink_proto_size(ct)
               ;
 }
--
1.7.10.4
