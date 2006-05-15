From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Mon, 15 May 2006 15:27:38 -0400
Message-ID: <20060515192738.GN7774@kenobi.snowman.net>
References: <egts52hm2epfu4g1b9kqkm4s9cdiv3tvt9@4ax.com>
	<20060508050748.GA11495@w.ods.org>
	<20060507.224339.48487003.davem@davemloft.net>
	<44643BFD.3040708@trash.net>
	<9a8748490605120409x3851ca4fn14fc9c52500701e4@mail.gmail.com>
	<44647280.1030602@trash.net> <446490BB.10801@ufomechanic.net>
	<44683AFF.4070200@trash.net>
	<20060515142834.GL7774@kenobi.snowman.net>
	<4468CD3C.3000908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DH4/xewco2zMcht6"
Cc: gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, marcelo@kvack.org,
	willy@w.ods.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4468CD3C.3000908@trash.net>
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


--DH4/xewco2zMcht6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Patrick McHardy (kaber@trash.net) wrote:
> I wasn't sure whether eviction was happening intentional in the old code
> at all - still not able to locate the code where this happens, just
> noticed that it does do eviction when I manually tried to trigger
> a table overflow by adding entries through /proc. Anyway, it should
> be easy to fix by keeping an additional lru list. I'll post
> an updated patch soon.

It was always done intentionally; as I mentioned, it was originally
written with the expectation of the table always being full.  That was
also why I used one large malloc'd table and the hash chaining that I
did- I always knew ahead of time exactly how much memory I'd be using as
a running-set and never needed to do any allocation during operation.
In hindsight I can see that the additional complexity from it was
perhaps not worth the benefit that I saw from it.

The eviction is handled through the 'time_info_list'.  This is basically
just an always-ordered (by time) array of positions into the main table.
Line 504 (from stock 2.6.16) is where the list is used to add a new
entry at the end of the list (replacing the oldest address).  'time_pos'
points to the oldest entry.  The 'position' is then used to clear out
the entry associated with this address from the hash table and the main
table.  These are then replaced with the new address information and the
time_pos is adjusted accordingly.  This didn't help the complexity as it
meant I was tracking through different systems the position of each
address in the time_info_list, the main table, and the hash table.
Using the lists might make this a bit easier to implement though.

Then on line 566, if a new packet has come in for an existing address,
we have to move that address up to the top of the time_info_list as it
is now the 'most recent'.  As someone else mentioned, this might have
been better done using 'memmove' but I wasn't sure about its use or
performance in the kernel.  This is done again on line 617 when removing
an address, which is expected to be a somewhat rare event (where an
address is explicitly removed instead of just expiring).  One issue I
was concerned about was that I really didn't want the system to become
unhappy if a huge number of different addresses suddenly came in (more
than the list could support and/or more than would be sensible to try to
allocate memory to track).

I'm really not sure why I didn't break out this code into more
functions.  It certainly would have made things much clearer/simpler.  I
think I was (without any particular reason for it) concerned about
adding too many functions or calling things from the match() function.
As for why I didn't use existing kernel structures, well, I wasn't aware
of them in part and when I was asking about things I was asking about
more complicated things (such as a generic storage/hashing system) than
really made sense.  I'm not sure I would have used the lists anyway
since I liked the general idea of just having the one 'main' table but
it does seem to make things cleaner.

	Thanks,

		Stephen

--DH4/xewco2zMcht6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEaNYprzgMPqB3kigRAqcrAJ934BXRthinvzj/v3ed6TonHwwH2ACgnRru
b8iaT2XAcJ95fMQ6zqwMb3M=
=ZrRl
-----END PGP SIGNATURE-----

--DH4/xewco2zMcht6--
