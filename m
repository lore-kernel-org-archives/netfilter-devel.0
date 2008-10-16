From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arptables and the generic xtables issues
Date: Thu, 16 Oct 2008 13:19:23 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810161300210.31082@fbirervta.pbzchgretzou.qr>
References: <48F69C2A.8010001@netfilter.org> <alpine.LNX.1.10.0810152151070.28060@fbirervta.pbzchgretzou.qr> <48F7405A.2050302@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49132 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYJPRTZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:19:25 -0400
In-Reply-To: <48F7405A.2050302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-16 09:23, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Wednesday 2008-10-15 21:43, Pablo Neira Ayuso wrote:
>> > Currently, we have tagged quite a lot of targets and matches with
>> > AF_UNSPEC as they are generic for the netfilter supported protocol=
s.
>> > This is fine if we only think of ebtables, iptables and ip6tables =
but
>> > not for arptables, I doubt that all those target and matches can w=
ork
>> > with arptables - even if we still need the userspace support, of c=
ourse.
>> >
>> > I think that we should fix those, right?
>>=20
>> That would be a tremendous amount of work, given that arptables (and
>> ebtables too) is not quite the same codebase as iptables anymore.
>> Most of the iptables development just went by arp and ebtables due
>> to the nature of all these semiforks.
>>=20
>> I think we should rather focus on a truly family-independent table
>> in the very near future. In fact I have ideas floating around that,
>> but am stuck with how I'd exactly funnel it into reviewable patch
>> chunks.
>
> I think we should finish the unification/resyncing efforts before

Yesyesyes, but I think we reached a point where the next step in
Improving It=E2=84=A2 requires a big lockstep change with userspace OR
adding a new interface, just because of the "keeping compat" fun.

> adding new features in this area. There's still *a lot* of old
> cruft that could probably be removed.

Modules ripe for removal is just the smaller piece.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
