From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [16/19] libxt_iprange r0
Date: Sun, 20 Jan 2008 18:13:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201810400.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801161453070.4953@fbirervta.pbzchgretzou.qr> <47934FB9.20203@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39867 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYATRNl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:13:41 -0500
In-Reply-To: <47934FB9.20203@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 14:42, Patrick McHardy wrote:
>> Index: iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
>> ===================================================================
>> --- iptables-modules.orig/include/linux/netfilter_ipv4/ipt_iprange.h
>> +++ iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
>
> Do we really want to keep this file?
>
If you value compatibilty, then yes.

(Did I understand that correctly?)

