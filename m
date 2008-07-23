From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Wed, 23 Jul 2008 15:32:07 +0100
Message-ID: <488740E7.3040005@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37220 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752394AbYGWOcJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:32:09 -0400
In-Reply-To: <4884CC17.3020905@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Callgraph information would be useful since its unclear whether
>> this is the memcpy triggered by netlink message trimming in
>> af_netlink.c or something different. Unfortunately according
>> to the documentation this is only supported on x86. I think
>> selecting the netfilter options as modules should provide
>> slightly more detail though.
[...]
> 
> memcpy is mostly invoked by skb_copy and netlink_broadcast (af_netlink). 
> netlink_broadcast is expensive on its own and calls pskb_expand_head 
> which is expensive as well. Using multipart messages would reduce the 
> need to call netlink_broadcast.

I profiled again with nfnetlink and nf_conntrack compiled as modules:
    103599 61.1842 vmlinux
     24481 14.4582 ath_pci
     19232 11.3582 nf_conntrack
     10435  6.1628 wlan
      3588  2.1190 nf_conntrack_netlink
      2869  1.6944 oprofiled
      1886  1.1138 nf_conntrack_ipv4
      1447  0.8546 ath_rate_minstrel
       627  0.3703 nfnetlink
       237  0.1400 ld-uClibc-0.9.29.so
       233  0.1376 libuClibc-0.9.29.so
       183  0.1081 iptable_raw
       174  0.1028 ctevtest
       147  0.0868 busybox
        85  0.0502 libnfnetlink.so.0.2.0
        60  0.0354 libnetfilter_conntrack.so.1.2.0
        38  0.0224 arp_tables
         2  0.0012 arptable_filter

Again most of the time is spent in the kernel. Memory and skb operations 
are accounted there. I suspect that they cause the most overhead.

Do you plan to dig deeper into optimising the non-optimal parts? I 
consider myself not to have enough understanding to do it myself.
