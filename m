From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Thu, 24 Jan 2008 09:05:14 +0100
Message-ID: <479846BA.6050308@trash.net>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>  <47934659.50303@trash.net>  <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>  <479349D3.6050103@trash.net>  <1200839199.2868.25.camel@localhost.localdomain>  <47935E7A.1000908@trash.net>  <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr> <1200852441.2894.30.camel@localhost.localdomain> <Pine.LNX.4.64.0801201909160.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYAXIGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 03:06:07 -0500
In-Reply-To: <Pine.LNX.4.64.0801201909160.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 20 2008 19:07, Bart De Schuymer wrote:
>> Op zo, 20-01-2008 te 18:34 +0100, schreef Jan Engelhardt:
>>> "Ugh." I do not think ebtables(8) should depend on such macros.
>>> iptables(8) does not do that either.
>>> What good would those macros be for? It is not like the module names
>>> would be changing anyway (one purpose of macros - to reduce the number
>>> of places where you have to change things iff things change).
>> We are talking about EBT_ENTRY_ITERATE and the like, right?
>> I didn't see your patch, but even the kernel code uses the ITERATE
>> macros more than once.
>>
> No, just the name macros:
> 
> 
> (shortened)
> diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
> index a11b0c2..11421ca 100644
> --- a/include/linux/netfilter_bridge/ebt_802_3.h
> +++ b/include/linux/netfilter_bridge/ebt_802_3.h
> @@ -4,8 +4,6 @@
>  #define EBT_802_3_SAP 0x01
>  #define EBT_802_3_TYPE 0x02
>  
> -#define EBT_802_3_MATCH "802_3"


I've folded the ebtables MODULES_DESCRIPTION part without
this change and the {ip,ip6,x}_tables parts into your
first patch to update the descriptions. Frankly, I don't
care much about packet vs. Packet, but if you want to
change the other descriptions again, please send that
part seperately.
