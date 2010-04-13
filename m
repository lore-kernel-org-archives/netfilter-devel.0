From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 5/6] netfilter: xt_TEE: have cloned packet travel
 through Xtables too
Date: Tue, 13 Apr 2010 14:38:57 +0200
Message-ID: <1271162337.16881.296.camel@edumazet-laptop>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de>
	 <1270666217-27670-6-git-send-email-jengelh@medozas.de>
	 <4BC440D0.9020500@trash.net>
	 <alpine.LSU.2.01.1004131250220.11306@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35467 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0DMMjF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:39:05 -0400
Received: by bwz19 with SMTP id 19so3687bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 05:39:03 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1004131250220.11306@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 13 avril 2010 =C3=A0 12:51 +0200, Jan Engelhardt a =C3=A9crit =
:
> On Tuesday 2010-04-13 12:00, Patrick McHardy wrote:
> >Jan Engelhardt wrote:
> >> --- a/net/netfilter/xt_TEE.c
> >> +++ b/net/netfilter/xt_TEE.c
> >> @@ -33,6 +33,7 @@ static struct nf_conn tee_track;
> >>  #endif
> >> =20
> >>  static const union nf_inet_addr tee_zero_address;
> >> +static bool tee_active[NR_CPUS];
> >
> >DEFINE_PER_CPU?
>=20
> I asked about that. It seems like percpu.h puts the variable in an ex=
tra=20
> section and with pretty much #define magic around it (e.g. look at th=
e=20
> #definition of percpu_set) all of which did not seem necessary to me.

You must be kidding ;)

percpu access is pretty fast these days, thanks to latest work from
Tejun Heo

On x86, this is one segment override, exactly one byte, to read/write o=
n
a percpu variable. Please try it :)




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
