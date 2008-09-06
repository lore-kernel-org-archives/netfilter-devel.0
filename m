From: Jan Engelhardt <jengelh@medozas.de>
Subject: rfc: DROP returns error
Date: Sat, 6 Sep 2008 13:41:57 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809061338180.20668@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42369 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYIFRl7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:41:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 90B121C00DA6F
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Sep 2008 13:41:57 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Time and again I notice users complaining about DROP returning an error 
when used in the OUTPUT chain:

root@nuqneh:~# iptables -A OUTPUT -o lo -p icmp -j DROP
root@nuqneh:~# ping -c1 localhost
PING localhost (127.0.0.1) 56(84) bytes of data.
ping: sendmsg: Operation not permitted
--- localhost ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

I am wondering whether we should either add a new verdict to
accomodate for this, or do the following:

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b16cd79..2de3772 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -185,7 +185,6 @@ next_hook:
                goto unlock;
        } else if (verdict == NF_DROP) {
                kfree_skb(skb);
-               ret = -EPERM;
        } else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
                if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
                              verdict >> NF_VERDICT_BITS))

