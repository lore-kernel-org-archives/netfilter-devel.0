From: Amin Azez <azez@ufomechanic.net>
Subject: Re: xt_gateway locks up
Date: Fri, 26 Oct 2007 14:48:21 +0100
Message-ID: <4721F025.50507@ufomechanic.net>
References: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:54253 "EHLO
	server1.secure-linux-server.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349AbXJZNs1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:48:27 -0400
In-Reply-To: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Jan Engelhardt wrote, On 21/10/07 23:14:
> Hi Sam,
> 
> 
> just for the fun of it, I tried:
> 
> 	iptables -t mangle -A PREROUTING -m gateway --nexthop 10.10.96.1
> 
> and it locked up hard (not even sysrq-b was possible).
> I am not sure why that happened - it does work properly in -t filter -A 
> OUTPUT, though. I'll experiment a bit.
> The codebase I am on is at 
> http://dev.computergmbh.de/wsvn/misc_kernel/xt_gateway/


Thanks for reporting this.
Is it a regular lock up or just a one off?

I would think it doesn't make sense to use it in pre-routing as no
gateway will be set.

Sam


