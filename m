From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Possible iptables 4.4.11 issues
Date: Tue, 31 May 2011 11:53:26 +0200
Message-ID: <4DE4BA96.3070603@netfilter.org>
References: <4DE2593E.7000208@shorewall.net>	<alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>	<4DE4B7EE.9060107@netfilter.org> <BANLkTikKCG1O3MPY66J1omnOQF+QPf-NJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Tom Eastep <teastep@shorewall.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Steven Jan Springl <steven@springl.ukfsn.org>
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1EaJxh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 05:53:37 -0400
In-Reply-To: <BANLkTikKCG1O3MPY66J1omnOQF+QPf-NJw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/05/11 11:51, Maciej =C5=BBenczykowski wrote:
>>>> -A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
>>>> dst --and-mask -1 --or-mask -64 --shift 0
>>>> After upgrading to iptables 1.4.11 the following iptables-restore =
error is
>>>> produced:
>>>>
>>>> iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option:=
 "-1"
>>>
>>> This is intentional. Bitwise operations work best when fed unsigned=
 numbers
>>> only.
>>
>> but this used to work, we shouldn't break this sort of things Jan.
>=20
> Assuming 2's complement arithmetic, an --and-mask of -1 should be a n=
o-op
> (since -1 is all 1's in binary)
>=20
> However when reading --and-mask -1 my first gut instinct is that this
> is --and-mask ~1 and is thus clears the least significant bit.
> I also instinctively incorrectly assume --or-mask -64 sets all but bi=
t
> 6, when it is actually setting all but the bottom 6 bits (ie. bits 0
> through 5)...
>=20
> To me this sort of lack of clarity is undesirable, and I can certainl=
y
> understand the desire to disable masks with negative integers.

makes sense, thanks for the clarification.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
