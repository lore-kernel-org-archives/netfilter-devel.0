From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Possible bug in TCPOPTSTRIP?
Date: Wed, 22 Apr 2009 14:15:19 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904221414280.31941@fbirervta.pbzchgretzou.qr>
References: <20090422102414.GA2310@bts.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: svens@bitebene.org,
	=?UTF-8?Q?Marian_=C4=8Eurkovi=C4=8D?= <md@bts.sk>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZDVMPV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:15:21 -0400
In-Reply-To: <20090422102414.GA2310@bts.sk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Cc: netfilter-devel]

On Wednesday 2009-04-22 12:24, Marian =C4=8Eurkovi=C4=8D wrote:

>Hi,
>
>  after some attempts to remove wscale option using TCPOPTSTRIP module
>we run into strange problem. With the following combination of TCP opt=
ions,
>TCPOPTSTRIP is not able to find/strip wscale option:
>
><mss 1460,sackOK,timestamp 3448576858 0,nop,wscale 7>
>
>It can find sack-permitted, also timestamp, but not wscale.
>
>With other combinations, e.g.
>
><mss 1460,nop,nop,sackOK,nop,wscale 7>
>
>TCPOPTSTRIP finds/strips wscale option very well.
>
>Tested on 2.6.27-21 (Fedora10) with iptables 1.4.1.1
>
>Any ideas?
>
>
>   Thanks & kind regards,
>
>         M.
> =20
>
>
>----------------------------------------------------------------------=
----
>----                                                                  =
----
>----   Marian =C4=8Eurkovi=C4=8D                       network  manage=
r         ----
>----                                                                  =
----
>----   Slovak Technical University           Tel: +421 2 571 041 81   =
----
>----   Computer Centre, N=C3=A1m. Slobody 17      Fax: +421 2 524 94 3=
51   ----
>----   812 43 Bratislava, Slovak Republic    E-mail/sip: md@bts.sk    =
----
>----                                                                  =
----
>----------------------------------------------------------------------=
----
>
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
