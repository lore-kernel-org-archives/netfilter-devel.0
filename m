From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 01 Oct 2007 00:56:33 +0200
Message-ID: <470029A1.9000506@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205335.10969.91031.stgit@nessa.odu> <470026AF.5060404@trash.net> <200710010051.04814@nessa>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49682 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbXI3XAP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:00:15 -0400
In-Reply-To: <200710010051.04814@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> Hi Patrick,
>
> On Monday 01 October 2007, Patrick McHardy wrote:
>   
>> KOVACS Krisztian wrote:
>>     
>>> The TPROXY target implements redirection of non-local TCP/UDP traffic
>>> to local sockets. Additionally, it's possible to manipulate the
>>> packet mark if and only if a socket has been found. (We need this
>>> because we cannot use multiple targets in the same iptables rule.)
>>>
>>> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
>>> ---
>>> +++ b/include/linux/netfilter_ipv4/ipt_TPROXY.h
>>> @@ -0,0 +1,14 @@
>>> +#ifndef _IPT_TPROXY_H_target
>>> +#define _IPT_TPROXY_H_target
>>> +
>>> +/* TPROXY target is capable of marking the packet to perform
>>> + * redirection. We can get rid of that whenever we get support for
>>> + * mutliple targets in the same rule. */
>>> +struct ipt_tproxy_target_info {
>>> +	__be32 laddr;
>>> +	__be16 lport;
>>> +	unsigned long mark_mask;
>>> +	unsigned long mark_value;
>>>       
>> This should use fixed size types.
>>     
>
> Yes, but marks are unsigned longs, aren't they? So if we restrict this to 
> say 32bit then we lose the ability to use the upper half of the mark...
>   

No, marks are 32 bit for a long time now. The unsigned longs in
the mark target and matches are just there for compatiblity.

(BTW, going to sleep now, will continue tommorrow)
