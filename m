From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] xt_tos match
Date: Mon, 19 Nov 2007 12:39:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711191238180.3501@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
 <47416766.6090209@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42817 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXKSLjm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 06:39:42 -0500
In-Reply-To: <47416766.6090209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 19 2007 11:37, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Posted for review and checkup.
>> 
>> Index: net-2.6.25/include/linux/netfilter_ipv4/Kbuild
>> ===================================================================
>> --- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
>> +++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
>> @@ -40,7 +40,6 @@ header-y += ipt_sctp.h
>>  header-y += ipt_state.h
>>  header-y += ipt_string.h
>>  header-y += ipt_tcpmss.h
>> -header-y += ipt_tos.h
>
> We still need that file, no?

I am not sure, but I think yes it may need to stick a little longer
if you are about to build old iptables.
(I have yet to submit libxt_tos, doh!)
