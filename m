From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 02:18:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42610 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0IWASX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:18:23 -0400
In-Reply-To: <4C9A9003.7060103@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-09-23 01:23, Mr Dash Four wrote:
>
>>Yes, it seems to be an unfortunate omission in the Kbuild file. A new=
 release
>>will be up shortly, since I have already been pointed towards 2.6.36 =
changes.
> =20
>Oh, it's getting worse!

You willingly chose to use Redhat/Fedora. Now endure the pain! :-)

>Since the 2 kmod-* and xtabbles-addons rpms do not recognise the custo=
m-built
>string after the kernel version -

Sounds like another Fedora problem. I know it works in openSUSE,
but that is probably because they make sure the custom string is
actually _in_ the version (as evidenced by `uname -r`).

>A few days ago, I reinstalled[...]
>
>Guess what? I cannot compile xtables now. I am getting the following e=
rror:
>
> CC libxt_CHAOS.oo
> libxt_CHAOS.c:99: warning: implicit declaration of function =E2=80=98=
ALIGN=E2=80=99
> libxt_CHAOS.c:99: error: initializer element is not constant
> libxt_CHAOS.c:99: error: (near initialization for =E2=80=98chaos_tg_r=
eg.size=E2=80=99)
> libxt_CHAOS.c:100: error: initializer element is not constant
> libxt_CHAOS.c:100: error: (near initialization for
> =E2=80=98chaos_tg_reg.userspacesize=E2=80=99)
> make[3]: *** [libxt_CHAOS.oo] Error 1

Yes, someone made a big boo and furthermore did not send the fix to
-stable (actually I don't know that), but what I know is that it
did not appear in -stable yet. And then there is that 2.6.34 is
no longer maintained. Let alone distros mostly don't even think
about updating. So everybody using linux-glibc-devel-2.6.34
(that is the userspace package providing /usr/include/linux) is
screwed.
http://bugs.gentoo.org/show_bug.cgi?id=3D325257
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
