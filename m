From: netfilter@interlinx.bc.ca
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Mon, 24 Feb 2003 23:43:37 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030225044337.GA4113@pc.ilinx>
References: <20030224051810.GB7523@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030224051810.GB7523@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

To followup on my own message...

On Mon, Feb 24, 2003 at 12:18:15AM -0500, netfilter@interlinx.bc.ca wrote:
>=20
> I thought the max_expected =3D 10 would achieve what I want but all I
> ever seem to get is one expectation waiting and it goes away as soon
> as I get one connection (as observed by both /proc/net/ip_conntrack
> and seeing "blocking" rules in the firewall where a connection should
> be allowed because of the expectation).

OK,  I have been doing some digging in the code.  From what I have
determined, it looks like there is no allowance for creating multiple
non-unique expectations.  I can see why the design is such that this
is the case, as it allows ip_conntrack_expect_related() to renew the
timeout on a related simply by posting the expectation again.

But, there does seem to be a "use" counter in "struct
ip_conntrack_expect".  Is that of any use to me?

Anyway, I did manage to solve this problem with the following hack.  I
have no idea if it's the right solution or not, but I suspect it's
not.  More on why below.

So my solution was to repost the expectation when the related
(expected) connection comes in via the struct
ip_conntrack_expect.expectfn() function pointer.  I assigned to that,
the following function:

static int gnutella_expectfn(struct ip_conntrack *foo)
{

    /* foo->master is the expectation that we are being called for
     * (and want to repost) and foo->master->expectant is the connection
     * that we are related to
     */
    if (foo->master && foo->master->expectant) {
        LOCK_BH(&ip_gnutella_lock);
        ip_conntrack_expect_related(foo->master->expectant, foo->master);
        UNLOCK_BH(&ip_gnutella_lock);
    }

    return 0;

}

I am not sure if the locking in there is needed, or if this approach
is even the right way to make an incoming expectation
persistant/perpetual.  If not, I am open to alternatives.

In any case, what makes me suspect that this is the wrong solution is
that (back to the "use" counter) while the expectation does not seem
to disappear on me (good) the use counter increments indefinately.  It
is at:

EXPECTING: 179 use=3D120 proto=3D6 src=3D0.0.0.0 dst=3D66.102.74.122 sport=
=3D0 dport=3D6346=20

right now.  This has to be wrong.  At a minimum, I wonder why incoming
connections that meet the expectation are not decrementing the use
counter.

Thots?

b.

--=20
Brian J. Murrell

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+WvR5l3EQlGLyuXARAueBAJ0anoBEhjcLlnc3NqMVlicSoFdwEwCeKyd1
v8j/QuzYsJ/UA57FcMNgEZQ=
=Dhjw
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
