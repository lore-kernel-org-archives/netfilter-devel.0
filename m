From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Tue, 4 Dec 2007 12:40:35 -0300
Message-ID: <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <4753B957.2000207@trash.net>
	 <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>
	 <47550D5C.8090004@trash.net>
	 <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
	 <47551A83.80009@trash.net>
	 <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>
	 <475561C6.4030704@trash.net>
	 <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>
	 <47556D32.1060901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:20002 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXLDPkh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:40:37 -0500
Received: by wr-out-0506.google.com with SMTP id c49so3027716wra
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Dec 2007 07:40:36 -0800 (PST)
In-Reply-To: <47556D32.1060901@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
> [netfilter-devel re-added. Please don't drop CCs]
>
> Salatiel Filho wrote:
> > On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
> >
> >>> I tried the patch but it didn`t work.
> >>>
> >>> ~# iptables --version [patched now]
> >>> iptables v1.3.8
> >>>
> >>> ~# iptables -L
> >>> iptables v1.3.8: can't initialize iptables table `filter': Invali=
d argument
> >>> Perhaps iptables or your kernel needs to be upgraded.
> >>
> >> Could you send another strace please?
> >>
>
> > getsockopt(3, SOL_IP, 0x40 /* IP_??? */,
> > "filter\0\0\0\0\0\0\340?\3@\310[\1@\1\0\0\0\244\213\0\0"..., [84]) =
=3D 0
> > brk(0)                                  =3D 0x1c000
> > brk(0x3d000)                            =3D 0x3d000
> > getsockopt(3, SOL_IP, 0x41 /* IP_??? */, 0x1c0c0, 0xbea55c24) =3D -=
1
>
>
> Thanks. The invalid fd usage is gone, this seems to be a problem
> in the interaction between kernel and userspace. Please enable
> debugging as I wrote a couple of mails ago and post the output.
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

OK. Debug enabled.

~# iptables -L
iptables v1.3.8: can't initialize iptables table `filter': Invalid argu=
ment
Perhaps iptables or your kernel needs to be upgraded.

# dmesg
ip_tables: (C) 2000-2002 Netfilter core team
translate_table: size 632
=46inished chain 1
=46inished chain 2
=46inished chain 3
table->private->number =3D 4
get_entries: 668 !=3D 672


~# lsmod
Module                  Size  Used by
iptable_filter          2304  0
ip_tables              24672  1 iptable_filter
snd_mixer_oss          14848  0
snd                    41976  1 snd_mixer_oss
soundcore               7524  1 snd



--=20
[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
