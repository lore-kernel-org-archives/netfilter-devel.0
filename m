From: Harald Welte <laforge@netfilter.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Wed, 26 Nov 2003 12:36:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org> <20031126034231.GA1044@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031126034231.GA1044@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2003 at 04:42:32AM +0100, Herve Eychenne wrote:

> Yes, but that is really negligible (2 * size_of_pointer * HASHSIZE).

well, sizof(void *) is 4 bytes on most archs... two times is 8.  so if
you have let's say 100k buckets, that's 800k non-swappable kernel
memory...

> > > So, it cannot be read at runtime, I suppose... It would be really nic=
e,
> > > though... would /proc be ok?
>=20
> > yes. It is printed at startup via syslog, however.
>=20
> Syslog can be enough for humans, but not for scripts...
> I think you can add "make hashsize value available through /proc" to
> the TODO list (whose size is unfortunately ever growing ;-)).

i'd rather write a patch than add it to the todo list.  adding and
removing that item from the list would be about the same amount of work,
i guess.

> > maybe you're running a different kernel?
>=20
> Debian standard kernel.  Maybe they are patching netfilter?  These are sm=
art
> guys! ;-)

IIRC debian has still 2.4.18 which had a different hashing algorithm

> > no, there are none deleted.  we just skip creating new ones until the
> > number has dropped below the limit.  There is no special case for that,
> > we just chek >=3D conntrack_max at conntrack allocation time.
>=20
> Don't you think it would be good to shrink the lists immediately?
> Waiting til the number has dropped below the limit can take days...

well, it might be a good idea.  but I somehow doubt this is a valid
scenario.  And if we would shrink the list:  how do we select which
entries to evict?  I'd rather wait for ctnetlink to appear in mainstream
kernels and then leave that to a userspace process.

> > yes.  but just because your suse or redhat default packetfilter script
> > modprobes ip_conntrack, there is no way we can assume that this is a
> > firewall-only machine.
>=20
> Of course.  Once more, I didn't propose that this should be done
> automatically, I just wanted to know if someone had any objection to
> that statement.

ah, ok.

>  Herve
> (=B0=3D  Herv=E9 Eychenne

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xJBNXaXGVTD0i/8RAh2YAKChzJHlHhEA8GgilIo1K0L2N7r2WwCfZ4pW
kSgDCN377b1DXiojVKL9YiY=
=OSkk
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
