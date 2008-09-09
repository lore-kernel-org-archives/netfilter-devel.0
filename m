From: Patrick McHardy <kaber@trash.net>
Subject: Re: rfc: DROP returns error
Date: Tue, 09 Sep 2008 08:27:04 +0200
Message-ID: <48C61738.8040903@trash.net>
References: <alpine.LNX.1.10.0809061338180.20668@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63043 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbYIIG1H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:27:07 -0400
In-Reply-To: <alpine.LNX.1.10.0809061338180.20668@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Time and again I notice users complaining about DROP returning an error 
> when used in the OUTPUT chain:
> 
> root@nuqneh:~# iptables -A OUTPUT -o lo -p icmp -j DROP
> root@nuqneh:~# ping -c1 localhost
> PING localhost (127.0.0.1) 56(84) bytes of data.
> ping: sendmsg: Operation not permitted
> --- localhost ping statistics ---
> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
> 
> I am wondering whether we should either add a new verdict to
> accomodate for this, or do the following:

I've been thinking about this myself. EPERM for packets dropped by
an explicit DROP seems fine in general. There are other cases where
this is not correct though, for example when rerouting in mangle
and we don't have a route anymore.

I think what we should do instead of adding new verdicts is something
similar to how NF_QUEUE works, encode the error code in the upper 16
bits and return it from nf_hook_slow.
