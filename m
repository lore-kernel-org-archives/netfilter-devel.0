From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] net: netfilter: Remove multiple assignment.
Date: Sat, 25 Mar 2017 18:19:47 +0530
Message-ID: <20170325124946.GA9109@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34731 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbdCYMty (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2017 08:49:54 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes multiple assignments.
Done using coccinelle.
@@
identifier i1,i2;
constant c;
@@
- i1=i2=c;
+ i1=c;
+ i2=c;

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
contribution to outreachy netfilter project.

 net/netfilter/nf_conntrack_proto_sctp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 33279aab583d..723386bcc2cb 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -346,7 +346,8 @@ static int sctp_packet(struct nf_conn *ct,
 		goto out;
 	}
 
-	old_state = new_state = SCTP_CONNTRACK_NONE;
+	old_state = SCTP_CONNTRACK_NONE;
+	new_state = old_state;
 	spin_lock_bh(&ct->lock);
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Special cases of Verification tag check (Sec 8.5.1) */
-- 
2.11.0

