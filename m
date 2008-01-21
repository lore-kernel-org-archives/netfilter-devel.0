From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Mon, 21 Jan 2008 02:15:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801210215100.22430@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
 <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
 <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
 <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
 <479345F0.8000009@trash.net> <4793F1F0.2080403@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49560 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbYAUBPp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:15:45 -0500
In-Reply-To: <4793F1F0.2080403@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 21 2008 02:14, Pablo Neira Ayuso wrote:
>
>BTW, it would be great if we add support for layer 4 protocol state
>matching, e.g. match TCP established. We can use this together with the
>target that would mark certain events as volatile, e.g.
>
>iptables -A 192.168.0.0/24 -m conntrack ! --tcp-state ESTABLISHED -j
>VOLATILE

And what's xt_VOLATILE do? (Was it hidden in your recent
xt_CONNTRACK submission?)

>The idea behind this it that ctnetlink would ignore certain events,
>thus, reducing CPU load.
