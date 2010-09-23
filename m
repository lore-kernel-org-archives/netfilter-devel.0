From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 13:49:03 +0100
Message-ID: <4C9B4CBF.8000704@googlemail.com>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr> <4C9AA703.5080301@googlemail.com> <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr> <4C9B308E.5010804@googlemail.com> <alpine.LNX.2.01.1009231256200.29321@obet.zrqbmnf.qr> <4C9B3848.8010503@googlemail.com> <alpine.LNX.2.01.1009231415580.31650@obet.zrqbmnf.qr> <4C9B4665.6070904@googlemail.com> <alpine.LNX.2.01.1009231423380.31650@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43479 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab0IWMtM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:49:12 -0400
Received: by wyb28 with SMTP id 28so815129wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2010 05:49:11 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009231423380.31650@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Hm. Can you just send me your F13 kernel-headers-2.6.34 rpm in privat=
e=20
> please, so I can figure out why the workaround does not fly yet.
>  =20
Just noticed another error further up (about 50 lines above the last I=20
sent you):

CC libxt_ACCOUNT.oo
libxt_ACCOUNT.c:147: warning: implicit declaration of function =91ALIGN=
=92
libxt_ACCOUNT.c:147: error: initializer element is not constant
libxt_ACCOUNT.c:147: error: (near initialization for =91account_tg_reg.=
size=92)
make[5]: *** [libxt_ACCOUNT.oo] Error 1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
