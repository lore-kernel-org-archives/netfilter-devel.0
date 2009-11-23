From: Patrick McHardy <kaber@trash.net>
Subject: Re: Is this nf_conn "use" counter bug???
Date: Mon, 23 Nov 2009 10:56:50 +0100
Message-ID: <4B0A5C62.4040606@trash.net>
References: <20091123031259.B666712B9D3@smtp.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: kendo <kendo999@sohu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36134 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431AbZKWJ4v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:56:51 -0500
In-Reply-To: <20091123031259.B666712B9D3@smtp.sohu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kendo wrote:
>  In my linux 2.6.30.9,I found a strange question about netfilter:
>  =20
> [root@localhost ~]# conntrack -L | grep flow
> conntrack v0.9.13 (conntrack-tools): 321 flow entries have been shown=
=2E
>=20
> [root@localhost ~]# conntrack -C
> 14360
>=20
> ct.count(14360) is far greater than the conntrack hash table number(3=
21).Final,table full...game over.
>=20
> Further analysis of statistics counters:
>=20
> [root@localhost ~]# cat /proc/net/stat/nf_conntrack
> entries  searched found new invalid ignore delete delete_list insert =
insert_failed drop early_drop icmp_error  expect_new expect_create expe=
ct_delete
> 0000392c  00000078 00036049 000042b9 000005f7 0000037f 00000468 00003=
9af 00004291 0000002a 00000000 00000000 0000015c  00000000 00000000 000=
00000=20
> 0000392c  00000003 0000873e 00000012 00000061 00000414 00000053 00000=
7a5 00000012 00000000 00000000 00000000 00000002  00000000 00000000 000=
00000=20
> 0000392c  00000000 000017c4 00000002 00000012 00000eb8 00000103 00000=
009 00000002 00000000 00000000 00000000 00000000  00000000 00000000 000=
00000=20
> 0000392c  00000004 00002a4d 00000004 00000018 000005a3 000000f6 00000=
011 00000003 00000000 00000000 00000000 00000003  00000000 00000000 000=
00000=20
> 0000392c  00000006 000034d6 0000007d 0000004f 00000197 000000a5 00000=
031 00000030 00000051 00000000 00000000 0000000c  00000000 00000000 000=
00000=20
> 0000392c  00000004 000038a8 00000004 00000055 00000383 000000cf 00000=
016 00000004 00000000 00000000 00000000 00000002  00000000 00000000 000=
00000=20
> 0000392c  00000004 00002e82 00000004 0000000d 0000179c 0000010e 00000=
014 00000004 00000000 00000000 00000000 00000000  00000000 00000000 000=
00000=20
> 0000392c  00000001 00003911 00000005 0000006d 000002fd 000000f9 00000=
011 00000005 00000000 00000000 00000000 00000002  00000000 00000000 000=
00000
>=20
> I found "delete_list"(16868) countres is far greater than the "delete=
"(2607) counters.Is cant't be release when a conntrack be delete from c=
onntrack hash table???
>=20
> static void death_by_timeout(unsigned long ul_conntrack)
> {
>  struct ip_conntrack *ct =3D (void *)ul_conntrack;
>=20
>  WRITE_LOCK(&ip_conntrack_lock);
>  /* Inside lock so preempt is disabled on module removal path.
>   * Otherwise we can get spurious warnings. */
>  CONNTRACK_STAT_INC(delete_list);
>  clean_from_lists(ct);
>  WRITE_UNLOCK(&ip_conntrack_lock);
>  ip_conntrack_put(ct);
> }

This code looks like from the 2.4 era.

> static inline void nf_conntrack_put(struct nf_conntrack *nfct)
> {
>  if (nfct && atomic_dec_and_test(&nfct->use))
>   nf_conntrack_destroy(nfct);
> }
>=20
> What is wrong with the nfct->use counter may be the problem,Lead to n=
f_conntrack_destroy functions can not properly be called? From a statis=
tical counter to the results of,clean_from_lists have been implemented,=
but the nf_conntrack_destroy does not seem to be running.
>=20
> This is only my guess,I didn't fond any thing from the source code.Ho=
wever,if it is not so,What causes my connection to track the total numb=
er of non-stop to rise=EF=BC=8Ctable full and memory has been eaten?

Most likely there's an skb leak somewhere and the conntrack references
are not released.

> Environment:
> -----internet--cisco switch (two port bonding)-----linux box(two brid=
ge)----cisco switch(two port bonging)---server
>=20
> Cisco switch link aggregation=EF=BC=8Cuse two port.Linux box have two=
 Independent network bridge.

Please post your full network settings and netfilter rules.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
