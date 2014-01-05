From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH nf] netfilter: nf_conntrack: fix skb_header_pointer API usages in DCCP
Date: Mon,  6 Jan 2014 00:57:54 +0100
Message-ID: <1388966274-9532-1-git-send-email-dborkman@redhat.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaAEX56 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:57:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some occurences in the netfilter tree use skb_header_pointer() in
the following way ...

  struct dccp_hdr _dh, *dh;
  ...
  skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);

... where dh itself is a pointer that is being passed as the copy
buffer. Instead, we need to use &_dh as the forth argument so that
we're copying the data into an actual buffer that sits on the stack.

Currently, we probably could overwrite memory on the stack (e.g.
with a possibly mal-formed DCCP packet), but unintentionally, as
we only want the buffer to be placed into _dh variable.

Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol support")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index a99b6c3..59359be 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -428,7 +428,7 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	const char *msg;
 	u_int8_t state;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
@@ -486,7 +486,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	u_int8_t type, old_state, new_state;
 	enum ct_dccp_roles role;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 	type = dh->dccph_type;
 
@@ -577,7 +577,7 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 	unsigned int cscov;
 	const char *msg;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		msg = "nf_ct_dccp: short packet ";
 		goto out_invalid;
-- 
1.7.11.7

