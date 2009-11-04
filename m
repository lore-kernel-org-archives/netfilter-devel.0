From: Patrick McHardy <kaber@trash.net>
Subject: Re: questions regaring ARP, NFQUEUE, and enumerations
Date: Wed, 04 Nov 2009 12:23:56 +0100
Message-ID: <4AF1644C.9070800@trash.net>
References: <31194109.4191257281854408.JavaMail.root@venus.ecs.csus.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050601010405080505000906"
Cc: netfilter-devel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Branson <bransone@ecs.csus.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35847 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbZKDLXx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:23:53 -0500
In-Reply-To: <31194109.4191257281854408.JavaMail.root@venus.ecs.csus.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050601010405080505000906
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Eric Branson wrote:
> I want to capture ARP packets on ingress but I am having trouble understanding the current netfilter architecture. I have not been able to receive any ARP packets through NFQUEUE (using `arptables -A INPUT -j QUEUE`) using a modified nfqnl_test and I was wondering if this is currently supported or even possible. If so, what type of modifications must be made to nfqnl_test.c to receive them? Am I going to have to write a kernel module similar to ip_queue.c? (If its more complicated than that just say so; I'm still wrapping my head around the network and netfilter subsystems.)
> 
> Following nfqnl_test.c I see that both nfq_open() and nfq_bind_pf() use AF_* enumerations, but nfqnl_recv_config() within the kernel, which I assume ultimately receives the NFQA_CFG_CMD message, indexes queue_handler with the given AF_* but would seem to expect NFPROTO_* enumerations, which are different (such as AF_AX25 and NFPROTO_ARP). Which enumeration is supposed to be used, AF_* or NFPROTO_*?

This is currently not supported. This patch might make it work,
but its completely untested.



--------------050601010405080505000906
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3a6fd77..27a701f 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -130,10 +130,8 @@ static int __nf_queue(struct sk_buff *skb,
 		goto err_unlock;
 
 	afinfo = nf_get_afinfo(pf);
-	if (!afinfo)
-		goto err_unlock;
-
-	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry) + afinfo ? afinfo->route_key_size : 0,
+			GFP_ATOMIC);
 	if (!entry)
 		goto err_unlock;
 
@@ -169,7 +167,8 @@ static int __nf_queue(struct sk_buff *skb,
 			dev_hold(physoutdev);
 	}
 #endif
-	afinfo->saveroute(skb, entry);
+	if (afinfo)
+		afinfo->saveroute(skb, entry);
 	status = qh->outfn(entry, queuenum);
 
 	rcu_read_unlock();
@@ -247,7 +246,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	if (verdict == NF_ACCEPT) {
 		afinfo = nf_get_afinfo(entry->pf);
-		if (!afinfo || afinfo->reroute(skb, entry) < 0)
+		if (afinfo && afinfo->reroute(skb, entry) < 0)
 			verdict = NF_DROP;
 	}
 

--------------050601010405080505000906--
