From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Fri, 12 Nov 2010 08:38:06 +0100
Message-ID: <4CDCEEDE.2090700@trash.net>
References: <20101111150055.GI15421@fi.muni.cz>	 <1289489728.17691.1331.camel@edumazet-laptop> <4CDC1263.8070206@trash.net>	 <20101111172511.GB20871@fi.muni.cz>	 <1289498295.17691.1589.camel@edumazet-laptop>	 <20101111180305.GD20871@fi.muni.cz> <1289499630.17691.1618.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kasprzak <kas@fi.muni.cz>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0KLHiF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:38:05 -0500
In-Reply-To: <1289499630.17691.1618.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.11.2010 19:20, Eric Dumazet wrote:
> Le jeudi 11 novembre 2010 =E0 19:03 +0100, Jan Kasprzak a =E9crit :
>> Eric Dumazet wrote:
>> : > 	There probably can be some other iptables commands running
>> : > occasionally (automatic blacklisting of some IP addresses, enabl=
ing
>> : > traffic to authenticated laptops, etc.), but not in the chains I=
 am
>> : > trying to modify with my firewall initscript. Can this also be a=
 problem?
>> :=20
>> : Yes it is a problem. iptables manipulates the whole table, not a
>> : subtree.
>>
>> 	So do you suggest I should implement some kind of user-space
>> locking, or is the current approach of "retry after 1 sec when it fa=
ils"
>> OK from the kernel point of view?
>=20
> You could implement a user-space locking, if the additional delay of =
the
> "retry after 1 sec" is bothering you ;)

Indeed, that's the best solution. The kernel can't really do anything
about this since incremental ruleset updates are a two-step process.
=46or dumps we've added retries a while ago, for updates this seems a b=
it
dangerous.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
