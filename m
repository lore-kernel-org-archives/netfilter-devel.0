From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Tue, 25 Aug 2009 15:26:41 +0200
Message-ID: <4A93E691.6050404@trash.net>
References: <4A93D817.4080706@trash.net> <alpine.LSU.2.00.0908251522240.9492@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46232 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZHYN0l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:26:41 -0400
In-Reply-To: <alpine.LSU.2.00.0908251522240.9492@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-08-25 14:24, Patrick McHardy wrote:
> 
>> I'm about to commit a couple of patches from some private trees
>> to my nf-next-2.6.git tree. Any comments welcome.
>>
>>
>> int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
>> 			      struct nf_conn *ct,
>> @@ -113,8 +114,11 @@ static unsigned int ipv4_confirm(unsigned int hooknum,
>>
>> 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
>> 			   ct, ctinfo);
>> -	if (ret != NF_ACCEPT)
>> +	if (ret != NF_ACCEPT) {
>> +		nf_log_packet(AF_INET, hooknum, skb, in, out, NULL,
>> +			      "nf_ct_%s: dropping packet", helper->name);
>> 		return ret;
>> +	}
> 
> These calls should probably be using NFPROTO_*.

Good point, I'll fix that up.
