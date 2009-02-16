From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 18:13:23 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161804550.26651@fbirervta.pbzchgretzou.qr>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46285 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZBPRNZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:13:25 -0500
In-Reply-To: <499971CC.6040903@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-16 15:01, Pablo Neira Ayuso wrote:
>>>
>>> And the following commands to make all nodes see the same packets:
>>>
>>> ip maddr add 01:00:5e:00:01:01 dev eth1
>>> ip maddr add 01:00:5e:00:01:02 dev eth2
>>> arptables -I OUTPUT -o eth1 --h-length 6 \
>>>    -j mangle --mangle-mac-s 01:00:5e:00:01:01
>>> arptables -I INPUT -i eth1 --h-length 6 \
>>>    --destination-mac 01:00:5e:00:01:01 \
>>>    -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
>>
>> Mhh, is the saving of one or two characters really worth these
>> deviations from the kind-of established naming scheme? Its hard
>> to remember all these minor differences in my opinion.
>
> Hm, you mean the name "mangle" or the name of the option "--mangle-ma=
c-d"?

In case of --mangle-mac-d, getopt automatically handles
abbreviations (the best example I can think of where this works
is `quilt ref --s --d` for --sort --diffstat).

>> Unrelated to this patch, but maybe the target would also be
>> better named "NAT" instead of the much more generic term "mangle".
>> Why is it using lower case letters btw?
>
> No idea who has done this,

Lowercasing targets was the original author's (Bart De Schuymer's)
deed ;-)

I have nothing against lowercase targets, in fact, many a user seems
to so not get case-sensitity right=C2=A0=E2=80=94 =E2=80=9CINPUT=E2=80=9D=
 vs. =E2=80=9Cinput=E2=80=9D (built-in
chain names), =E2=80=9CMASQUERADE=E2=80=9D vs. =E2=80=9Cmasquerade=E2=80=
=9D (targets), to name some=C2=A0=E2=80=94
that I would support lowercasing all targets...=E2=80=94 if it were not=
 for
the clash between MARK (target) and mark (match), for example.
Though, calling one of them =E2=80=9Cmark_m=E2=80=9D or underscore-some=
thing to avoid
the clash however, is what I dislike in favor of uppercasing target
names.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
