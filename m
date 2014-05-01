From: Florian Westphal <fw@strlen.de>
Subject: Re: ebtables issue in compat mode
Date: Thu, 1 May 2014 12:02:29 +0200
Message-ID: <20140501100229.GS31953@breakpoint.cc>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Sharat Masetty <sharat04@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54627 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbaEAKCb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 May 2014 06:02:31 -0400
Content-Disposition: inline
In-Reply-To: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sharat Masetty <sharat04@gmail.com> wrote:
> I am seeing a problem when running ebtables in 32bit userspace and 64
> bit kernel space mode.
>=20
> The command I am trying to run is
> ebtables -t broute -A BROUTING -p IPv4 -j DROP
>=20
> Here is the log message I am seeing in userspace
>=20
[..]

> I noticed that setsockopt() is failing . The message is also printed
> in kernel =E2=80=93 Standard target size too big . This occurs becaus=
e there
> is a mismatch in the size of the structures ebt_standard_target which
> is 48 bytes in kernel and 40 bytes in userspace.
>=20
> Can someone help us fix this issue?

Please provide more information.

Works fine for me on x86_64 with 32 bit binary:
# ~/bin32/ebtables -t broute -A BROUTING -p IPv4 -j DROP
# echo $?
0
ebtables -L shows
Bridge chain: BROUTING, entries: 1, policy: ACCEPT
-p IPv4 -j DROP=20

as expected.  Linux 3.13.11 x86_64.

Are you using an old kernel without ebt compat support?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
