From: Harald Welte <laforge@netfilter.org>
Subject: Re: Difference between match and target
Date: Wed, 25 Jun 2003 11:10:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030625091005.GH2645@sunbeam.de.gnumonks.org>
References: <20030624170402.8564.54425.Mailman@kashyyyk> <005301c33ae3$141da460$010f430a@elitecore7>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4xmAKYnxoHNXa3WQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
Content-Disposition: inline
In-Reply-To: <005301c33ae3$141da460$010f430a@elitecore7>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4xmAKYnxoHNXa3WQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2003 at 11:59:06AM +0530, Sumit Pandya wrote:
> Hi Harald and All,
>     Then do Netfilter core team or Netfilter individual module authors wi=
ll
> think of reconsidering this policy?=20

No, not really.

> Like ipt_foo and ipt_FOO can be combined in one kernel module and that
> module will call both ipt_register_match and ipt_register_target in
> MODULE_INIT. In my point of view if we are inserting 2 modules then it
> is definitely consuming extra (some) memory of kernel.

yes, every module consumes at least one page (4k on x86).  So if you
want to save that memory (and even more, by skipping the __exit
functions), statically link it into the kernel rather than using a
module.

btw: you can do this now (having match and target in one kernel module,
registering as match and target - but this would break iptables
module-on-demand-loading code).  Where should iptables  know from, that
when the user specifies '-m foo' it should load a kernel module called
'ipt_BAR.o' ?

> -- Sumit

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4xmAKYnxoHNXa3WQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++WbtXaXGVTD0i/8RAgQVAKCjyQ0iArBEA9UPsW+7u7ijfCW4UgCggPDj
IKH98GRpKojRW22lNYDH02s=
=7YFS
-----END PGP SIGNATURE-----

--4xmAKYnxoHNXa3WQ--
