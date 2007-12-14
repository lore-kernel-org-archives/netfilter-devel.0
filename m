From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Fri, 14 Dec 2007 09:39:38 -0300
Message-ID: <beb91d720712140439i13c730d9o687bfc22d3e58add@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
	 <4757C632.60503@trash.net>
	 <beb91d720712060325l22f4b609kdc481a64d36768e9@mail.gmail.com>
	 <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com>
	 <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>
	 <475E6696.50805@trash.net>
	 <cd6061db0712131341h166734ecjcdfd518cb8dfb5f8@mail.gmail.com>
	 <beb91d720712131414g4daff4e7ic03dd29ed503f197@mail.gmail.com>
	 <47624B66.5060205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Laurence J. Lane" <ljlane@debian.org>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:17443 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbXLNMjl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:39:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1729313wah.23
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Dec 2007 04:39:38 -0800 (PST)
In-Reply-To: <47624B66.5060205@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 14, 2007 6:22 AM, Patrick McHardy <kaber@trash.net> wrote:
> Salatiel Filho wrote:
> > On 12/13/07, Laurence J. Lane <ljlane@debian.org> wrote:
> >> On Dec 11, 2007 5:29 AM, Patrick McHardy <kaber@trash.net> wrote:
> >>
> >>> It shouldn't, but I haven't seen any other complaints about this
> >>> yet, so please try to either compile the kernel natively or also
> >>> cross-compile iptables.
> >> [ I'm jumping in on the end of the thread with comments not direct=
ed
> >> at anyone specific.]
> >>
> >> I just saw an additional comment to #446685. A search for "EABI ip=
tables"
> >> shows a known arm iptables' problem and at least one workaround is=
 the chroot
> >> method mentioned in the report.
> >>
> >> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D446685
>
>
> The bad fd bug visible in the strace attached to that report is the
> one I fixed in SVN.
>
> > I have not test the solution cause i have to download 116MB to chro=
ot :)
> > But i`m curious , if i compile both source kernel and source iptabl=
es
> > , should`t they be compatible ?
>
>
> They should, unless something is causing different structure layout.
>

I tried chroot in that rootfs. But when i try to run iptables i get

# iptables -L
ERROR: 0 not a valid target)
Aborted

So that is not a workaround.
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
