From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [ipt_recent] Re: [PATCH] ipt_recent 0.3.1 Released
Date: Mon, 14 Apr 2003 09:47:38 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030414134738.GF18434@ns.snowman.net>
References: <20030331213757.GU18434@ns.snowman.net> <20030414133248.GB6866@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EJCnrJiDxBM3d8Vu"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   Netfilter Developers <netfilter-devel@lists.netfilter.org>,
   ipt_recent Users <ipt_recent@snowman.net>
Content-Disposition: inline
In-Reply-To: <20030414133248.GB6866@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--EJCnrJiDxBM3d8Vu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Harald Welte (laforge@netfilter.org) wrote:
> May I assume that there is no incompatibility of using 0.3.0 userspace
> (which is what made it into iptables-1.2.8) and the 0.3.1 kernel part?

That's correct, though both versions have a few bugs in the save
logic which was pointed out by Stephane Ouellette and has been fixed in
my tree.  These things always seem to have a knack for showing up at
just the wrong time.

> I will send it to DaveM for kernel inclusion soon.

Great, thanks!  So far the only changes I've made to the kernel portion
of ipt_recent has been to move to using a macro for debugging statements
instead of all those ugly #ifdef's.

	Stephen

--EJCnrJiDxBM3d8Vu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+mrv6rzgMPqB3kigRAtUuAJ40KFdB2HaDdamo4RDJxhKssRClVACeJXZd
EKrTQ2WZvohmKOLE7f/p4nA=
=pxoQ
-----END PGP SIGNATURE-----

--EJCnrJiDxBM3d8Vu--
