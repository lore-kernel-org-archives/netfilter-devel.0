From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ipvs: fix incorrect conflict resolution
Date: Tue, 18 Apr 2017 17:49:56 +0200
Message-ID: <20170418154956.22233-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36950 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751783AbdDRQBq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 12:01:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The commit ab8bc7ed864b9c4f1fcb00a22bbe4e0f66ce8003
("netfilter: remove nf_ct_is_untracked")
changed the line
   if (ct && !nf_ct_is_untracked(ct) && nfct_nat(ct)) {
	   to
   if (ct && nfct_nat(ct)) {

meanwhile, the commit 41390895e50bc4f28abe384c6b35ac27464a20ec
("netfilter: ipvs: don't check for presence of nat extension")
from ipvs-next had changed the same line to

  if (ct && !nf_ct_is_untracked(ct) && (ct->status & IPS_NAT_MASK)) {

When ipvs-next got merged into nf-next, the merge resolution took
the first version, dropping the conversion of nfct_nat().

While this doesn't cause a problem at the moment, it will once we stop
adding the nat extension by default.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, I prefer if this can go via nf-next rather than ipvs-next.

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index af3a9bbdf2ae..fb780be76d15 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -260,8 +260,9 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		buf_len = strlen(buf);
 
 		ct = nf_ct_get(skb, &ctinfo);
-		if (ct && nfct_nat(ct)) {
+		if (ct && (ct->status & IPS_NAT_MASK)) {
 			bool mangled;
+
 			/* If mangling fails this function will return 0
 			 * which will cause the packet to be dropped.
 			 * Mangling can only fail under memory pressure,
-- 
2.10.2

