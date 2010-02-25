From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: About the variable of "network_header" in the struct sk_buff
Date: Thu, 25 Feb 2010 20:02:59 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002252002010.17477@obet.zrqbmnf.qr>
References: <28efc0211002251017r76cd02ew122739990f30b3e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59924 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab0BYTDB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:03:01 -0500
In-Reply-To: <28efc0211002251017r76cd02ew122739990f30b3e9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-25 19:17, supercodeing35271 supercodeing35271 wrote=
:

>Hi,I really do not know that is it correctly of =C2=A0asking such a fo=
olish
>question in this high-level mailing list,but i could not find the
>answer by google it.
>As a recruit,i'm now studying netfilter,i want to write a simply test
>kernel module by the function of dropping the packet which the
>protocol is TCP.For that i have read the "Using Netfilter
>hooks"(http://www.topsight.net/article.php/2003050621055083/print),in
>the page there is a piece of code below:

You need to look at a recent documentation, such as "Writing=20
Netfilter Modules" PDF/e-book.

>      static int check_tcp_packet(struct sk_buff *skb)
>          {
>              /*........................*/
>              if (skb->nh.iph->protocol !=3D IPPROTO_TCP) {
>                  return NF_ACCEPT;
>              }
>
>              /*................*/
>          }
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
