From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Thu, 20 May 2010 19:44:53 +0200
Message-ID: <1274377493.2508.4.camel@edumazet-laptop>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
	 <1274360664.4046.36.camel@edumazet-laptop> <4BF5414B.4090609@trash.net>
	 <AANLkTikp7NU1cdAQHJkK9L14DsyRceaypO3ao_93raUu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47103 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0ETRo6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 13:44:58 -0400
Received: by fxm5 with SMTP id 5so33725fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 10:44:56 -0700 (PDT)
In-Reply-To: <AANLkTikp7NU1cdAQHJkK9L14DsyRceaypO3ao_93raUu@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 20 mai 2010 =C3=A0 22:43 +0530, Anand Raj Manickam a =C3=A9cri=
t :

> Suppose , if there are around 50,000 connections adds and 50,000
> connection deletes  on 1 million conncurrent conntrack entry table we
> have a scalabilty problem ?
>=20

Yes, unless you use one cpu.

> The reason why i m posting this question is on the ablity of hash
> tables on 1 million entries vs rb trees handling 1 million entries .

Do you have an idea of the depth of a rb tree with 1 million entries ?

Well sized hash table is about 25 x faster than a rb tree in this case
for pure lookups, and inserts and deletes in hash table are about 100x
faster in this case.

hash table : one or two cache misses per lookup or inserts/deletes

rbtree with one million entries : about 25 caches misses per lookup, an=
d
maybe 100 cache misses per insert/delete.




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
