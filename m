From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 00:23:47 +0100
Message-ID: <4C9A9003.7060103@googlemail.com>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51357 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0IVXXy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:23:54 -0400
Received: by wyb28 with SMTP id 28so388374wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2010 16:23:53 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Yes, it seems to be an unfortunate omission in the Kbuild file. A new=
=20
> release will be up shortly, since I have already been pointed towards=
=20
> 2.6.36 changes.
>  =20
Oh, it's getting worse!

Because I use a custom-built kernel (built from source), every time a=20
new kernel version is released I go through a little ritual:

Since the 2 kmod-* and xtabbles-addons rpms do not recognise the=20
custom-built string after the kernel version - they moan (see the rpm=20
-post and -pre scripts to know what I mean), so I have to build xtables=
=20
from source. So, once I've compiled and installed my custom-built kerne=
l=20
I do the same thing with the xtables addons because of the above=20
shortcoming.

As soon as the last kernel version was released (7-56 I think) I did=20
compile xtables and installed it properly (though I did not notice the=20
absence of these two ipsets). That was, by memory, last week.

A few days ago, I reinstalled a patched version of iptables (you know=20
that, don't you!) so that I get to see the secmarks in their full glory=
=2E=20
Earlier today, after I found out about the absence of the above two=20
modules, I decided to do 'make clean' on the whole xtables source=20
directory and compile it from scratch in the hope to trace back what is=
=20
wrong.

Guess what? I cannot compile xtables now. I am getting the following er=
ror:

CC libxt_CHAOS.oo
libxt_CHAOS.c:99: warning: implicit declaration of function =91ALIGN=92
libxt_CHAOS.c:99: error: initializer element is not constant
libxt_CHAOS.c:99: error: (near initialization for =91chaos_tg_reg.size=92=
)
libxt_CHAOS.c:100: error: initializer element is not constant
libxt_CHAOS.c:100: error: (near initialization for=20
=91chaos_tg_reg.userspacesize=92)
make[3]: *** [libxt_CHAOS.oo] Error 1


I don't need to mention that I've never had this error before. At first=
=20
I thought it is Tom's patch which caused this (thanks, Tom!), so I did=20
download the iptables source and compiled it without the patch using=20
rpmbuld -bb etc, then installed it. Nope! Same error.

What I will try in the next half an hour or so is to install the rpm=20
which comes with F13 repos to see if that makes any difference because=20
if it doesn't I am stuck. If it does work that means the rpm built with=
=20
rpmbuild -bb from source is somewhat different from the one coming out=20
of FC13 repos, which, to me, is rather odd!

Will post again when I know the outcome.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
