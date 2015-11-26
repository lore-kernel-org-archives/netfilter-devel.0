From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 nf-next 3/3] netfilter: nf_tables: wrap tracing with a
 static key
Date: Thu, 26 Nov 2015 21:30:29 +0000
Message-ID: <20151126213029.GB3993@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbbKZVae (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 16:30:34 -0500
Content-Disposition: inline
In-Reply-To: <1448560779-28989-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 26.11, Florian Westphal wrote:
> Only needed when meta nftrace rule(s) were added.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Changes since v1:
>   - do not wrap rulenum++ into static key, because
>   it might get incremented too late when trace
>   rules are added/removed at high rate, giving wrong results.
>   - add EXPORT_SYMBOL for nft_meta_set_destroy.
> 
>  There was another followup patch to disable old tracing
>  infrastructure, but I dropped this for now.
> 
>  So, for the time being, you get both tracing formats.
> 
>  Should be easy to add sysctl later on to disable the old
>  format.

Just an observation so far: this really bloats nft_do_chain(), in my
compilation it adds 655 bytes and inlines all the tracing stuff multiple
times into critical spots. We really need to get this down.

First simple and easy attempt was the attached patch, it brings it down
to only +236b. But I think we can still do better.

One idea would be to wrap the local state in a struct. That way we
can pass all of it together using a single pointer. For that We could
use the current jump stack frame to hold also the *current* chain and
rule pointers if we can make sure the compiler will still use registers
for the current ones.

The nft_trace_notify() invocation should probably be moved to
__nft_trace_packet() and if still necessary that should be marked
noinline.

Just a couple of ideas for a start. We really need to avoid bloating
these critical loops.

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 5d3d37b..414622a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -45,14 +45,14 @@ static struct nf_loginfo trace_loginfo = {
 	},
 };
 
-static void __nft_trace_packet(const struct nft_pktinfo *pkt,
-			       const struct nft_chain *chain,
-			       int rulenum, enum nft_trace type)
+static noinline void __nft_trace_packet(struct nft_traceinfo *info,
+			       const struct nft_pktinfo *pkt,
+			       int rulenum)
 {
 	nf_log_trace(pkt->net, pkt->pf, pkt->hook, pkt->skb, pkt->in,
 		     pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
-		     chain->table->name, chain->name, comments[type],
-		     rulenum);
+		     info->chain->table->name, info->chain->name,
+		     comments[info->type], rulenum);
 }
 
 static inline void nft_trace_packet(struct nft_traceinfo *info,
@@ -73,7 +73,7 @@ static inline void nft_trace_packet(struct nft_traceinfo *info,
 		info->type = type;
 		nft_trace_notify(info, pkt);
 
-		__nft_trace_packet(pkt, chain, rulenum, type);
+		__nft_trace_packet(info, pkt, rulenum);
 	}
 }
 

--h31gzZEtNLTqOjlF--
