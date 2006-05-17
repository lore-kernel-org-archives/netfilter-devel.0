From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Wed, 17 May 2006 09:14:15 -0400
Message-ID: <20060517131415.GS7774@kenobi.snowman.net>
References: <44647280.1030602@trash.net> <446490BB.10801@ufomechanic.net>
	<44683AFF.4070200@trash.net>
	<20060515142834.GL7774@kenobi.snowman.net>
	<4468CD3C.3000908@trash.net>
	<20060515192738.GN7774@kenobi.snowman.net>
	<4468DFF6.5020304@trash.net>
	<20060515204142.GO7774@kenobi.snowman.net>
	<20060515210342.GP7774@kenobi.snowman.net>
	<446AC1FB.5070406@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwgCY5hL6Igino+O"
Cc: gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, marcelo@kvack.org,
	willy@w.ods.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <446AC1FB.5070406@trash.net>
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


--LwgCY5hL6Igino+O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Patrick McHardy (kaber@trash.net) wrote:
> OK, updated patch attached. The TTL is now always kept up-to-date.

Yup, that looks good.  Unfortunately, it looks like the lru_list isn't
being kept track of correctly now.  Perhaps I'm reading it wrong but it
*looks* like recent_entry_init() is only initializing the lru_list for
the local entry but doesn't ever add it to the main table lru_list.  My
guess is you were expecting that to be done by recent_entry_update() but
it's never the case that recent_entry_update() is called directly after
recent_entry_init() due to the 'goto out' (my line 199).  Therefore I'm
afraid that a new entry is never added to the lru_list with the current
setup and if nothing is ever updated you'll end up in a bad situation.

I think you can just drop lines 198 & 199 and modify recent_entry_init()
to not put the initial stamp in.  This way, for a new entry to the list,
recent_entry_init() is called still on 195, the return value is updated
just like it would be for an existing entry, and recent_entry_update()
is called to handle adding the latest stamp and updating the lru_list.

Looking at list.h, I *think* that will work (wasn't sure if
list_move_tail() would be upset about the state of the e->lru_list
coming from INIT_LIST_HEAD but I think the __list_del will effectively
be a no-op and so it'll be fine).

	Thanks,

		Stephen

--LwgCY5hL6Igino+O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEayGnrzgMPqB3kigRAlBmAKCQMnvtFv8cT3I8CFnXo9HvXLYgxgCfepCM
469DZk/CDgk2GwqXkJZW0lc=
=+GXs
-----END PGP SIGNATURE-----

--LwgCY5hL6Igino+O--
