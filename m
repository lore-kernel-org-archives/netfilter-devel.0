From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: install missing headers
Date: Tue, 24 Feb 2009 15:24:38 +0100
Message-ID: <49A40326.3000807@trash.net>
References: <alpine.LSU.2.00.0902210443180.32599@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33867 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbZBXOYl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:24:41 -0500
In-Reply-To: <alpine.LSU.2.00.0902210443180.32599@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I hope now I got it right!
> 
> ---8<---
> parent 5eebd6df9f3304f74b611fe47bab50fd3a1c668b (v2.6.29-rc4-30-g5eebd6d)
> commit 499c9627ecb75566801d96f0e91c9da356b6a8c8
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sat Feb 21 04:44:18 2009 +0100
> 
> netfilter: install missing headers
> 
> iptables imports headers from (the unifdefed headers of a)
> kernel tree, but some headers happened to not be installed.

Looks fine. Applied, thanks.
