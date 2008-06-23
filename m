From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] 1.3.6 and newer disallows IP ADDRESS argument
 to	REDIRECT
Date: Mon, 23 Jun 2008 18:21:51 +0200
Message-ID: <485FCD9F.8010102@trash.net>
References: <062320081433.10930.485FB42B0002149300002AB22209224627020A9A9E0C030A050703@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: mikemcquen@comcast.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55390 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYFWQV4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:21:56 -0400
In-Reply-To: <062320081433.10930.485FB42B0002149300002AB22209224627020A9A9E0C030A050703@comcast.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please post questions like this to netfilter-devel.

mikemcquen@comcast.net wrote:
> why?
> There is no longer a mechanism for doing this:
> 
> iptables -t -nat -A PREROUTING -i  eth0 -p tcp -m tcp --dport 443 -j REDIRECT --to 1.1.1.1
> 
> I just replaced a bunch of proxy machines and my config no longer works!

This was never supported, REDIRECT always choses the
first IP from the incoming device.

My guess is that you either used DNAT before or the
argument parser used to be less strict and ignored
unknown arguments.
