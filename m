From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Fri, 21 May 2010 07:43:53 +0800
Message-ID: <AANLkTimp3nxDMgetLIB-aLhxAYrsLAT00enaBy0Fe4k-@mail.gmail.com>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
	<1274360664.4046.36.camel@edumazet-laptop> <4BF5414B.4090609@trash.net>
	<AANLkTikp7NU1cdAQHJkK9L14DsyRceaypO3ao_93raUu@mail.gmail.com>
	<1274377493.2508.4.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49978 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab0ETXoO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 19:44:14 -0400
Received: by pvg3 with SMTP id 3so155263pvg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 16:44:14 -0700 (PDT)
In-Reply-To: <1274377493.2508.4.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 21, 2010 at 1:44 AM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>
> Do you have an idea of the depth of a rb tree with 1 million entries =
?
>
> Well sized hash table is about 25 x faster than a rb tree in this cas=
e
> for pure lookups, and inserts and deletes in hash table are about 100=
x
> faster in this case.
>
> hash table : one or two cache misses per lookup or inserts/deletes
>
> rbtree with one million entries : about 25 caches misses per lookup, =
and
> maybe 100 cache misses per insert/delete.
>
>

and we have to do insertion and deletion in serial with rbtree, so
rbtree doesn't scales as well as hash tables for parallel processing,
if there are many insertions and deletions operations.


--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
