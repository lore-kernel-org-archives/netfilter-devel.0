From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCHv4 0/2] Find address type on the packet's interface
Date: Tue, 20 Nov 2007 11:54:41 +0100
Message-ID: <4742BCF1.1050303@balabit.hu>
References: <11954877483732-git-send-email-panther@balabit.hu> <4741B47A.40106@trash.net> <Pine.LNX.4.64.0711191756550.32378@fbirervta.pbzchgretzou.qr> <4741C3EC.3050500@trash.net>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:51361 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbXKTKyq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:54:46 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 464BFC1456
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2007 11:54:44 +0100 (CET)
In-Reply-To: <4741C3EC.3050500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy =EDrta:
> Jan Engelhardt wrote:
>> On Nov 19 2007 17:06, Patrick McHardy wrote:
>>> I just read up on your and Jan's discussion, but you were too fast
>>> for me :) I'm not sure whether this is really a good candidate
>>> for x_tables. IPv4 and IPv6 addrtype have different meanings, the
>>> IPv4 addrtype is based on routing, IPv6 solely on the address.
>>> Especially things like "--addrtype local" won't work, which is
>>> IMO the most useful feature. And since you don't actually add IPv6
>>> support, I don't see any advantage in moving to x_tables. So I
>>> think for now I'd prefer a change to the ipt_addrtype match.
>>
>> IMHO it does not make any difference whether it is xt_*.c or ipt_*.c=
,
>> the cost is quite the same.
>> I am all for xt_*.c, because that's the "new shiny" thing.
>=20
> x_tables is meant for unified matches and targets, as long as theres
> nothing to unify, there's no point in moving it over. So far I think
> we only have a single xtables match that doesn't support both IPv4
> and IPv6 (xt_conntrack), and I'd like to keep it that way.
>=20
>=20

I think x_tables is meant for similar functionality for IPv4 and IPv6=20
with minor differences. This eliminates possible code duplications, but=
=20
the exactly same usage from the user's view is not required.

--=20
Attila

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
