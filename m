From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: xt_osf: fix nf_log_packet() arguments
Date: Thu, 16 Jul 2009 14:26:46 +0200 (MEST)
Message-ID: <20090716122640.23343.65631.sendpatchset@x2.localnet>
References: <20090716122638.23343.77832.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55085 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbZGPM0r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:26:47 -0400
In-Reply-To: <20090716122638.23343.77832.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit aa6a03eb0ae859c1371555ef381de4c96ca1e4e6
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jul 16 14:01:54 2009 +0200

    netfilter: xt_osf: fix nf_log_packet() arguments
    
    The first argument is the address family, the second one the hook
    number.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 863e409..0f482e2 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -330,7 +330,8 @@ static bool xt_osf_match_packet(const struct sk_buff *skb,
 			fcount++;
 
 			if (info->flags & XT_OSF_LOG)
-				nf_log_packet(p->hooknum, 0, skb, p->in, p->out, NULL,
+				nf_log_packet(p->family, p->hooknum, skb,
+					p->in, p->out, NULL,
 					"%s [%s:%s] : %pi4:%d -> %pi4:%d hops=%d\n",
 					f->genre, f->version, f->subtype,
 					&ip->saddr, ntohs(tcp->source),
@@ -345,7 +346,7 @@ static bool xt_osf_match_packet(const struct sk_buff *skb,
 	rcu_read_unlock();
 
 	if (!fcount && (info->flags & XT_OSF_LOG))
-		nf_log_packet(p->hooknum, 0, skb, p->in, p->out, NULL,
+		nf_log_packet(p->family, p->hooknum, skb, p->in, p->out, NULL,
 			"Remote OS is not known: %pi4:%u -> %pi4:%u\n",
 				&ip->saddr, ntohs(tcp->source),
 				&ip->daddr, ntohs(tcp->dest));
