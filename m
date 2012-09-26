From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: searching tuples in conntrack
Date: Wed, 26 Sep 2012 22:32:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209262231180.30346@nerf07.vanv.qr>
References: <CA+Z0r8MVyzWP_uM+Ryge5YY8Dr9XO+Uh1x0g7Zc8FBp16mMAGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Miguel_Alejandro_Gonz=C3=A1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50280 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab2IZUcU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:32:20 -0400
In-Reply-To: <CA+Z0r8MVyzWP_uM+Ryge5YY8Dr9XO+Uh1x0g7Zc8FBp16mMAGQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-09-26 19:29, Miguel Alejandro Gonz=C3=A1lez wrote:

>Hello,
>
>I have been reading some kernel code trying to find a function that
>searches the conntrack hash table for a transport address and returns
>the given tuple. Is there any way to do this? I found a function in
>the nat code called find_appropriate_src but i think it only works for
>the nat table...

nf_conntrack_find_get(...) is the one to use for CT lookup.
(Cf. xt_connlimit.c)

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
