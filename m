From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables branch management
Date: Fri, 9 Sep 2011 13:07:02 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109091259340.4149@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr>  <20110905175425.GC32733@1984> <4E68935B.3000401@trash.net>  <alpine.LNX.2.01.1109081243320.11934@frira.zrqbmnf.qr>  <4E68BAA8.5010501@trash.net>  <alpine.LNX.2.01.1109081610030.6362@frira.zrqbmnf.qr>
 <1315560705.10959.3.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46949 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307Ab1IILHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:07:05 -0400
In-Reply-To: <1315560705.10959.3.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-09-09 11:31, Peter Volkov wrote:

>=D0=92 =D0=A7=D1=82=D0=B2, 08/09/2011 =D0=B2 16:41 +0200, Jan Engelhar=
dt =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Oh we are nicely accumulating fixes & trivials already - do not worr=
y=20
>> about that. Just let me pull this off, all it means is that
>> there is another branch head on iptables.git, and something convenie=
nt=20
>> for the release manager to tag should the need arise for a .y releas=
e.=20
>> Users already seem to like the idea[1].
>> [1] http://marc.info/?l=3Dnetfilter-devel&m=3D131499886708085&w=3D2
>
>As the iptables maintainer in Gentoo I really appreciate such branch
>management. BTW, I'd like to know how long stable branch will be
>maintained? Or IOW how we'll find out that it's not maintained any mor=
e?

=46rom my point of understanding: like we always have done, in other=20
words:

All release numbers are strictly monotonically increasing. The=20
appearance of a iptables-1.4.13 will close any iptables-1.4.12.x.

[ This is, if you have not noticed, the same way the Linux kernel is=20
done. Once linux-3.1 appears, the linux-3.0.x line usually ceases. ]
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
