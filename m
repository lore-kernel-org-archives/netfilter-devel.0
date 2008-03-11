From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: nf_nat_core just using l3proto_find_get
Date: Tue, 11 Mar 2008 15:16:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803111507320.19018@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr>
 <47BACA14.8000006@trash.net> <Pine.LNX.4.64.0803102259100.21961@fbirervta.pbzchgretzou.qr>
 <47D691C5.7010907@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35759 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYCKOQO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:16:14 -0400
In-Reply-To: <47D691C5.7010907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 11 2008 15:05, Patrick McHardy wrote:
>> > >
>> > >         l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
>> > >
>> [...]
>> leading to the original question why nf_nat_core does not use
>> nf_ct_l3proto_try_module_get.
>
> Why should it? There's no need for manual module loading since
> there already is a symbol dependency.
>

According to `modinfo nf_nat`, nf_nat does not have a dependency
on nf_conntrack_ipv4.

So what happens when nf_nat is loaded before nf_conntrack_ipv4?
(Even if there are dependencies, this question is valid)

l3proto will be NULL, and is this ok?
