From: Harald Welte <laforge@netfilter.org>
Subject: Re: [nf-failover] [PATCH] Numerous ct_sync updates.
Date: Sat, 16 Oct 2004 10:12:40 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041016081240.GD29413@sunbeam.de.gnumonks.org>
References: <20041014191624.GH12694@obroa-skai.de.gnumonks.org>
	<1097849367.2498.107.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1097849367.2498.107.camel@nienna.balabit>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 15, 2004 at 04:09:27PM +0200, KOVACS Krisztian wrote:
> 2004-10-14, cs keltez=E9ssel 21:16-kor Harald Welte ezt =EDrta:
> > - comment out INITSYNC_FOLLOWS code, it shouldn't be needed anymore
>=20
>   Yes, it's obsolete now that MASTER_ANNOUNCE is sent before each
> initial resync. If the end of an initsync run would be signalled as well
> (by always sending the empty update message for example) the following
> code could be obsoleted as well (it is a hack, after all):

the end is not explicitly signalled.  At the moment we just have a flag
indicating whether the message is part ofan initsync or not.  I have to=20
think about this.  Maybe another flag set in the last message (F_DONE)
to indicate this is the last msg of a dump.

>   Hmm, the log message does not seem to be correct, CT_SYNC_INFO should
> be _after_ setting csr->seqno to the new value.=20

Yes, I'll fix that.

> And because the master announcement is now sent without incrementing
> the sender's seqno (which is correct in my opinion), we really have to
> subtract 1 in the second part, don't we?

It worked here... I spent quite some amount of time debugging sequence
number issues and it turned out that we always announced a wrong
sequence number, since the seqno was incremented at the time we enqueued
packets into the ring.

>   I have some updates as well, I'll commit them if I find the time
> needed to do some basic testing. (Mostly trivial ones not affecting
> normal operation at all...)

Ok.

>   BTW, I think the protocol/ct_sync needs some more work. At the moment,
> it is not possible for a single node to be part of more sync groups, and
> this is a problem if you try to use ct_sync in a typical VRRP setup...

yes, I agree.

However, at the moment I can still have the master (of a
2-identical-node setup) generate too many state packets for the slave to
process.  If I look on the wire, I see the messages, but the slave
apparently doesn't get them and sends NACK). =20

running nmap through your ct_sync cluster seems to be enough for that.
I have to check where the problem is and find out what we can do about
it :(

>  Regards,
>    Krisztian KOVACS

btw: I've now ported the conntrack events to 2.6.x (see other mail), so
porting ct_sync to 2.6.x should be fairly easy - although I think it
should stabilize on 2.4.x first.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBcNf4XaXGVTD0i/8RAvVnAJ44OwNtkO3R2gTQXL79K+iS1Bl6sACfa/nm
Q+VBlxvkMu4lNyXuDFbm9HM=
=ID3x
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
