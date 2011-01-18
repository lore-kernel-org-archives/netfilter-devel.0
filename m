From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Tue, 18 Jan 2011 19:21:03 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr> <4D35BCC7.90805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51609 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1ARSVE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:21:04 -0500
In-Reply-To: <4D35BCC7.90805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-01-18 17:16, Patrick McHardy wrote:
>On 18.01.2011 16:38, Jan Engelhardt wrote:
>> http://bugzilla.netfilter.org/show_bug.cgi?id=3D694 [...] While I
>> have to question why users are relying on inferior filesystems
>> (the issue was raised before on the lists), I feel inclined to
>> solve bugs. So here is a proposed patchset that starts the
>> migration. [...]
>
>I don't want to apply this. Feel free to try to convince other=20
>netfilter developers that this is a good idea and I'll pull it in, but=
=20
>so far this looks like useless noise to me.
>
>[...] I don't see any benefit in causing so much churn just for one*=20
>*user, who has been feeling unhappy about his scripts not working=20
>properly.

I'll try to add to my case then; The dependency on case-sensitivity is =
a=20
long-known issue, so much that in fact, Bart avoided doing this again a=
s=20
early as ebtables's inception around 2002.

I am pretty sure there was more than just this one 2011 user=C2=A0-- ne=
edless=20
to say you have to count me in --, and that there was discussion [durin=
g=20
my time 2007 onwards]. Google fails me on finding that, though I dug up=
=20
another report from 2004: http://lkml.org/lkml/2004/10/17/147

At that time Harald argued "iptables fundamentally relies on the=20
destinction", though that does not apply today thanks to module aliases=
=2E

As a resident contributor, I stand behind the changes. In the unlikely=20
even that it breaks, I see it as duty to fix it. The churn is on me=20
already practically.

Assistance is offered to users who do run into including, but not=20
limited to, such issues. The IRC channel is lively again, open reports=20
in various bugzilla trackers are actively being inspected for non-distr=
o=20
faults and resolved. The overall user experience, IMHO, has greatly=20
improved since iptables 1.3.8, and I would like to continue on working=20
on it. I am sure something can be devised if your time does not permit=20
patch handling.

=3D=3D

Anticipating pending patches from others (specifically xt_nfqueue rev=C2=
=A02=20
from Florian), git-merge is likely needed to cope with the renames, whe=
n=20
applying others' patch files.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
