From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: fragmented packet
Date: Mon, 6 Sep 2010 11:12:48 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009061111190.11628@obet.zrqbmnf.qr>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com> <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com> <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
 <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com> <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr> <AANLkTik03N1ZRKeF=0YGWSvXOhccrVKMwHEQHB_TVjR6@mail.gmail.com> <AANLkTi=LVLd2YxkDDeh3uGpW2R3n_QC-F=SHM115bY6b@mail.gmail.com>
 <AANLkTi=G5LY--8_-o7yEsLZYvwdXxUpLAF6v2iRpqTEh@mail.gmail.com> <AANLkTin4Kn5Ueb0QqquoEmSx6abbRtda62=X=NKC4yQU@mail.gmail.com> <AANLkTiksSfN9w0b__u5XWj8FmnAQRQXi-hVOzG9K52V1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54187 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0IFJMt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:12:49 -0400
In-Reply-To: <AANLkTiksSfN9w0b__u5XWj8FmnAQRQXi-hVOzG9K52V1@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-09-06 02:10, Nicola Padovano wrote:

>Sorry, discard last mail...
>those 140 bytes are the __TCP PAYLOAD__ (check it with wireshark) so
>the datagram ip size is: IP HEADER + TCP HEADER + TCP PAYLOAD =
>140+20+20=180...isn't it?


I suggest to just use plain ping -s $((MTU-8-20)).
