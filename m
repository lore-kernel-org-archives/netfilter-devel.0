From: Harald Welte <laforge@netfilter.org>
Subject: Re: adding field into conntrack
Date: Mon, 2 Aug 2004 10:46:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040802084602.GJ18758@sunbeam2>
References: <1091042173.4107fb7d2cabf@mail.crocetta.org> <1091060982.28111.30.camel@bach> <20040801171930.GD14539@sunbeam2> <1091434360.410df7789a879@mail.crocetta.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0FM4RQAc0jwHekq5"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sandr8@crocetta.org
Content-Disposition: inline
In-Reply-To: <1091434360.410df7789a879@mail.crocetta.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0FM4RQAc0jwHekq5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 02, 2004 at 10:12:40AM +0200, sandr8@crocetta.org wrote:

> Around line 1320 of net/core/dev.c, the packet is fed to the queueing
> discipline associated with the egressing interface. The enqueuing
> operation might not be succesful or even being succesful it could have
> made the queueing discipline drop an other packet (possibly belonging
> to an other stream).

Yes, indeed.

> The error we made could be huge with respect to open loop streams
> (such as UDP), while with closed loop ones we could imagine that there
> will be not that much difference between the throughput seen before
> the enqueuing and the goodput seen after the deuqueuing.

My reason for making it less accurate was performance.  By putting the
counter updates into the ip_ct_refresh_acct() function, we minimize
write lock contention on ip_conntrack_lock, since we only need to grab
it once per packet (as opposed to a second time after qdisc enqueue).

But if I understood your approach corretly, you would want to keep this
code in place but later check for enqueue result and decrement
accounting?  This means that the extra write lock grab would only happen
in case of dropped packets... that sounds fine.

Please prepare an incremental patch and we'll review & discuss with
netdev people.

> Alessandro
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0FM4RQAc0jwHekq5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDf9JXaXGVTD0i/8RAqhhAJ9sYkfzFnlDAseI4yuSNpC4RQa5GQCfam1i
fmkUR2lpL3xWWkd8PzQeCGU=
=SuLx
-----END PGP SIGNATURE-----

--0FM4RQAc0jwHekq5--
