From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 9/27] Extend nf_inet_addr with in{,6}_addr
Date: Fri, 4 Jan 2008 16:01:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041553390.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022127510.14900@fbirervta.pbzchgretzou.qr>
 <477E4779.8080806@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYADPBh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:01:37 -0500
In-Reply-To: <477E4779.8080806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 15:49, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 827c835ce662ee0e060b936ac4cb35a6b2e5c10a
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 17:54:52 2008 +0100
>> 
>>     [NETFILTER]: Extend nf_inet_addr with in{,6}_addr
>>     
>>     Extend union nf_inet_addr with struct in_addr and in6_addr. Useful
>>     because a lot of in-kernel IPv4 and IPv6 functions use
>>     in_addr/in6_addr.
>
> Also applied, thanks. Perhaps a better way would be to consistently
> only use one of both types (be32 or in_addr), but for now this
> seems fine.
>
It is because of userspace -- it uses in_addr in so many
functions, extending the union seemed like the best thing
to avoid tons of casting or compile warnings.
