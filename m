From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: double call to ip_conntrack_put() ?
Date: Mon, 18 Apr 2005 05:57:30 -0400
Message-ID: <876ef97a05041802571f302bfe@mail.gmail.com>
References: <20050418171657.0370.LARK@linux.net.cn>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050418171657.0370.LARK@linux.net.cn>
Content-Disposition: inline
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

On 4/18/05, Wang Jian <lark@linux.net.cn> wrote:
> death_by_timeout() calls ip_conntrack_put() before return. And
> death_by_timeout() is called combined with ip_conntrack_put() in some
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
>=20
> and in ip_ct_iterate_cleanup()
>=20
>         while ((h =3D get_next_corpse(iter, data, &bucket)) !=3D NULL) {
>                 struct ip_conntrack *ct =3D tuplehash_to_ctrack(h);
>                 /* Time to push up daises... */
>                 if (del_timer(&ct->timeout))
>                         death_by_timeout((unsigned long)ct);
>                 /* ... else the timer will get him soon. */
>=20
>                 ip_conntrack_put(ct);
>         }
>=20
> Is this intended or misuse?

This is intended. tuplehash_to_ctrack() generates a reference to the
conntrack record. In death_by_timeout() the refcount is decremented,
yielding 1 for the second call to ip_conntrack_put(). The dec_and_test
in nf_conntrack_put() (called by ip_conntrack_put()) will result in a
refcount of 0, sending the record to the destroy_conntrack() function
(or more properly, whatever's registered in nfct->destroy(), which I'm
pretty sure is always either NULL or destroy_conntrack()).

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
