From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 10:43:03 +0200
Message-ID: <471F0597.4030203@plouf.fr.eu.org>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <471F03B1.3090909@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy a =E9crit :
> Philip Craig wrote:
>=20
>> Patrick McHardy wrote:
>>
>>>> $IPTABLES -A FORWARD -i $BR_GUEST -o $BR_INT -m physdev=20
>>>> --physdev-out $IF_DMZ -p tcp --dport 3389 -j ACCEPT
>>>
>>> Try adding "--physdev-is-bridged" to your rules. Without that the k=
ernel
>>> is not able to tell whether they apply only to bridged packets or a=
lso
>>> to forwarded or locally generated ones.
>>
>> That won't work for the above rule, for example, since the packet is
>> being forwarded between two different bridges, so it is not bridged.

Do you mean that the "bridged" flag (or whatever way this is=20
implemented) is not reset when the packet is routed ? Doesn't this soun=
d=20
like a bug ?

> I see nothing indicating that it is being forwarded

"-A FORWARD -i $BR_GUEST -o $BR_INT"
