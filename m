From: Stephen Frost <sfrost@snowman.net>
Subject: Re: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 19:01:12 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424230112.GP8524@ns.snowman.net>
References: <20030424184706.GM8524@ns.snowman.net> <Pine.LNX.4.33.0304241547520.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gQt10JDuGyDb0HQ5"
Cc: Patrick Schaaf <bof@bof.de>,
   "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0304241547520.8241-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gQt10JDuGyDb0HQ5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Andre Uratsuka Manoel (andre@insite.com.br) wrote:
> 	I have to have different rules for 5.000 different IP addresses=20
> and I have to be able to change them any time in any order, in a very=20
> small time.=20

Interesting.  What would you say to a netfilter module which allowed you
to specify a table for each IP address to jump to with a hash table
implementation thus giving you a constant-time lookup?

I'll think about this some more but I think it should be possible to do
that.

	Stephen

--gQt10JDuGyDb0HQ5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+qGy4rzgMPqB3kigRAsZoAJ9O92XNQG1mg6ReTuEK75kz3bsaMQCfeSWg
LecT7LuwIxsx91Fylsm95KA=
=uWl9
-----END PGP SIGNATURE-----

--gQt10JDuGyDb0HQ5--
