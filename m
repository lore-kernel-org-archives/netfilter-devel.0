From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec)
 [part 2]
Date: Wed, 21 Mar 2012 13:44:30 -0700
Message-ID: <1332362670.9433.9.camel@edumazet-glaptop>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
	 <1332361663.9433.8.camel@edumazet-glaptop>
	 <CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44130 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126Ab2CUUod (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:44:33 -0400
Received: by dajr28 with SMTP id r28so2072541daj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Mar 2012 13:44:32 -0700 (PDT)
In-Reply-To: <CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-03-21 at 13:40 -0700, Maciej =C5=BBenczykowski wrote:
> But that's a kernel feature, and I don't think we can rely on it bein=
g
> present in iptables userspace (it has to be backwards compatible to
> IMHO at least back to 2.6.9 if at all possible),
> and adding the "try with flag, if fails, retry without flag and
> manually set it" logic seems overkill.
>=20
> I think such details only matter for multithreaded programs with exec=
 races.
> Which I don't believe to be the case here.

True, but CLOEXEC on iptables... I mean... how is it mandatory ?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
