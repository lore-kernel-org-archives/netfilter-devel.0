From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Tue, 4 Dec 2007 11:16:36 -0300
Message-ID: <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <4753B957.2000207@trash.net>
	 <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>
	 <47550D5C.8090004@trash.net>
	 <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
	 <47551A83.80009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org,
	"Jesper Dangaard Brouer" <hawk@diku.dk>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:63894 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbXLDOXo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:23:44 -0500
Received: by nz-out-0506.google.com with SMTP id s18so2319756nze
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Dec 2007 06:23:43 -0800 (PST)
In-Reply-To: <47551A83.80009@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
> Jan Engelhardt wrote:
> > On Dec 4 2007 09:18, Patrick McHardy wrote:
> >> Salatiel Filho wrote:
> >>> On Dec 3, 2007 5:07 AM, Patrick McHardy <kaber@trash.net> wrote:
> >>>> Salatiel Filho wrote:
> >>>>> # iptables -L
> >>>>> iptables v1.3.6: can't initialize iptables table `filter': Bad =
file
> >>>>> descriptor
> >>>>> Perhaps iptables or your kernel needs to be upgraded.
> >>>>>
> >>>>> My machine is a ARM machine with debian 4.0.
> >>>>> I also have already tried 1.3.8 and got the same error.
> >>>> Which kernel version (please also send .config)? Did you compile
> >>>> iptables yourself or used a version from Debian?
> >>>>
> >
> > This looks more like an userspace issue. The strace log shows that =
the
> > netlink socket was obtained, but calls setsockopt with fd=3D-1.
> > Just a guess, though.
>
>
> Right, I missed that, thanks. Jesper seems to be correct, if autoload=
ing
> fails we close the socket and decrement sockfd_use twice, which cause=
s
> iptables to not open it again for the second attempt.
>
> Salatiel, does this patch fix the problem?
>
> Index: libiptc/libiptc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- libiptc/libiptc.c   (Revision 7130)
> +++ libiptc/libiptc.c   (Arbeitskopie)
> @@ -866,10 +866,6 @@
>         CHECK(h);
>         return h;
>  error:
> -       if (--sockfd_use =3D=3D 0) {
> -               close(sockfd);
> -               sockfd =3D -1;
> -       }
>         TC_FREE(&h);
>         return NULL;
>  }
>
>

I tried the patch but it didn`t work.

~# iptables --version [patched now]
iptables v1.3.8

~# iptables -L
iptables v1.3.8: can't initialize iptables table `filter': Invalid argu=
ment
Perhaps iptables or your kernel needs to be upgraded.

~# lsmod
Module                  Size  Used by
iptable_filter          2304  0
ip_tables              22016  1 iptable_filter
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
