From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v3 3/8] locking: Introduce smp_acquire__after_ctrl_dep
Date: Thu, 2 Jun 2016 07:19:43 +0800
Message-ID: <20160601231943.GD30064@insomnia>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.037298593@infradead.org>
 <20160601135214.GC30064@insomnia>
 <20160601162255.GT3190@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k4f25fnPtRuIRUb3"
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601162255.GT3190@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--k4f25fnPtRuIRUb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 01, 2016 at 06:22:55PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 01, 2016 at 09:52:14PM +0800, Boqun Feng wrote:
> > On Tue, May 31, 2016 at 11:41:37AM +0200, Peter Zijlstra wrote:
>=20
> > > @@ -292,7 +282,7 @@ static void sem_wait_array(struct sem_ar
> > >  		sem =3D sma->sem_base + i;
> > >  		spin_unlock_wait(&sem->lock);
> > >  	}
> > > -	ipc_smp_acquire__after_spin_is_unlocked();
> > > +	smp_acquire__after_ctrl_dep();
> >=20
> > I wonder whether we can kill this barrier after updating
> > spin_unlock_wait() to ACQUIRE?
>=20
> See patch 5 doing that :-)

Oops, right ;-)

Regards,
Boqun

--k4f25fnPtRuIRUb3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXT22JAAoJEEl56MO1B/q4+W0H/1GIqudmMPVieC/ebtu3mySs
LER03q8exkKgnD9sdLENokyjCTxEvyaQ2JLqDT98an9Cza5SmOFV7fumMDZikf1V
zL/kAaQnTd/OXfpiN9YmmTr5Uyyeav8JfE0DcZVaidk8ohyXJeEvvI0l9z7UEPoi
zPyiMkxYdfcXTqTemH2/8LpRdxvvohDpPDsiDbzFBY5AZ0N8jif2+7EMcKxqD+Ur
qRFKsOwUUmAlnYYxfv07Zdfd4lPUr8LefAfEtk1PYhCCmT83F9kNnG4XU0w0jlkF
+mwiHW6FqMuUS6tqhBGYpnGT/sUOCZarEo8UkxdY0Wl2kUJ5CdYdTlnw5i63suA=
=g+US
-----END PGP SIGNATURE-----

--k4f25fnPtRuIRUb3--
