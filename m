From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Thu, 13 Dec 2007 19:14:12 -0300
Message-ID: <beb91d720712131414g4daff4e7ic03dd29ed503f197@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
	 <47565BB3.9030500@trash.net>
	 <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
	 <4757C632.60503@trash.net>
	 <beb91d720712060325l22f4b609kdc481a64d36768e9@mail.gmail.com>
	 <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com>
	 <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>
	 <475E6696.50805@trash.net>
	 <cd6061db0712131341h166734ecjcdfd518cb8dfb5f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:48115 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXLMWOQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:14:16 -0500
Received: by wr-out-0506.google.com with SMTP id c49so614727wra.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Dec 2007 14:14:14 -0800 (PST)
In-Reply-To: <cd6061db0712131341h166734ecjcdfd518cb8dfb5f8@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/13/07, Laurence J. Lane <ljlane@debian.org> wrote:
> On Dec 11, 2007 5:29 AM, Patrick McHardy <kaber@trash.net> wrote:
>
> > It shouldn't, but I haven't seen any other complaints about this
> > yet, so please try to either compile the kernel natively or also
> > cross-compile iptables.
>
> [ I'm jumping in on the end of the thread with comments not directed
> at anyone specific.]
>
> I just saw an additional comment to #446685. A search for "EABI iptab=
les"
> shows a known arm iptables' problem and at least one workaround is th=
e chroot
> method mentioned in the report.
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D446685
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I have not test the solution cause i have to download 116MB to chroot :=
)
But i`m curious , if i compile both source kernel and source iptables
, should`t they be compatible ?

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
