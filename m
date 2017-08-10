From: Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net] netfilter: check for seqadj ext existence before adding it in nf_nat_setup_info
Date: Thu, 10 Aug 2017 10:22:24 +0800
Message-ID: <941d1a239dcfb3e47b42f8f717ada3029b3adabb.1502331744.git.lucien.xin@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, fgao@ikuai8.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38639 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbdHJCWd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 22:22:33 -0400
Received: by mail-pf0-f194.google.com with SMTP id h75so7756867pfh.5
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Aug 2017 19:22:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 4440a2ab3b9f ("netfilter: synproxy: Check oom when adding synproxy
and seqadj ct extensions") wanted to drop the packet when it fails to add
seqadj ext due to no memory by checking if nfct_seqadj_ext_add returns
NULL.

But that nfct_seqadj_ext_add returns NULL can also happen when seqadj ext
already exists in a nf_conn. It will cause that userspace protocol doesn't
work when both dnat and snat are configured.

Li Shuang found this issue in the case:

Topo:
   ftp client                   router                  ftp server
  10.167.131.2  <-> 10.167.131.254  10.167.141.254 <-> 10.167.141.1

Rules:
  # iptables -t nat -A PREROUTING -i eth1 -p tcp -m tcp --dport 21 -j \
    DNAT --to-destination 10.167.141.1
  # iptables -t nat -A POSTROUTING -o eth2 -p tcp -m tcp --dport 21 -j \
    SNAT --to-source 10.167.141.254

In router, when both dnat and snat are added, nf_nat_setup_info will be
called twice. The packet can be dropped at the 2nd time for DNAT due to
seqadj ext is already added at the 1st time for SNAT.

This patch is to fix it by checking for seqadj ext existence before adding
it, so that the packet will not be dropped if seqadj ext already exists.

Note that as Florian mentioned, as a long term, we should review ext_add()
behaviour, it's better to return a pointer to the existing ext instead.

Fixes: 4440a2ab3b9f ("netfilter: synproxy: Check oom when adding synproxy and seqadj ct extensions")
Reported-by: Li Shuang <shuali@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index eb54178..b1d3740 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -441,7 +441,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		else
 			ct->status |= IPS_DST_NAT;
 
-		if (nfct_help(ct))
+		if (nfct_help(ct) && !nfct_seqadj(ct))
 			if (!nfct_seqadj_ext_add(ct))
 				return NF_DROP;
 	}
-- 
2.1.0

