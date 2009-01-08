From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: ct_extend: alloc space for xt_portscan
Date: Thu, 8 Jan 2009 09:24:16 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901080924030.2273@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33360 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZAHIYT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:24:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent b58602a4bac012b5f4fc12fe6b46ab237b610d5d
commit 7634e5f586394eafc85973712ff11e60a9ae2f70
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jan 8 09:20:03 2009 +0100

netfilter: ct_extend: alloc space for xt_portscan

The out-of-tree xt_portscan module currently (ab)uses skb->mark and
nfct->mark to store its state, but such may collide with
user-specified marks.

Using nfct_extend alleviates that problem and hopefully paves way
for inclusion of the module.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/net/netfilter/nf_conntrack_extend.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index da8ee52..389794a 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -8,6 +8,7 @@ enum nf_ct_ext_id
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
 	NF_CT_EXT_ACCT,
+	NF_CT_EXT_PORTSCAN, /* xt_portscan state */
 	NF_CT_EXT_NUM,
 };
 

