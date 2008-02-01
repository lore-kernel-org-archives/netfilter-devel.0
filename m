From: Patrick McHardy <kaber@trash.net>
Subject: Re: [00/!@#%] patches patches!
Date: Fri, 01 Feb 2008 11:05:46 +0100
Message-ID: <47A2EEFA.9060906@trash.net>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43156 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbYBAKFw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:05:52 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi :)
> 
> 
> to make this evening still interesting, I have:
> 
> - 13 kernel patches, as replies to this thread.
> 
>   The way it looks from a quick grep is that all non-IPv4/v6-centric 
>   matches are now IPv6 capable - yay!
> 
> - 9 iptables patches, as replies to this thread.
>   making way for a final tarball (I think it's time)
> 
> All previously posted patches are hereby obsoleted.


Great :) Dave declared that only non-features should be merged
from now on. The constifying is no big deal I guess, but could
you combine all of these in one big patch please? The remaining
fixes are obviously fine, also the patches fixing non-released
features. Everything else will have to wait for 2.6.26, but I
can queue it for you.


