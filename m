From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: xt2 table core
Date: Mon, 05 Jul 2010 12:22:03 +0200
Message-ID: <1278325323.2877.27.camel@edumazet-laptop>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
	 <201007020532.12596.simonl@parknet.dk>
	 <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
	 <1278322612.2877.21.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1007051138480.18387@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Simon Lodal <simonl@parknet.dk>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64946 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0GEKWJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:22:09 -0400
Received: by fxm14 with SMTP id 14so3509020fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2010 03:22:07 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1007051138480.18387@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 05 juillet 2010 =C3=A0 11:42 +0200, Jan Engelhardt a =C3=A9cri=
t :

> If you see where this went awry, I'd be grateful. (The tests have bee=
n=20
> run on a single CPU.)

Oh well, thats huge, I could not load them on my (32bit, 8 cpus) dev
machine :)

[ 7838.882153] vmap allocation for size 19869696 failed: use
vmalloc=3D<size> to increase size.

I guess size of your rules, went from 20 Mbytes per cpu to say... 160
MBytes on xt2 ?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
