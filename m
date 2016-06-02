From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Thu, 2 Jun 2016 23:57:51 +0800
Message-ID: <20160602155751.GB23133@insomnia>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602151107.GA23133@insomnia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602151107.GA23133@insomnia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2016 at 11:11:07PM +0800, Boqun Feng wrote:
[snip]
>=20
> OK, I will resend a new patch making spin_unlock_wait() align the
> semantics in your series.
>=20

I realize that if my patch goes first then it's more safe and convenient
to keep the two smp_mb()s in ppc arch_spin_unlock_wait(). I will only do
fix and clean up in my patch and leave the semantics changing part to
you ;-)

> Regards,
> Boqun



--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEbBAABCAAGBQJXUFd3AAoJEEl56MO1B/q4ELoH9idk9QnmBY7yI4KUujv6x6/y
LkIjxEZSQbcrQaLTLXlrNMxvdQbOkrA1NYvb7vV9yMABD+9nxnj2TO2Ja+hHxijE
4bS/+APOVW1JMAvw9uOWe/2DgaczjpwdpzlV7O9rh4ELXDHtJXdvPmmfZIn/QlZ+
o4MjHQhRc57I4MOuiIK1oD8H+onkmLGRmXZdH46+qD5EVwiX//Cc6GOUHTtQfBiE
akE7Me0+OrYqOylcfveVPL8I2F5KGy7apuhPrdF7KRt68pdAz2z4PE4n+5qXJ7pz
5duCmiGiJ2/Cxi2zNSQFl+MLYR/k3/nqgD2Ku30BfSaHiqv27IWaFiuV1th/7Q==
=Iw9p
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
