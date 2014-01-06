From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH nf-next] netfilter: nf_log: use %s format string for buffer
Date: Mon,  6 Jan 2014 01:04:16 +0100
Message-ID: <1388966656-12414-1-git-send-email-dborkman@redhat.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaAFAEV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:04:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some invocations of nf_log_packet() use arg buffer directly instead of
"%s" format string with follow-up buffer pointer. Currently, these two
usages are not really critical, but we should fix this up nevertheless
so that we don't run into trouble if that changes one day.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index a99b6c3..3841268 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -457,7 +457,7 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 out_invalid:
 	if (LOG_INVALID(net, IPPROTO_DCCP))
 		nf_log_packet(net, nf_ct_l3num(ct), 0, skb, NULL, NULL,
-			      NULL, msg);
+			      NULL, "%s", msg);
 	return false;
 }
 
@@ -614,7 +614,7 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 
 out_invalid:
 	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL, msg);
+		nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL, "%s", msg);
 	return -NF_ACCEPT;
 }
 
-- 
1.7.11.7

