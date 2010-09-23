From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 14:24:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009231423380.31650@obet.zrqbmnf.qr>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr>
 <4C9AA703.5080301@googlemail.com> <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr> <4C9B308E.5010804@googlemail.com> <alpine.LNX.2.01.1009231256200.29321@obet.zrqbmnf.qr> <4C9B3848.8010503@googlemail.com> <alpine.LNX.2.01.1009231415580.31650@obet.zrqbmnf.qr>
 <4C9B4665.6070904@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54110 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab0IWMYL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:24:11 -0400
In-Reply-To: <4C9B4665.6070904@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-09-23 14:21, Mr Dash Four wrote:
>
>> ./autogen.sh, then configure.
>> =20
> on make I am getting this:
>
> CC libxt_pknock.oo
> libxt_pknock.c:330: warning: implicit declaration of function =E2=80=98=
ALIGN=E2=80=99
> libxt_pknock.c:330: error: initializer element is not constant
> libxt_pknock.c:330: error: (near initialization for =E2=80=98pknock_m=
t_reg.size=E2=80=99)
> libxt_pknock.c:331: error: initializer element is not constant
> libxt_pknock.c:331: error: (near initialization for
> =E2=80=98pknock_mt_reg.userspacesize=E2=80=99)
> make[5]: *** [libxt_pknock.oo] Error 1

Hm. Can you just send me your F13 kernel-headers-2.6.34 rpm in private=20
please, so I can figure out why the workaround does not fly yet.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
