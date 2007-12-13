From: Patrick McHardy <kaber@trash.net>
Subject: Re: Wrong ethernet headers after double postrouting fix
Date: Thu, 13 Dec 2007 09:41:04 +0100
Message-ID: <4760F020.5070405@trash.net>
References: <9a4a382a0712130005l49a72164r26e5818060534285@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050900060204070202000800"
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36701 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLMIlV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:41:21 -0500
In-Reply-To: <9a4a382a0712130005l49a72164r26e5818060534285@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050900060204070202000800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Damien Thébault wrote:
> Hello,
> 
> I'm using a nat-over-bridges setup with two bridges and I'm using
> iptables to MASQUERADE over it.
> I'm trying to use rtsp so I applied the rtsp conntrack/nat patch (to
> the 2.6.23 kernel I'm using actually) [1]. But it doesn't work because
> the nat seems to be done twice.
> After some search, I found a patch [2] which should solve this problem
> (bridge-to-bridge routing). So I applied it, but then I get wrong
> packets on the output (see below).
> I tried with 2.6.24-rc5 and the result is similar (the output below is
> with 2.6.24-rc5).
> 
> [1] http://mike.it-loops.com/rtsp/rtsp-2.6.23.patch
> [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=81d9ddae856678c45297550e9353c8a5a7fd6438
> 
> (The captures were taken with tcpdump and displayed with wireshark,
> tell me if it's not the right way to post it)
> 
> LAN-side bridge setup : IP 192.168.1.1    MAC 00:03:47:df:32:a8
> WAN-side bridge setup : IP 172.20.211.144 MAC 10:d0:cf:03:fc:52
> LAN client            : IP 192.168.1.206  MAC 00:19:4b:27:ca:86
> WAN server gateway    : IP 172.20.211.190 MAC 00:03:fa:00:05:00
> 
> [...]
> We can see that the outputted packets have a wrong ethernet header :
> ac 14 df 8c 00 00 00 00  00 00 00 00 00 00
> Without the patch, the same header is good :
> 00 03 fa 00 05 00 10 d0  cf 03 fc 52 08 00
> 
> The ethertype is set to 00 00 instead of 08 00 (IPv4), the destination
> mac address is set to the destination ip address instead, and there is
> no source mac address.
> 
> I think that the ethernet-building stage is not run anymore in my
> case, but I don't know really why.
> Any help would be appreciated.


Thanks for debugging this so far. The bridge-netfilter code is really
horribly fragile.

Could you try this patch please?


--------------050900060204070202000800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 533ee35..499aa93 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -50,7 +50,8 @@ enum nf_br_hook_priorities {
 extern int nf_bridge_copy_header(struct sk_buff *skb);
 static inline int nf_bridge_maybe_copy_header(struct sk_buff *skb)
 {
-	if (skb->nf_bridge)
+	if (skb->nf_bridge &&
+	    skb->nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))
 		return nf_bridge_copy_header(skb);
   	return 0;
 }

--------------050900060204070202000800--
