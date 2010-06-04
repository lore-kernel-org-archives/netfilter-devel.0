From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter Implementation Details.
Date: Fri, 4 Jun 2010 18:40:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006041837290.21439@obet.zrqbmnf.qr>
References: <AANLkTinQDDSWaxLDCuaRDTGLM_y8qPq4eCQT0smdjMzt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ninad Adi <adi.ninad@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53738 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0FDQkT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:40:19 -0400
In-Reply-To: <AANLkTinQDDSWaxLDCuaRDTGLM_y8qPq4eCQT0smdjMzt@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-06-04 18:35, Ninad Adi wrote:

>I am not a Netfilter GURU.
>Let Me know if my code tracing for netfilter is on right Path.
>Kernel Version 2.6.34.
>
># I have divided the netfilter activities happening in kernel in two p=
arts
>
>MY QUESTIONS
>
>QUES 1 --> What is this nf_hook_slow function why is it called so ?

=46astpath vs Slowpath.

>QUES 2 --> How does the registration of custom hook process takes
>place exactly and how does
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 pa=
cket know if there is any rule registered for it
>or not in the kernel code ?

You cannot know whether a particular Xtables rule is used,
much less so from a Netfilter hook, which is outside Xtables.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
