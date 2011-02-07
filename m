From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 A7 spec draft
Date: Mon, 7 Feb 2011 22:45:32 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102072226190.27979@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr> <AANLkTinaXkiL2HidUPSVnGyi-y4ZgqQxCB-uGDxdVYb_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: James Nurmi <jdnurmi@qwe.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39476 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab1BGVpd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:45:33 -0500
In-Reply-To: <AANLkTinaXkiL2HidUPSVnGyi-y4ZgqQxCB-uGDxdVYb_@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-02-07 21:50, James Nurmi wrote:

>> +--------+-------------------+---------------+-----------------+----=
----------------------------------+
>> | =C2=A0 =C2=A0 =C2=A0 =C2=A0| NFXTA_ERRSTR =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 char [] =C2=A0 =C2=A0 | NLA_NUL_STRING =C2=A0| Arbitrary =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|
>> +--------+-------------------+---------------+-----------------+----=
----------------------------------+
>
>W/r/t the NUL_STRING's -- is there a good reason to use a NUL'd
>strings for NAME/etc, given the length is known?

Simpler to deal with string functions especially when it comes to strcm=
p.


>> 5 Message types
>> ...
>
>My biggest concern here seems as already pointed out -- the use of
>STOP && deep nesting in messages;  Every time a STOP occurs in an
>internal message, it's semantically equivalent to the completion of an
>NF_F_MULTI no?

MULTIs do not seem to be nestable.

>I see the advantage of a trivial protocol, but wouldn't it be much
>simpler to have a 'bigger' protocol (table/chain/rule) with an
>optional ATOMIC guarantee?

I have no idea what you could mean by that. (In fact, most of
your reply gave me nothing to act on.)

>I don't see anywhere else guaranteeing tables/matches/rules will be
>managed (as a set) with atomicity [I'm probably wrong], so doing it in
>the protocol feels awkward.

By issuing NFXTM_TABLE_REPLACE (atomic replace of table) or
NFXTM_CHAIN_SPLICE (atomic replace of a chain and its rules), rules
that follow are collected and implanted into the live ruleset on the
final NFXTM_STOP. And these two cover all the atomicity one would
need as I see it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
