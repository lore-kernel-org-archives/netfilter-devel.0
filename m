From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Add xt_tos
Date: Sat, 20 Oct 2007 17:38:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201736260.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr>
 <471A1DD6.6010103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53966 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbXJTPia (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:38:30 -0400
In-Reply-To: <471A1DD6.6010103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 20 2007 17:25, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Convert ipt_tos to xt_tos, adding support for IPv6.
>>
>> +MODULE_ALIAS("ipt_tos");
>> +MODULE_ALIAS("ip6t_tos");
>
> Looks good, but I think this breaks bisection since you remove ipt_tos
> in a later patch. I'll fold those together and queue it up for 2.6.25.
> Thanks Jan.
>
Someone please test it :)
I do not think it breaks compilation bisection.

The only thing I am worried about is iptables, because that needs
to move from ipt_tos.h to xt_tos.h and I am not sure how that is
going to fly unless the following requirement is put up:

	linux <= 2.6.24 : iptables <= 1.4.0
	linux >= 2.6.25 : iptables >= 1.4.1

i.e. a flag day for both projects.
