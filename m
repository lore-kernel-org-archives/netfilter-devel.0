From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 03 Apr 2008 15:56:22 +0200
Message-ID: <47F4E206.2090101@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de> <47F4C686.2000700@trash.net> <alpine.LNX.1.10.0804031444200.1301@fbirervta.pbzchgretzou.qr> <47F4D8F3.70606@trash.net> <alpine.LNX.1.10.0804031520250.1301@fbirervta.pbzchgretzou.qr> <47F4DF5A.8090907@trash.net> <alpine.LNX.1.10.0804031548220.1301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYDCN40 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:56:26 -0400
In-Reply-To: <alpine.LNX.1.10.0804031548220.1301@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Thursday 2008-04-03 15:44, Patrick McHardy wrote:
>>
>>> >  I don't like exporting this since, as you say, userspace doesn't
>>> >  need it
>>>
>>>  Somehow you have to say that an extension if for arp only.
>>>  We could abuse ETH_P_ARP, but using just the same name and value
>>>  across both user and kernelspace seems just more logical.
>>>
>>>  static struct xtables_target new_arp_mangle = {
>>>      .family = ETH_P_ARP,
>>>  };
>>
>> Whats the problem with moving NF_ARP outside userspace
>> visibility and defining it to AF_MAX + 1?
>>
> I guess it would work. Given that my currently running kernel
> did not break on removing NF_ARP entirely and substituting it
> by PF_ARP=21...
> can we at least go for a more verbose name like NFPROTO_ARP?

Sure. I'd suggest to do something like this:

enum nf_protos {
	__NF_PROTO_MIN	= AF_MAX,
	NF_PROTO_ARP,
};

BTW, I'll go over your remaining non-arptables patch today,
please only repost the arptables patchces (and the ebtables
one if it logically belongs together) as one series with
some explanations on what it is trying to do as a whole
and the concept.

