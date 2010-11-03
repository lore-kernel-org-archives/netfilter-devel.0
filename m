From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 3 Nov 2010 11:51:06 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011031148220.678@obet.zrqbmnf.qr>
References: <20101102.135254.226783976.davem@davemloft.net> <4CD12B8B.9090506@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50779 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab0KCKvI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:51:08 -0400
In-Reply-To: <4CD12B8B.9090506@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-11-03 10:29, Pascal Hambourg wrote:

>Hello,
>
>David Miller a =C3=A9crit :
>> H. Peter Anvin just mentioned something interesting to me,
>> basically it's the fact that when your prefix addresses
>> change on an interface in ipv6, this can invalidate your
>> netfilter rules.
>>=20
>> So it would be nice if there were some way to match "the
>> ipv6 prefix address on interface X",

"The prefix addr no.5 on X" <=3D>  -i X -d 2001:db8::/64

Or... `-A INPUT -i X`: by using INPUT, you know that the packet was=20
going to a local destination, which means the pkt had a daddr that is=20
configured on that interface (or you have tproxy).

>> Thoughts?
>
>What would be a use case ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
