From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 11:46:48 +0200
Message-ID: <471F1488.3000200@plouf.fr.eu.org>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0597.4030203@plouf.fr.eu.org> <471F0D18.1030606@snapgear.com> <471F0ED1.202@plouf.fr.eu.org> <471F12DC.8050508@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <471F12DC.8050508@snapgear.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Philip Craig a =E9crit :
> Pascal Hambourg wrote:
>=20
>>Sure, but what about packets that enter a bridged interface and then =
are=20
>>routed ?
>=20
> It's not set for them either, they are still just routed packets.
> Not sure I understand your question.  My original comment was that
> because the packets are routed (even though they arrived on a bridge)=
,
> the bridged flag is not set, and so the --physdev-is-bridged option
> would never match for that particular rule, and it simply isn't
> possible to fix that rule to get the --physdev-out to work.

I misunderstood your original comment. I thought you meant that=20
--physdev-is-bridged would not help distinguish between routed and=20
bridged packets when the input and output interfaces are bridges. Thank=
s=20
for taking the time to clarify.
