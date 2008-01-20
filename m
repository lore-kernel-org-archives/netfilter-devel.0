From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [16/19] libxt_iprange r0
Date: Sun, 20 Jan 2008 19:05:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201903541.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801161453070.4953@fbirervta.pbzchgretzou.qr> <47934FB9.20203@trash.net>
 <Pine.LNX.4.64.0801201810400.14598@fbirervta.pbzchgretzou.qr>
 <479382BE.6050106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43005 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbYATSFK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:05:10 -0500
In-Reply-To: <479382BE.6050106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 18:19, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Jan 20 2008 14:42, Patrick McHardy wrote:
>> > > Index: iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
>> > > ===================================================================
>> > > --- iptables-modules.orig/include/linux/netfilter_ipv4/ipt_iprange.h
>> > > +++ iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
>> > Do we really want to keep this file?
>> >
>> If you value compatibilty, then yes.
>> 
>> (Did I understand that correctly?)
>
> I thought the xt_iprange file included the old options, if thats
> not the case then ignore my question.
>
>
Options?

xt_iprange r0 is the same as ipt_iprange, including binary layout
of the struct and that. So we need to keep ipt_iprange.h. Or rather,
keep struct ipt_iprange.

I would not want to move struct ipt_iprange to xt_iprange.h because
that means more maintenance overhead.
