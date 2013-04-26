From: Jorge Ventura <jorge.araujo.ventura@gmail.com>
Subject: Re: xt_CHECKSUM doesn't work as expected
Date: Fri, 26 Apr 2013 14:59:41 -0500
Message-ID: <CAJEG_NfuTPZ3yx+eFXbLN_aXeChNPhmpLao4X28z447-Lt4CYA@mail.gmail.com>
References: <CAJEG_Nc63CdikpWiuJrBrjZ08v8rY5c9PvFwqAKkynDyvfRqPw@mail.gmail.com>
	<20130419121816.GE19523@macbook.localnet>
	<CAJEG_NeONSxWwkzXkpYXzi5sdSNseuhm2dsRsYvj1O=DrHN_Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:61845 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab3DZT7n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:59:43 -0400
Received: by mail-la0-f53.google.com with SMTP id eg20so3906958lab.40
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2013 12:59:41 -0700 (PDT)
In-Reply-To: <CAJEG_NeONSxWwkzXkpYXzi5sdSNseuhm2dsRsYvj1O=DrHN_Ww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Never mind, here is the answer:

 *      PARTIAL: identical to the case for output below.  This may occur
 *          on a packet received directly from another Linux OS, e.g.,
 *          a virtualised Linux kernel on the same host.  The packet can
 *          be treated in the same way as UNNECESSARY except that on
 *          output (i.e., forwarding) the checksum must be filled in
 *          by the OS or the hardware.



On Fri, Apr 26, 2013 at 2:51 PM, Jorge Ventura
<jorge.araujo.ventura@gmail.com> wrote:
> I have been doing many tests using xt_CHECKSUM and observed:
>
> When I have the check sum = 0, skb->ip_summed is equal to
> CHECKSUM_COMPLETE and the xt_CHECKSUM does nothing but the packet
> leave the host with correct check sum, what make sense because check
> sum = 0 means "no check sum".
>
> The module should do something only when  skb->ip_summed ==
> CHECKSUM_PARCIAL, that means someone else is taking care of fill out
> the correct check sum. I removed the mangle rule using xt_CHECKSUM and
> obviously the result was the same.
>
> I sent one packet with wrong check sum using the mangle rule and the
> check sum was not fixed because skb->ip_summed == CHECKSUM_NONE.
>
> The only scenery that xt_CHECKSUM  will do something is "bad checksum"
> and "skb->ip_summed == CHECKSUM_PARCIAL". In real world, what
> situation is that ???
>
> On Fri, Apr 19, 2013 at 7:18 AM, Patrick McHardy <kaber@trash.net> wrote:
>> On Thu, Apr 18, 2013 at 10:48:38AM -0500, Jorge Ventura wrote:
>>> Dear nf devels,
>>> I am trying to use the xt_CHECKSUM module to fix an UDP packet that
>>> it's comming with check sum error. I have an iptables firewall with
>>> two ethernet cards (eth0 private and eth1 public), all ethernet
>>> offload parameters are off in both ethernet cards and
>>> nf_conntrack_checksum = 0.
>>>
>>> This is my iptables rule to fix the checksum:
>>>
>>> iptables -A POSTROUTING -t mangle -p udp --dport 162 -j CHECKSUM --checksum-fill
>>>
>>> The trafic resulting when the single UDP packet is received using tcpdump:
>>>
>>> input at eth1 (public):  [src ip].1046 > [eth1 public ip].162: [bad
>>> udp cksum ff!]
>>> output at eth0 (private): [src ip].1046 > [eth0 private ip].162: [bad
>>> udp cksum ff!]
>>>
>>> I did use printk inside the module to see what do I have at
>>> skb->ip_summed and I observed that the value is CHECKSUM_NONE, however
>>> to have the checksum fixed by the function checksum_tg, this value
>>> should be CHECKSUM_PARTIAL.
>>>
>>> Please let me know if I am miss understanding the way that
>>> --checksum-fill is handled by xt_CHECKSUM module.
>>
>> The target can only compute proper checksums for packets which have no
>> checksum set. If it is already set, the value will get included in the
>> calculation and the result will be wrong.
