From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 9/27] Extend nf_inet_addr with in{,6}_addr
Date: Fri, 04 Jan 2008 15:49:29 +0100
Message-ID: <477E4779.8080806@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022127510.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48587 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbYADOwb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:52:31 -0500
In-Reply-To: <Pine.LNX.4.64.0801022127510.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 827c835ce662ee0e060b936ac4cb35a6b2e5c10a
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:54:52 2008 +0100
> 
>     [NETFILTER]: Extend nf_inet_addr with in{,6}_addr
>     
>     Extend union nf_inet_addr with struct in_addr and in6_addr. Useful
>     because a lot of in-kernel IPv4 and IPv6 functions use
>     in_addr/in6_addr.


Also applied, thanks. Perhaps a better way would be to consistently
only use one of both types (be32 or in_addr), but for now this
seems fine.
