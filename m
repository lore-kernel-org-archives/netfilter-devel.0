From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: static build breakage - 1.4.16.2.
Date: Mon, 8 Oct 2012 17:16:14 -0700
Message-ID: <CAHo-OoxV9YQfXueHrBt1WJjv7MpsEOfkBdwOeEhcJbvGQ+wv7Q@mail.gmail.com>
References: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
	<alpine.LNX.2.01.1210090002380.21001@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45501 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2JIAQP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:16:15 -0400
Received: by mail-qc0-f180.google.com with SMTP id v28so3475414qcm.11
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Oct 2012 17:16:14 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1210090002380.21001@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> (N.B. You can have both --enable-static and --enable-shared)

Yeah, but I just want a small binary and don't need shared support
(indeed it's even undesirable).

> This patch seems to do it for me. Ok for you?

Looks like it.
Care to push and release as .3?

Although perhaps calling it pfx_aliases or pfx_build_alias would be
better (there doesn't seem to be any actual symlinks are there?)

This also skips the blacklist_modules logic, which I guess in this
case doesn't matter.

> @@ -39,7 +39,7 @@ endif
>  #      Wildcard module list
>  #
>  pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
> -pfx_build_mod += NOTRACK state
> +pfx_symlinks  := NOTRACK state
>  @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
>  @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
>  pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
> @@ -48,7 +48,7 @@ pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
>  pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
>  pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
>  pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
> -pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod})
> +pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
>  pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
>  pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
>
> @@ -220,7 +220,7 @@ man_run    = \
>         done >$@;
>
>  matches.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
> -       $(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod}))
> +       $(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
>
>  targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
> -       $(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod}))
> +       $(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
> --
> # Created with git-export-patch
