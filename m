From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Question about the "dst" field in sk_buff
Date: Wed, 3 Feb 2010 19:35:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002031930070.27969@obet.zrqbmnf.qr>
References: <2a3692de1002031015l7ff6e1a1w61caa03d46afb55b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Dominik Kaspar <dokaspar.ietf@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53758 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab0BCSfs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:35:48 -0500
In-Reply-To: <2a3692de1002031015l7ff6e1a1w61caa03d46afb55b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-03 19:15, Dominik Kaspar wrote:
>
>I'm trying to compile various xt_*.c files that try to access
>skb->dst. However, the sk_buff structure has no "dst" field in the
>kernel version I am using (2.6.31), only a "_skb_dst" field. So when I
>run "make", for example to compile the xt_ECHO.c example from the
>netfilter tutorial, I always encounter errors like this:
>
>error: =E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98d=
st=E2=80=99
>
>What do I have to do to solve this? I guess it has something to do
>with those "compat" files, but I don't how they are used... Any hint
>would be highly appreciated.

xt_ECHO is not normally built and thus has fallen behind in porting.
This has now been rectified.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
