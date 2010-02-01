From: Patrick McHardy <kaber@trash.net>
Subject: Re: [REPORT] may be wrong place #endif in include/linux/netfilter_ipv4.h
Date: Mon, 01 Feb 2010 15:00:02 +0100
Message-ID: <4B66DE62.8080801@trash.net>
References: <4B64E732.3090507@gmail.com> <alpine.LSU.2.01.1001311019430.15188@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "Helight.Xu" <helight.xu@gmail.com>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38426 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0BAOAH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:00:07 -0500
In-Reply-To: <alpine.LSU.2.01.1001311019430.15188@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2010-01-31 03:13, Helight.Xu wrote:
> 
>> hi all gys:
>>
>>   when I make LKM with netfilter on "NF_IP_PRE_ROUTING" point, but it was
>> reported that "NF_IP_PRE_ROUTING" is not defined.
>>
>>   but I am surely including <linux/netfilter_ipv4.h>, when I opened
>> include/linux/netfilter_ipv4.h I found that
>> "NF_IP_PRE_ROUTING" is in this lable :
>> #ifndef __KERNEL__
>> .....
>> /* IP Hooks */
>> /* After promisc drops, checksum checks. */
>> #define NF_IP_PRE_ROUTING       0
>> /* If the packet is destined for this box. */
>> #define NF_IP_LOCAL_IN          1
>> /* If the packet is destined for another interface. */
>> #define NF_IP_FORWARD           2
>> /* Packets coming from a local process. */
>> #define NF_IP_LOCAL_OUT         3
>> /* Packets about to hit the wire. */
>> #define NF_IP_POST_ROUTING      4
>> #define NF_IP_NUMHOOKS          5
>> #endif /* ! __KERNEL__ */
>>
>> So I think the "endif" is ended a little early!
> 
> Seems so. Are there any out-of-tree nf_ip_hook_priorities users? If not, 
> we could possibly move it further below.

Its only available for userspace for compatibility reasons,
the kernel doesn't use the old definitions.
