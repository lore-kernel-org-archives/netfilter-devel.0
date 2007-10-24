From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 16:11:25 +0200
Message-ID: <471F528D.8000501@plouf.fr.eu.org>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0AD5.2050202@snapgear.com> <471F136D.6090907@trash.net> <20071024120622.GB27593@volker-sauer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20071024120622.GB27593@volker-sauer.de>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Volker Sauer a =E9crit :
>=20
> In case someone is using physdev in OUTPUT, display the message like =
it
> is now: "using --physdev-out in the OUTPUT chains for non-bridged tra=
ffic
> is not supported anymore".

Ok.

> In case it is used inside FORWARD, check if all physdev interfaces ar=
e
> members of the same bridge.

As Patrick said, that condition may change over time. I like to have al=
l=20
my ruleset loaded before the network is configured, even before some=20
interfaces exist. Your proposed change would prevent it. Besides, my=20
opinion is that it is not the job of iptables to do such checks.

> If yes, accept the rule, because then it is
> allowed to use it!!!  (Which is the case all the thousands of rules i=
n
> my firewalls except the 5 that I sent to this list :-().
> If no, display a message like this:
>=20
> "physdev match: using --physdev-out in the FORWARD chains is only=20
> allowed if all physical interfaces are members of the same bridge."

This is wrong and inacurate. Using --physdev-out in the FORWARD and=20
POSTROUTING chains is supported for *bridged* traffic only, period. All=
=20
physical interfaces being members of the same bridge is not a sufficien=
t=20
condition to make sure that only bridged traffic will be matched.=20
Traffic can still be routed from a bridge to itself.
