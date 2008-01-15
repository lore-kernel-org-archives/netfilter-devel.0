From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Tue, 15 Jan 2008 13:31:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35403 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYAOMbi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:31:38 -0500
In-Reply-To: <478C573D.2060401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 15 2008 07:48, Patrick McHardy wrote:
>
> This reminded me - while we're introducing new revisions, there
> are two things that have always been missing from xt_conntrack
> and I know of multiple patches adding this. One is port matching
> for both directions, the other is matching on the direction
> itself. Would you be interested in adding this? Otherwise I'm
> going to take care of it myself.
>

I will take care of that, yes.

While matching the direction is probably a no-brainer (just checking
a field), I would be interested in how "direction" is actually defined.
Does the first packet in a NEW ct dictate the direction? What values
does a direction have - north, south, left, right?
I did not name "inbound" and "outbound" on purpose, because routers
do not have an "in" or "out" side like most consumer desktop boxes.
