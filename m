From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq@rere.qmqm.pl>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 19:10:48 +0100
Message-ID: <20101111181048.GA18457@rere.qmqm.pl>
References: <20101111150055.GI15421@fi.muni.cz> <1289489728.17691.1331.camel@edumazet-laptop> <4CDC1263.8070206@trash.net> <20101111172511.GB20871@fi.muni.cz> <1289498295.17691.1589.camel@edumazet-laptop> <20101111180305.GD20871@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:56027 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0KKSKu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:10:50 -0500
Content-Disposition: inline
In-Reply-To: <20101111180305.GD20871@fi.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 11, 2010 at 07:03:05PM +0100, Jan Kasprzak wrote:
> Eric Dumazet wrote:
> : > 	There probably can be some other iptables commands running
> : > occasionally (automatic blacklisting of some IP addresses, enabli=
ng
> : > traffic to authenticated laptops, etc.), but not in the chains I =
am
> : > trying to modify with my firewall initscript. Can this also be a =
problem?
> : Yes it is a problem. iptables manipulates the whole table, not a
> : subtree.
> 	So do you suggest I should implement some kind of user-space
> locking, or is the current approach of "retry after 1 sec when it fai=
ls"
> OK from the kernel point of view?

You might be better off using ipset for dynamic rules.

Best Regards,
Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
