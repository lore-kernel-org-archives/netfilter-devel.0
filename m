From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Tue, 15 Jan 2008 15:13:01 +0100
Message-ID: <478CBF6D.3060309@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40466 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYAOONM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:13:12 -0500
In-Reply-To: <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 15 2008 07:48, Patrick McHardy wrote:
>> This reminded me - while we're introducing new revisions, there
>> are two things that have always been missing from xt_conntrack
>> and I know of multiple patches adding this. One is port matching
>> for both directions, the other is matching on the direction
>> itself. Would you be interested in adding this? Otherwise I'm
>> going to take care of it myself.
>>
> 
> I will take care of that, yes.

Thanks.

> While matching the direction is probably a no-brainer (just checking
> a field), I would be interested in how "direction" is actually defined.
> Does the first packet in a NEW ct dictate the direction? What values
> does a direction have - north, south, left, right?
> I did not name "inbound" and "outbound" on purpose, because routers
> do not have an "in" or "out" side like most consumer desktop boxes.


In case of xt_conntrack the directions are relative to the first
packet of the connection, as with orig-src, repl-src, ...

