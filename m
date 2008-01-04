From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Fri, 04 Jan 2008 16:07:30 +0100
Message-ID: <477E4BB2.7020503@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <Pine.LNX.4.64.0801041603510.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49030 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYADPKg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:10:36 -0500
In-Reply-To: <Pine.LNX.4.64.0801041603510.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 4 2008 15:53, Patrick McHardy wrote:
>> Applied, but
>>
>>>  #include <linux/netfilter/nf_conntrack_tuple_common.h>
>>> -#include <linux/in.h>
>>> +#ifdef __KERNEL__
>>> +#	include <linux/in.h>
>>> +#endif
>> Is that really necessary? I would prefer the only in-kernel user of this
>> file to include it directly. Or simply include netfilter.h, which seems
>> necessary for nf_inet_addr anyway.
>>
> With this #include, we grab the definition for 'struct in_addr'.
> 
> Yes it is necessary otherwise iptables fails to compile, because
> struct in_addr is already sourced from netinet/in.h. If you have
> a better idea, please share it.
> Perhaps doing #include <linux/in.h> in xt_conntrack.c would resolve it.
> I will see to that (if you do not already will take care of that) once I 
> received your updated git tree.

Well, netfilter.h already includes linux/in.h, so that should work
fine, no?
