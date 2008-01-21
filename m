From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Mon, 21 Jan 2008 02:31:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801210225350.22430@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
 <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
 <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
 <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
 <479345F0.8000009@trash.net> <4793F1F0.2080403@netfilter.org>
 <Pine.LNX.4.64.0801210215100.22430@fbirervta.pbzchgretzou.qr>
 <4793F2FD.7040500@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59072 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbYAUBbd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:31:33 -0500
In-Reply-To: <4793F2FD.7040500@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 21 2008 02:18, Pablo Neira Ayuso wrote:
>> 
>> And what's xt_VOLATILE do? (Was it hidden in your recent
>> xt_CONNTRACK submission?)
>
>Indeed. Just set the IPCT_VOLATILE flag to tell ctnetlink to skip that
>event. It would be a very simple target. I don't know if VOLATILE would
>be a nice name, perhaps CTNETLINK.

Oh I would not mind names all that much.
At the basic level, there is ACCEPT DROP and REJECT.
Then, in the depths of POM-nation there is TARPIT and TEE, (I'm missing COFFEE).
Elsewhere, I wrote CHAOS and DELUDE.
Most recently, I sampled up STEAL.
You see, VOLATILE is not so off after all. :-)
