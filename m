From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: Remove skb_is_nonlinear check from nf_conntrack_sip
Date: Fri, 14 May 2010 12:16:42 +0200
Message-ID: <4BED230A.8020002@trash.net>
References: <20100514003834.GY15969@obsidianresearch.com> <alpine.LSU.2.01.1005140849500.28602@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab0ENKQq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 06:16:46 -0400
In-Reply-To: <alpine.LSU.2.01.1005140849500.28602@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2010-05-14 02:38, Jason Gunthorpe wrote:
> 
>> At least the XEN net front driver always produces non linear skbs,
>> so the SIP module does nothing at all when used with that NIC.
>>
>> Copy the hacky technique for accessing SKB data from the ftp conntrack,
>> better than nothing..
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>>
>> +/* This is slow, but it's simple. --RR */
>> +static char *sip_buffer;
>> +static DEFINE_SPINLOCK(nf_sip_lock);
>> +
> 
> skb_linearize seems simpler. (What about the cost?)

Yeah, we have to use skb_linearize(). The SIP NAT helper might mangle
the packet and alter its size, at which point we'd have to make a new
copy of the data area to get the offsets right.
