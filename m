From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat_core just using l3proto_find_get
Date: Tue, 11 Mar 2008 15:20:09 +0100
Message-ID: <47D69519.9070404@trash.net>
References: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr> <47BACA14.8000006@trash.net> <Pine.LNX.4.64.0803102259100.21961@fbirervta.pbzchgretzou.qr> <47D691C5.7010907@trash.net> <Pine.LNX.4.64.0803111507320.19018@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:10935 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755320AbYCKOUM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:20:12 -0400
In-Reply-To: <Pine.LNX.4.64.0803111507320.19018@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Mar 11 2008 15:05, Patrick McHardy wrote:
>>>>>         l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
>>>>>
>>> [...]
>>> leading to the original question why nf_nat_core does not use
>>> nf_ct_l3proto_try_module_get.
>> Why should it? There's no need for manual module loading since
>> there already is a symbol dependency.
>>
> 
> According to `modinfo nf_nat`, nf_nat does not have a dependency
> on nf_conntrack_ipv4.

Right, that was iptable_nat.

> So what happens when nf_nat is loaded before nf_conntrack_ipv4?
> (Even if there are dependencies, this question is valid)
> 
> l3proto will be NULL, and is this ok?

No, it will break when translating ICMP errors.

