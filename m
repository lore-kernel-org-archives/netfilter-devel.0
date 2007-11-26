From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Mon, 26 Nov 2007 16:35:54 +0100
Message-ID: <474AE7DA.9050302@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr> <474A7628.6050605@trash.net> <474A8F3B.8020209@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59533 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbXKZPgp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:36:45 -0500
In-Reply-To: <474A8F3B.8020209@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Amin Azez wrote:
> * Patrick McHardy wrote, On 26/11/07 07:30:
>
>> What advantages does this offer over using realms?
 >
>>From my point of view, the advantage is that you don't have to use realms.
> 
> Also, the match isn't REALLY strongly related to routing, which nexthop
> suggests, it's really a dest-mac match but where the mac address is
> resolved by IP each time from the neighbour table; so it's also useful
> against layer 3 bridges as well, where the bridge hardware is out of
> your control (may change) but it has the same IP address; e.g. some
> hotspots. Realms can't do that AFAIK;


Not sure I understand - if it has an IP, its not a bridge but a
router. If its visible to routing in any way, realms can be used.
