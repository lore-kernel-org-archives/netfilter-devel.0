From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt2 table core
Date: Mon, 5 Jul 2010 12:34:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007051230480.27078@obet.zrqbmnf.qr>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>  <201007020532.12596.simonl@parknet.dk>  <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>  <1278322612.2877.21.camel@edumazet-laptop>  <alpine.LSU.2.01.1007051138480.18387@obet.zrqbmnf.qr>
 <1278325323.2877.27.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Simon Lodal <simonl@parknet.dk>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38095 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab0GEKel (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:34:41 -0400
In-Reply-To: <1278325323.2877.27.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-07-05 12:22, Eric Dumazet wrote:
>Le lundi 05 juillet 2010 =C3=A0 11:42 +0200, Jan Engelhardt a =C3=A9cr=
it :
>
>> If you see where this went awry, I'd be grateful. (The tests have be=
en=20
>> run on a single CPU.)
>
>Oh well, thats huge, I could not load them on my (32bit, 8 cpus) dev
>machine :)

Wuss? I was able to load it into 64-bit VM configured with 1 GB RAM.

>[ 7838.882153] vmap allocation for size 19869696 failed: use
>vmalloc=3D<size> to increase size.
>
>I guess size of your rules, went from 20 Mbytes per cpu to say... 160
>MBytes on xt2 ?

As a side-effect of multiple allocations of non-blob structures,
probably so.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
