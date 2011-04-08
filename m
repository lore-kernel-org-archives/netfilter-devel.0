From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Fri, 08 Apr 2011 18:11:22 +0100
Message-ID: <4D9F41BA.1060509@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:57990 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1DHRLX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:11:23 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id CFACC340325
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2011 18:11:22 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id xFKP9DOQ-aTo for <netfilter-devel@vger.kernel.org>;
	Fri,  8 Apr 2011 18:11:22 +0100 (BST)
Received: from Ed-Wildgooses-MacBook-Pro.local (office.nippynetworks.com [212.69.49.94])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id 76D30340324
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2011 18:11:22 +0100 (BST)
In-Reply-To: <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/04/2011 01:47, Maciej =C5=BBenczykowski wrote:
>> Does someone have any ideas on how I can finesse these constant (and
>> expensive in my case) modprobes each time we run the iptables comman=
d?
>=20
> Could you try with an iptables built from iptables git master branch?
> I believe a recent change I submitted (delayed initialization of
> target/matches to prevent module autoloading) may actually fix your
> problem.

Thanks - very helpful!

It was easiest for me to patch my iptables with just your commit and my
results are very promising:

Starting "shorewall"
- using busybox modprobe + released iptables =3D several minutes...
- module-init-tools + released iptables =3D 12s
- module-init-tools + your commit =3D 7.7s
- module-init-tools + patching out modprobe completely =3D 4.9s

So, whilst your patch has a huge positive benefit, I'm still seeing a
substantial amount of cpu going to useless modprobing.

I don't see an immediate solution, *unless* there is some way to ask th=
e
kernel if some module is already compiled in? I don't immediately see
that this is possible and google didn't turn anything up? I guess the
various xtables modules could export something that allows them to be
detected as loaded, but I sense that this is unlikely to be an
acceptable patch unless others have shown that there is a performance
problem?

Of the rest of my 4.9s, 97% of that is waiting for iptables and tc to d=
o
stuff.  I need to profile further to see where the delays are though

Thanks for your commit above - extremely helpful - grateful if you migh=
t
consider whether there is some way to avoid any modprobes at all? (Note
that the -M option appears not to work in iptables at present?)

Thanks

Ed W


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
