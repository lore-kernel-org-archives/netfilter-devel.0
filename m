From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Sun, 20 Jan 2008 14:12:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201410320.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
 <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
 <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
 <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
 <479345F0.8000009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38953 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYATNMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:12:10 -0500
In-Reply-To: <479345F0.8000009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 14:00, Patrick McHardy wrote:
>
> Another nitpick: we support masks for the addresses, ranges of ports
> would be nice to have here as well.

Well well why don't we just add address ranges too then :p
Do we need it so badly?

> I also don't think the protocol
> check is very useful in this case since all conntrack entries contain
> port numbers or something similar.

Is IPv4-in-IPv4 or IPv6-in-IPv4 conntracked like UDP is?

The protocol check is important though, because IPPROTO_GRE is
_not_ included, since, it's not something that has a port.
