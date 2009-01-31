From: Eric Leblond <eric@inl.fr>
Subject: Re: crash in nfnetlink_queue
Date: Sat, 31 Jan 2009 22:29:31 +0100
Message-ID: <4984C2BB.3030501@inl.fr>
References: <92770c820901311319q2a35ca0fnd42112ab9b3db6fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: ilninno <ilninno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:44653 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZAaV3f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:29:35 -0500
In-Reply-To: <92770c820901311319q2a35ca0fnd42112ab9b3db6fe@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Could you specify your kernel version ?

By the way please use a explicit subject when posting: lot of people
avoir to read 'I need help' messages.

BR,

ilninno a =E9crit :
> Hello again.
>=20
>=20
> I tested the issue in different examples:
>=20
> 1- When using NF_REPEAT with only 1 queue, there isnt any problem
>    $IPTABLES -A OUTPUT -m state --state NEW -m mark ! --mark 1 -j NF_=
QUEUE 0
>    $IPTABLES -A OUTPUT -j ACCEPT
>=20
> 2- When using NF_REPEAT with (program 1 in queue 0 and program 2 in q=
ueue 1)
>=20
>                 $IPTABLES -A OUTPUT -m state --state NEW -m mark !
> --mark 1 -j NF_QUEUE 0
>                 $IPTABLES -A OUTPUT -m state --state NEW -m mark
> --mark 1 -j NF_QUEUE 1
>=20
> then i got kernel panic. I think the problem is that using
> nfq_set_verdict_mark(myQueue, id, NF_REPEAT, htonl(1) ,0, NULL)  don'=
t
> modify packet length and kernel freezes, but im not sure, im newbie
> please help me.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
