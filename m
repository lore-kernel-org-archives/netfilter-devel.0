From: netfilter@interlinx.bc.ca
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Wed, 26 Feb 2003 15:40:10 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226204009.GA11142@pc.ilinx>
References: <20030224051810.GB7523@pc.ilinx> <20030225044337.GA4113@pc.ilinx> <20030226174145.GN8883@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030226174145.GN8883@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2003 at 06:41:45PM +0100, Harald Welte wrote:
>=20
> it's not a hack, it is _the_ solution.

Oh.  Decent.  :-)

> I don't remember which helper, but this _is_ already implemented in one
> of the helpers.

I can be so dumb sometimes.  I went googling for use of expectfn but
didn't think to look in existing helpers.  I think actually I didn't
think that any helpers were using it already.

In fact the h323 helper shows a nice example of hooking a different
helper function to the incoming connection of what was expected.  This
was going to be my next question.  :-)

[ you can skip the next three paragraphs if you are not interested in
  the nuances of the gnutella protocol and a question about to handle
  one aspect of it with a helper ]

The way Gnutella works, it starts out making outbound connections, but
because it's peer to peer, once your address gets circulated into the
"cleint pool" other people start making incoming connections to you.

The Gnutella client tries to keep between a minimum number and a
maximum number of connections up.  So it's completely possible that
once things get going, you will not make any further outbound
connections because inbound ones keep up your minimum connections
requirement.

Thus the need to hook further incoming expecations on incoming
connection requests.  If I am correct, in order to do this, I need to
hook a helper to each inbound connection that simply sets up the same
expectation -- for more inbound connections.  I have not thought of
the NAT implications of this yet, but that will be after I have the
expectations working for both inbound and outbound connections.

> I am quite sure that we had this discussion an the list
> and somebody has actually already implemented this solution.

There seem to be a few uses of expectfn that I am sure I can glean
lots from.

> I don't know the rest of the code, but locking should in general not be
> needed (at least not by the core).

OK.

>=20
> > In any case, what makes me suspect that this is the wrong solution is
> > that (back to the "use" counter) while the expectation does not seem
> > to disappear on me (good) the use counter increments indefinately.  It
> > is at:
>=20
> if you increment the use counter,

I am not touching the counter, myself.  However, every time I repost
the expectation with:

static int gnutella_expectfn(struct ip_conntrack *ct)
{

    struct ip_conntrack *master;
    master =3D master_ct(ct);
    if (!master) {
        DEBUGP(" no master!!!\n");
        return 0;
    }

    ip_conntrack_expect_related(master, ct->master);

    return 0;
}

[ I wonder if the above function should be put into the
  ip_conntrack_core as "repost_expect(struct ip_conntrack *)" (or
  something similar).  It's generic enough and should not really need
  to be written by many people who just need to repost expectations
  when they are met. ]

in the expectfn function, the counter is increased.  This continues to
happen until the master connection goes away, and the expectation is
removed.

I would have thought the counter would go 0, 1, 0, 1, 0, 1... (or 1,
2, 1, 2, 1, 2, 1, 2...) as incoming connections repeaped the
expectation and my helper reposts it.  If it's normal and expected (no
pun intended) that the counter just continue to increment as incoming
(expected) connections are made and I repost the expectation, then I
won't worry about it.

> the structure will never be deleted
> from kernel memory and you will run out of memory.

If I can trust that it's freed from kernel memory when it disappears
in /proc/net/ip_conntrack, I won't run out of memory if I wasn't going
to run out of memory already.  It's not a recurring "leak".  The
counter is incrementing as per the reposting of the expectation, but
when the master goes away, so does the expectation (with it's high
counter).

> The expectation will
> _not_ persist in an active state, since it is removed from the
> expect_list anyway.

I think you are just saying what I said, albeit more concisely, no?
(It's a sad state when one's use of his native tongue is worse than
another's use of his second tongue.  :-)

b.

--=20
Brian J. Murrell

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+XSYpl3EQlGLyuXARAoTBAKDMuYIdwpcgVxIfh6pir/Zr+osGhQCg3iRR
VvS6cF04Pda6tniqgneGtok=
=nc9X
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
--4Ckj6UjgE2iN1+kY--
