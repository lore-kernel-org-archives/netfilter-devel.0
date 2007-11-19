From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] xt_owner match
Date: Mon, 19 Nov 2007 18:10:24 +0100
Message-ID: <4741C380.1090409@trash.net>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711161400360.3340@fbirervta.pbzchgretzou.qr> <4741AF25.5080604@trash.net> <Pine.LNX.4.64.0711191751580.32378@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38464 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbXKSRKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:10:48 -0500
In-Reply-To: <Pine.LNX.4.64.0711191751580.32378@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 19 2007 16:43, Patrick McHardy wrote:
>
>>> +	filp = skb->sk->sk_socket->file;
>>> +	if (filp == NULL)
>>> +		return false;
>> What would be nice is to allow matching whether a socket exists,
>> without UID/GID. I had a patch for this for a long time, but
>> lost it somewhere.
> 
> Do you mean xt_socket from TPROXY?


Well, xt_socket does a lookup. What my patch did was allow matching
on the existance of a socket related to that packet (simply:
iptables ... -m owner -j .... Your patch actually already allows that,
but doesn't allow inversion for this. But now that you mention it,
I did use it for incoming packets combined with a socket lookup,
its probably not that useful for outgoing packets. It would only
require a single new flag to properly support this though.


