From: Patrick McHardy <kaber@trash.net>
Subject: Re: [16/19] libxt_iprange r0
Date: Sun, 20 Jan 2008 18:19:58 +0100
Message-ID: <479382BE.6050106@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161453070.4953@fbirervta.pbzchgretzou.qr> <47934FB9.20203@trash.net> <Pine.LNX.4.64.0801201810400.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62562 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbYATRUG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:20:06 -0500
In-Reply-To: <Pine.LNX.4.64.0801201810400.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 20 2008 14:42, Patrick McHardy wrote:
>>> Index: iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
>>> ===================================================================
>>> --- iptables-modules.orig/include/linux/netfilter_ipv4/ipt_iprange.h
>>> +++ iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
>> Do we really want to keep this file?
>>
> If you value compatibilty, then yes.
> 
> (Did I understand that correctly?)

I thought the xt_iprange file included the old options, if thats
not the case then ignore my question.
