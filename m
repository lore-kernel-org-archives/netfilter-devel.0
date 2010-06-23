From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC
 header
Date: Wed, 23 Jun 2010 19:03:29 +0200
Message-ID: <4C223E61.2030804@trash.net>
References: <4C22324E.2060404@trash.net> <alpine.LSU.2.01.1006231840180.21618@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45082 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab0FWRDd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:03:33 -0400
In-Reply-To: <alpine.LSU.2.01.1006231840180.21618@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-06-23 18:11, Patrick McHardy wrote:
>
>   
>> +	switch (dev->type) {
>> +	case ARPHRD_ETHER:
>> +		printk("MACSRC=%pM MACDST=%pM MACPROTO=%.4x ",
>> +		       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
>> +		       ntohs(eth_hdr(skb)->h_proto));
>>     
>
> Why not just the standard %04x? [Same applies to v6]
>   

I guess that would be more consistent with the existing printks.

>> +	printk("MAC=");
>> +	if (dev->hard_header_len &&
>> +	    skb->mac_header != skb->network_header) {
>> +		const unsigned char *p = skb_mac_header(skb);
>> +		unsigned int i;
>> +
>> +		for (i = 0; i < dev->hard_header_len; i++, p++)
>> +			printk("%02x%c", *p,
>> +			       i == dev->hard_header_len - 1 ? ' ' : ':');
>>     
>
> 		if (dev->hard_header_len > 0)
> 			printk("%02x", *p++);
> 		for (i = 1; i < dev->hard_header_len; ++i)
> 			printk(":%02x", *p++);
>
> I like better for getting rid of the comparison inside the loop.
>   

Looks fine, I'll change that in a seperate patch.

>> +	/* MAC logging for input chain only. */
>>     
>
> "input path".
>   

Correct.

>> +	if (in && !out)
>> +		dump_mac_header(loginfo, skb);
>>
>> 	dump_packet(loginfo, skb, 0);
>>     
>
> # ipv6
>   
>> 	printk("\n");
>> +	if (dev->hard_header_len &&
>> +	    skb->mac_header != skb->network_header) {
>> +		const unsigned char *p = skb_mac_header(skb);
>> +		unsigned int len = dev->hard_header_len;
>> +		unsigned int i;
>> +
>> +		if (dev->type == ARPHRD_SIT &&
>> +		    (p -= ETH_HLEN) < skb->head)
>> +			p = NULL;
>>     
>
> What is the purpose of this? If the device is a sit, there is no
> guarantee that there's any ethernet header in the skb.
>   

Correct, that's what the test is determining. This is all existing
code that has just been moved around.
