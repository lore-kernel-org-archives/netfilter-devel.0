From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Wed, 26 Feb 2003 18:41:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226174145.GN8883@sunbeam.de.gnumonks.org>
References: <20030224051810.GB7523@pc.ilinx> <20030225044337.GA4113@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XlS4q8O07AKt4+K1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030225044337.GA4113@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XlS4q8O07AKt4+K1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2003 at 11:43:37PM -0500, netfilter@interlinx.bc.ca wrote:
> To followup on my own message...

;)
> OK,  I have been doing some digging in the code.  From what I have
> determined, it looks like there is no allowance for creating multiple
> non-unique expectations.  I can see why the design is such that this
> is the case, as it allows ip_conntrack_expect_related() to renew the
> timeout on a related simply by posting the expectation again.

true.

> But, there does seem to be a "use" counter in "struct
> ip_conntrack_expect".  Is that of any use to me?

no, this is a reference counter used internally. when use drops to 0,
the structure is kfree()d.

> Anyway, I did manage to solve this problem with the following hack.  I
> have no idea if it's the right solution or not, but I suspect it's
> not.  More on why below.

it's not a hack, it is _the_ solution.

> So my solution was to repost the expectation when the related
> (expected) connection comes in via the struct
> ip_conntrack_expect.expectfn() function pointer.  I assigned to that,
> the following function:

I don't remember which helper, but this _is_ already implemented in one
of the helpers.  I am quite sure that we had this discussion an the list
and somebody has actually already implemented this solution.

> I am not sure if the locking in there is needed, or if this approach
> is even the right way to make an incoming expectation
> persistant/perpetual.  If not, I am open to alternatives.

I don't know the rest of the code, but locking should in general not be
needed (at least not by the core).

> In any case, what makes me suspect that this is the wrong solution is
> that (back to the "use" counter) while the expectation does not seem
> to disappear on me (good) the use counter increments indefinately.  It
> is at:

if you increment the use counter, the structure will never be deleted
from kernel memory and you will run out of memory.  The expectation will
_not_ persist in an active state, since it is removed from the
expect_list anyway.

> Brian J. Murrell



--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XlS4q8O07AKt4+K1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPxZXaXGVTD0i/8RAgawAKCwvnqLRkOURQSjPqWNb0iKfDwSeACgqcf4
T7xYuk0eZpmnGtsW7D/WvrI=
=iWWL
-----END PGP SIGNATURE-----

--XlS4q8O07AKt4+K1--
