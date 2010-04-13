From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 finding.
Date: Tue, 13 Apr 2010 14:44:29 +0200
Message-ID: <1271162669.16881.301.camel@edumazet-laptop>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	 <n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56246 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0DMMog (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:44:36 -0400
Received: by bwz19 with SMTP id 19so3191bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 05:44:35 -0700 (PDT)
In-Reply-To: <n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 13 avril 2010 =C3=A0 19:06 +0800, Changli Gao a =C3=A9crit :
> On Tue, Apr 13, 2010 at 6:09 PM, Patrick McHardy <kaber@trash.net> wr=
ote:
> > Changli Gao wrote:
> >> use hash table to speed up entry finding.
> >>
> >> If verdicts aren't received in order, list isn't efficient, and ha=
sh
> >> table is better.
> >
> > Any what is the advantage of using flex arrays compared to a simple
> > open code hash table?
> >
>=20
> From Documentation/flexible-arrays.txt
>=20
> Large contiguous memory allocations can be unreliable in the Linux ke=
rnel.
> Kernel programmers will sometimes respond to this problem by allocati=
ng
> pages with vmalloc().  This solution not ideal, though.  On 32-bit sy=
stems,
> memory from vmalloc() must be mapped into a relatively small address =
space;
> it's easy to run out.  On SMP systems, the page table changes require=
d by
> vmalloc() allocations can require expensive cross-processor interrupt=
s on
> all CPUs.  And, on all systems, use of space in the vmalloc() range
> increases pressure on the translation lookaside buffer (TLB), reducin=
g the
> performance of the system.
>=20
> User may create lots of queues, which have large hash tables. Flex
> array has better scalability than vmalloc() and kmalloc().
>=20

Thats theory. And for sparse arrays, that pro might be true.
In your case, you prealloc all the array, using more ram than vmalloc..=
=2E

In practice, x86 cpu can access vmalloced() data much faster then
flex_array_managed data (take a look at all the expensive divides in
flex code... :'( )

If vmalloc() happens to be slow, it can trivially be extended to use
huge pages too. It will happen one day, when/if necessary.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
