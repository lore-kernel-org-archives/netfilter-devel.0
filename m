From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to take over TCP connection from userspace process?
Date: Tue, 21 Oct 2003 19:31:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031021173138.GC12049@sunbeam.de.gnumonks.org>
References: <006701c397a5$9c13fee0$d32f110a@yrhd> <20031021134729.GB12049@sunbeam.de.gnumonks.org> <20031021145537.GA25030@superhijitus.linux.org.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Diego Woitasen (Lanux)" <diegows@linux.org.ar>
Content-Disposition: inline
In-Reply-To: <20031021145537.GA25030@superhijitus.linux.org.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2003 at 11:55:37AM -0300, Diego Woitasen (Lanux) wrote:
> Runhua is talking about other issue, I think. He is talking about
> forward quickly ESTABLISHED connections, without traversing all rules.

this is policy, not mechanism.  ip_conntrack provides a mechanism (for
tracking connections).  How you use that information, is policy.  Policy
is expressed by the ruleset or other local configuration.

> I think that this will be implemented in the new version of iptables (I
> thought about this from time ago). For example, for every connection we
> have an entry in conntrack table, the entry must hold information about
> filter rules that was consulted in the first packet of that connection.
> Then the packets of an ESTABLISHED connection will be pass directly
> without rule check.
> For this we need a new field(s) en struct skb that hold the necessary
> info, and the nf_hook() will  check this field(s) for a quickly return.

no new field required at all.  That is exactly how ip_conntrack is used
today.  Your first (or one of the first) rules willbe 'accept all
ESTABLSHED' traffic.  Thus, you iterate only over a single rule for
every _but_ the first packet.

> Diego Woitasen
> LUGar
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/lW16XaXGVTD0i/8RApQVAJ4xUQDUBrkuGzY3f0VX9enDS859HACfQJYi
nIp7yia7YTUZfsEjZvF2ddw=
=P7Gv
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
