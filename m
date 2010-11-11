From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 19:20:30 +0100
Message-ID: <1289499630.17691.1618.camel@edumazet-laptop>
References: <20101111150055.GI15421@fi.muni.cz>
	 <1289489728.17691.1331.camel@edumazet-laptop> <4CDC1263.8070206@trash.net>
	 <20101111172511.GB20871@fi.muni.cz>
	 <1289498295.17691.1589.camel@edumazet-laptop>
	 <20101111180305.GD20871@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58000 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0KKSUe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:20:34 -0500
Received: by wyb28 with SMTP id 28so981263wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Nov 2010 10:20:33 -0800 (PST)
In-Reply-To: <20101111180305.GD20871@fi.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 11 novembre 2010 =C3=A0 19:03 +0100, Jan Kasprzak a =C3=A9crit=
 :
> Eric Dumazet wrote:
> : > 	There probably can be some other iptables commands running
> : > occasionally (automatic blacklisting of some IP addresses, enabli=
ng
> : > traffic to authenticated laptops, etc.), but not in the chains I =
am
> : > trying to modify with my firewall initscript. Can this also be a =
problem?
> :=20
> : Yes it is a problem. iptables manipulates the whole table, not a
> : subtree.
>=20
> 	So do you suggest I should implement some kind of user-space
> locking, or is the current approach of "retry after 1 sec when it fai=
ls"
> OK from the kernel point of view?

You could implement a user-space locking, if the additional delay of th=
e
"retry after 1 sec" is bothering you ;)




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
