From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match code for review/testing/...
Date: Wed, 8 Jan 2003 22:16:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030108211622.GT9467@sunbeam.de.gnumonks.org>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com> <20030106125720.GF9467@sunbeam.de.gnumonks.org> <15897.46884.822054.847738@isis.cs3-inc.com> <20030107185748.GV9467@sunbeam.de.gnumonks.org> <15899.51201.381520.438520@isis.cs3-inc.com> <20030108105646.GH9467@sunbeam.de.gnumonks.org> <15900.33229.827518.797424@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rVbcdceMkFY6fDyG"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15900.33229.827518.797424@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rVbcdceMkFY6fDyG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2003 at 11:53:49AM -0800, Don Cohen wrote:

> Well, not quite that bad.  It's actually o(10x(10+10)).  The structure
> sizes seem to be 5+8 so actually using 1300 bytes.  I don't know
> whether there's more space wasted on alignment.
> Would it work to make that 10 into a module parm (or three) ?

unfortunately not.  The size of this structure needs to be known at
compile time of the kernel and iptables userspace (and they have to be
the same, obviously).

>  > Sorry, I didn't make myself clear.  if u32 is used the right way, it is
>  > way better than lots of the static matches within iptables.  However, =
it
> I don't know what "the right way" means.  A more specific match will
> be faster to execute and easier to specify.  The advantage of u32 is
> generality.

You are still comparing u32 to a current iptables match.  What is more
interesting is comaring u32 against a whole iptables chain which uses
only static matches (i.e. matching criteria that can be expressed in u32
syntax). =20

> Perhaps you should view it as temporary until something better
> arrives.  You might consider changing the architecture later.
> My impression is that jamal <hadi@cyberus.ca> is well on the way to
> using tc to replace iptables.  And I begin to see that his approach
> (or at least what I imagine to be his approach) might actually be
> a lot more efficient. =20

Yes.  Unfortunately I am not able to reproduce the (verbal) discussions
between Jamal, Werner Almesberger, Robert Olsson and me...=20
Nobody questions that what he's doing is more efficient.  In fact,
almost anything you can do (with a fundamentally different
architecture) for matching a packet based on static matching criteria
(i.e. port number=3Dx, tos=3Dy, ttl=3Dz, ...) present in the packet header
will be more efficient than iptables.   See also the nf-hipac project.

But will it be as easily extensible as iptables?
Will it support efficient matching of out-of-packet data? (i.e.
state, random, nth, conntrack, helper, ... matches of iptables)

And in the end the question is: How much efficiency at this level do we
need?  In a time of stateful firewalling, most people don't do lots of
classification based on 'static' criteria.  In iptables-terminology: One
of the first rules will be '-m state --state ESTABLISHED -j ACCEPT',
resulting in only a single rule to be iterated for every packet part of
an already established connection...=20

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--rVbcdceMkFY6fDyG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HJUmXaXGVTD0i/8RAg1TAJkBM6WCRXj4+cDHFD/9fc/1BGXIrwCfUcgM
bi1zIgr7taCeBQhLgoRaNtI=
=gRu2
-----END PGP SIGNATURE-----

--rVbcdceMkFY6fDyG--
