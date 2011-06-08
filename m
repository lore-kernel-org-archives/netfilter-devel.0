From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_nat: fix crash in nf_nat_csum
Date: Wed, 08 Jun 2011 11:36:18 +0200
Message-ID: <4DEF4292.2070904@trash.net>
References: <alpine.LFD.2.00.1105292335220.1429@ja.ssi.bg> <4DEE22A4.8060202@trash.net> <alpine.LFD.2.00.1106072246570.1619@ja.ssi.bg> <4DEEADCB.8000803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41273 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1FHJg2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:36:28 -0400
In-Reply-To: <4DEEADCB.8000803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.06.2011 01:01, Patrick McHardy wrote:
> On 07.06.2011 22:02, Julian Anastasov wrote:
>>
>> 	Hello,
>>
>> On Tue, 7 Jun 2011, Patrick McHardy wrote:
>>
>>> On 29.05.2011 22:42, Julian Anastasov wrote:
>>>>
>>>> 	Fix crash in nf_nat_csum when mangling packets
>>>> in OUTPUT hook where skb->dev is not defined, it is set
>>>> later before POSTROUTING. Problem happens for CHECKSUM_NONE.
>>>> We can check device from rt but using CHECKSUM_PARTIAL
>>>> should be safe (skb_checksum_help).
>>>
>>> We don't call helpers in LOCAL_OUT, how can this happen?
>>
>> 	I think, this happened with IPVS only in OUTPUT hook: 
>> tcp_snat_handler -> ip_vs_ftp_out -> nf_nat_mangle_tcp_packet -> 
>> nf_nat_csum. This is again PASV FTP via loopback.
> 
> I see, thanks. I'll add a comment and will apply this tommorrow.

I must have overlooked the message, just noticed that this patch
is already applied,
