From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Wed, 30 Oct 2002 11:34:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030103452.GD8060@noir.cb.ac.at>
References: <3DBED94E.1030107@videotron.ca> <200210292243.07631.aef@prismnet.com> <20021030100457.X8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021030100457.X8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 30, 2002 at 10:04:57AM +0100, Harald Welte wrote:
> > >    I developped last week a new extension to Netfilter in order to
> > > enable or disable a set of rules using /proc files.
> > Yeah, as others have said, the idea is definitely cool.
> Though the idea is cool, I think we are solving a problem the wrong way.  Why
> add complexity to the kernel for a problem which can be solved without
> any problem from userspace?
Well, the same would apply to time and pool matches, wouldn't it? They made it
into patch-o-matic though.

> Live long and prosper
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505122023

--
Saving Private Ryan...
Private Ryan exists. Overwrite? (Y/N)

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v7XMzogxsPZwLzcRAoBSAJ0RMLgSTCAANFv4ZM7msKFnnLk9NQCfbrK1
4ISbJSWZS8p07goCFJRqZGk=
=Ckc/
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
