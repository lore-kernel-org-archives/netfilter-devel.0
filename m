From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Wed, 5 Dec 2007 08:39:58 -0300
Message-ID: <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <475561C6.4030704@trash.net>
	 <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>
	 <47556D32.1060901@trash.net>
	 <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>
	 <475578F1.8060600@trash.net>
	 <beb91d720712040805u7dd0241by2349e9b34c361a87@mail.gmail.com>
	 <47557D04.1040101@trash.net>
	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
	 <47565BB3.9030500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:24132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXLELj7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:39:59 -0500
Received: by wa-out-1112.google.com with SMTP id v27so7054791wah
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Dec 2007 03:39:58 -0800 (PST)
In-Reply-To: <47565BB3.9030500@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 5, 2007 5:05 AM, Patrick McHardy <kaber@trash.net> wrote:
> Salatiel Filho wrote:
> > On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
> >
> >> Right, we only recently added it. Are you compiling against your
> >> kernel source? Otherwise check in /usr/include/linux/...
> >>
> > How do i know if i am compiling against my kernel source ?
> > Does it auto use /usr/src/linux/... ?
> > anyway , i changed /usr/include/linux/linux/netfilter/x_tables.h bu=
t
> > still the same problem.
> >
> >
> > # iptables -L
> > iptables v1.3.8: can't initialize iptables table `filter': Invalid =
argument
> > Perhaps iptables or your kernel needs to be upgraded.
>
> Perhaps the 32/64 bit hacks that are still included in 1.3.8
> are falsely enabled. Please post a few lines from the iptables
> compilation output.
>

Should i try 1.40 ?

# make
Extensions found: IPv4:CLUSTERIP IPv4:recent IPv6:ah IPv6:esp
IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/include
-Iinclude/ -DIPTABLES_VERSION=3D\"1.3.8\"  -fPIC -o
extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
cc -shared  -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/include
-Iinclude/ -DIPTABLES_VERSION=3D\"1.3.8\"  -fPIC -o
extensions/libipt_addrtype_sh.o -c extensions/libipt_addrtype.c
cc -shared  -o extensions/libipt_addrtype.so extensions/libipt_addrtype=
_sh.o
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/include
-Iinclude/ -DIPTABLES_VERSION=3D\"1.3.8\"  -fPIC -o
extensions/libipt_comment_sh.o -c extensions/libipt_comment.c
cc -shared  -o extensions/libipt_comment.so extensions/libipt_comment_s=
h.o
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/include
-Iinclude/ -DIPTABLES_VERSION=3D\"1.3.8\"  -fPIC -o
extensions/libipt_connmark_sh.o -c extensions/libipt_connmark.c
cc -shared  -o extensions/libipt_connmark.so extensions/libipt_connmark=
_sh.o
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/include
-Iinclude/ -DIPTABLES_VERSION=3D\"1.3.8\"  -fPIC -o
extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c


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
