From: Harald Welte <laforge@netfilter.org>
Subject: dropping support for ipfwadm/ipchains (Re: when IPVS into netfilter?)
Date: Fri, 23 May 2003 21:52:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523195201.GO3077@sunbeam.de.gnumonks.org>
References: <3EB44BE7.3070602@wanadoo.es> <3EBCE288.5020801@drugphish.ch> <3EBEACBC.2090202@wanadoo.es> <3EC9DC59.6010006@drugphish.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kr14OxHsRwZHHqxS"
Cc: Xose Vazquez Perez <xose@wanadoo.es>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
Content-Disposition: inline
In-Reply-To: <3EC9DC59.6010006@drugphish.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kr14OxHsRwZHHqxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2003 at 09:42:17AM +0200, Roberto Nibali wrote:

> And to go back on being more on-topic, I'd like to ask the netfilter=20
> team if the ip_fw_compat.c is going to remain in the 2.5.x/2.6.x cycle?
> I was under the impression that Rusty once mentioned that he'd wanted to=
=20
> get rid of it, but I could be dreaming here.

To quote from the packet filtering howto:
---
 There are modules in the netfilter distribution called ipchains.o and
 ipfwadm.o. Insert one of these in your kernel (NOTE: they are
 incompatible with ip_tables.o!). Then you can use ipchains or ipfwadm
 just like the good old days.

 This will be supported for some time yet. I think a reasonable formula
 is 2 * [notice of replacement - initial stable release], beyond the
 date that a stable release of the replacement is available. This means
 that support will probably be dropped in Linux 2.6 or 2.8.
---

So this would make something like 2*(iptables_included-ipchains_included).
But then the question is whether we are talking about stable kernels or
development kernels?

I think ipfwadm can be dropped safely, but ipchains will have to stay.

> The second one is, which makes the whole LVS code as non-intrusive as=20
> even possible. I think the netfilter community could live with two more=
=20
> ifdef-blocks, right? :)

We certainly don't mind.  However, having IPVS specific ifdefs in the
mainline kernel while IPVS is outside the mainstream kernel sounds a bit
odd to me.   I think in general this is discouraged...

> Best regards,
> Roberto Nibali, ratz
> --=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kr14OxHsRwZHHqxS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+znvhXaXGVTD0i/8RAv08AKCmUSzdizUUMdSZX0A3ts8KM39gqgCgjSgT
XZ3kc4igGQXl4m3to8FfHVs=
=QvCn
-----END PGP SIGNATURE-----

--kr14OxHsRwZHHqxS--
