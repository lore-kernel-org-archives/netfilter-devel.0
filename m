From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Fri, 21 May 2010 04:34:41 +0200
Message-ID: <1274409281.4977.3.camel@edumazet-laptop>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
	 <1274360664.4046.36.camel@edumazet-laptop> <4BF5414B.4090609@trash.net>
	 <AANLkTikp7NU1cdAQHJkK9L14DsyRceaypO3ao_93raUu@mail.gmail.com>
	 <1274377493.2508.4.camel@edumazet-laptop>
	 <AANLkTimp3nxDMgetLIB-aLhxAYrsLAT00enaBy0Fe4k-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35522 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0EUCeq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 22:34:46 -0400
Received: by wwi18 with SMTP id 18so360152wwi.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 19:34:45 -0700 (PDT)
In-Reply-To: <AANLkTimp3nxDMgetLIB-aLhxAYrsLAT00enaBy0Fe4k-@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 21 mai 2010 =C3=A0 07:43 +0800, Changli Gao a =C3=A9crit :
> On Fri, May 21, 2010 at 1:44 AM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> >
> > Do you have an idea of the depth of a rb tree with 1 million entrie=
s ?
> >
> > Well sized hash table is about 25 x faster than a rb tree in this c=
ase
> > for pure lookups, and inserts and deletes in hash table are about 1=
00x
> > faster in this case.
> >
> > hash table : one or two cache misses per lookup or inserts/deletes
> >
> > rbtree with one million entries : about 25 caches misses per lookup=
, and
> > maybe 100 cache misses per insert/delete.
> >
> >
>=20
> and we have to do insertion and deletion in serial with rbtree, so
> rbtree doesn't scales as well as hash tables for parallel processing,
> if there are many insertions and deletions operations.
>=20
>=20

Before saying such things, you should read the source code Changli,
because you only propagate wrong information.

conntrack uses a single lock, so inserts and deletes _are_ serialized,
_even_ with hash table.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
