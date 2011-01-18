From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Tue, 18 Jan 2011 19:37:55 +0100
Message-ID: <1295375875.3290.38.camel@edumazet-laptop>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
	 <4D35BCC7.90805@trash.net>
	 <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65209 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1ARSiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:38:07 -0500
Received: by wyb28 with SMTP id 28so6435964wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jan 2011 10:38:05 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 18 janvier 2011 =C3=A0 19:21 +0100, Jan Engelhardt a =C3=A9cri=
t :
> On Tuesday 2011-01-18 17:16, Patrick McHardy wrote:
> >On 18.01.2011 16:38, Jan Engelhardt wrote:
> >> http://bugzilla.netfilter.org/show_bug.cgi?id=3D694 [...] While I
> >> have to question why users are relying on inferior filesystems
> >> (the issue was raised before on the lists), I feel inclined to
> >> solve bugs. So here is a proposed patchset that starts the
> >> migration. [...]
> >
> >I don't want to apply this. Feel free to try to convince other=20
> >netfilter developers that this is a good idea and I'll pull it in, b=
ut=20
> >so far this looks like useless noise to me.
> >
> >[...] I don't see any benefit in causing so much churn just for one*=
=20
> >*user, who has been feeling unhappy about his scripts not working=20
> >properly.
>=20
> I'll try to add to my case then; The dependency on case-sensitivity i=
s a=20
> long-known issue, so much that in fact, Bart avoided doing this again=
 as=20
> early as ebtables's inception around 2002.


Why not renaming only clashing files, and make sure future files are
lowercase only ?




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
