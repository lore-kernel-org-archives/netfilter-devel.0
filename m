From: Patrick McHardy <kaber@trash.net>
Subject: Re: HTTP connection tracking
Date: Mon, 07 Jul 2008 16:20:51 +0200
Message-ID: <48722643.80608@trash.net>
References: <alpine.LNX.1.10.0807071547330.8248@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61891 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYGGOU4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:20:56 -0400
In-Reply-To: <alpine.LNX.1.10.0807071547330.8248@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> a user in irc came up with the following scenario:
> 
> - home router is connected to two ISPs with different IP addresses and 
>   does round-robin or some other form of packet scheduling.
> 
> - in such a setup, one generally uses MARK/CONNMARK to make sure that 
>   packets of a certain connection always leave through the same device 
>   through which the first packet was sent. (This is required to not 
>   break TCP connections.)
> 
> But how can we make sure that arbitrary connections which are defined as 
> related, can be sent through the same device? Think of a website which, 
> when the user is logged in, requires that all HTTP and HTTPS connections 
> that will be made by the user, must come from the same IP address.
 >
> Connection helpers seemed like a good idea at first, since expected 
> connections inherit the connmark value of the original connection. 
> However, once an expectation is set up, there is no way to set up 
> another right after one expectation has been confirmed.

Why not?
