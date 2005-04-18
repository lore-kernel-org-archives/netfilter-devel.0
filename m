From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: double call to ip_conntrack_put() ?
Date: Mon, 18 Apr 2005 11:56:30 +0200
Message-ID: <1113818190.4167.12.camel@nienna.balabit>
References: <20050418171657.0370.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <20050418171657.0370.LARK@linux.net.cn>
To: Wang Jian <lark@linux.net.cn>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2005-04-18, h keltez=E9ssel 17.29-kor Wang Jian ezt =EDrta:
> death_by_timeout() calls ip_conntrack_put() before return. And
> death_by_timeout() is called combined with ip_conntrack_put() in so=
me
> places, such as
>=20
> in early_drop()
>=20
>         if (del_timer(&ct->timeout)) {
>                 death_by_timeout((unsigned long)ct);
>                 dropped =3D 1;
>                 CONNTRACK_STAT_INC(early_drop);
>         }
>         ip_conntrack_put(ct);

  This isn't a bug. The function gets a reference to the conntrack en=
try
before releasing the read lock of the hash table, so it must release =
the
entry after deleting it from the hash.

> and in ip_ct_iterate_cleanup()
>=20
>         while ((h =3D get_next_corpse(iter, data, &bucket)) !=3D NU=
LL) {
>                 struct ip_conntrack *ct =3D tuplehash_to_ctrack(h);
>                 /* Time to push up daises... */
>                 if (del_timer(&ct->timeout))
>                         death_by_timeout((unsigned long)ct);
>                 /* ... else the timer will get him soon. */
>=20
>                 ip_conntrack_put(ct);
>         }

  Same here. get_next_corpse() increases the refcount of the returned
conntrack, so the caller has to dereference it.

--=20
KOVACS Krisztian <hidden@sch.bme.hu>
