From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 13:21:57 +0100
Message-ID: <4C9B4665.6070904@googlemail.com>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr> <4C9AA703.5080301@googlemail.com> <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr> <4C9B308E.5010804@googlemail.com> <alpine.LNX.2.01.1009231256200.29321@obet.zrqbmnf.qr> <4C9B3848.8010503@googlemail.com> <alpine.LNX.2.01.1009231415580.31650@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64867 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0IWMWF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:22:05 -0400
Received: by wyb28 with SMTP id 28so791799wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2010 05:22:04 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009231415580.31650@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> ./autogen.sh, then configure.
>  =20
on make I am getting this:

CC libxt_pknock.oo
libxt_pknock.c:330: warning: implicit declaration of function =91ALIGN=92
libxt_pknock.c:330: error: initializer element is not constant
libxt_pknock.c:330: error: (near initialization for =91pknock_mt_reg.si=
ze=92)
libxt_pknock.c:331: error: initializer element is not constant
libxt_pknock.c:331: error: (near initialization for=20
=91pknock_mt_reg.userspacesize=92)
make[5]: *** [libxt_pknock.oo] Error 1


So, basically, the same thing!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
