From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 21:41:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030530194107.GH29312@sunbeam.de.gnumonks.org>
References: <200305290113.58552.prez@srealm.net.au> <200305290810.16531.prez@srealm.net.au> <20030530080806.GB29312@sunbeam.de.gnumonks.org> <200305301342.16153.prez@srealm.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
Content-Disposition: inline
In-Reply-To: <200305301342.16153.prez@srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2003 at 01:42:07PM -0400, Preston A. Elder wrote:

> OK, just to be sure, I just installed kernel 2.4.21-rc6, with all the=20
> 'pending' patches applied to it as well, these are the ONLY patches appli=
ed=20
> to this kernel.

that one should be just fine.

> Netstat is showing me the following connection breakdowns:
> SNATs: 0
> ESTABLISHED : 1060
> LAST_ACK    : 4865
> TIME_WAIT   : 29
> FIN_WAIT2   : 1
> FIN_WAIT1   : 39
> SYN_RECV    : 3277
> LISTEN      : 100
> CLOSE_WAIT  : 9261
>=20
> /proc/ip_conntrack, however, is showing me the following:
> CLOSE: 176
> CLOSE_WAIT: 111
> ESTABLISHED: 9046
> FIN_WAIT: 8634
> SYN_RECV: 134
> SYN_SENT: 25111
> TIME_WAIT: 2165
> (no state): 128

you cannot just compare TCP socket states with connection tracking
states.   connection tracking tracks all connections (local and
forwarded ones), and if a connection isn't correctly closed by the
application (FIN handshake), it will assume that the connection still
exists - just one example of why this cannot be compared.

And why do you think there is a  'SNAT' socket state?

> use DNAT, same difference though).  So the above counts seem very wrong t=
o=20
> me.  And although the established count is very high, the SYN_SENT count =
is=20
> astronomical.

can you capture the packets with tcpdump and actually show me that the
machine doesn't in fact have=20

> There are also, as you see above, 128 conntrack entries without a
> state, which by the look of it, are UDP connections.  I'm not even
> natting anything for UDP.  WTF is going on here?

What do you mean 'without state'? There are no connections without
state.  Why can't you show me the respective lines from
/proc/net/ip_conntrack.

And why are you under the impression that /proc/net/ip_conntrack shows
only nat'ed connections?  The name of the file indicates 'conntrack', so
it shows you all tracked connections - not all NAT'ed.

As of now, it seems to me that there are some significant
misunderstandings about the principles of netfilter/iptables. Please
discuss this at the mailinglist and get back to me if you are really
sure this is a bug.

> PreZ
> Systems Administrator
> Shadow Realm
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+17PTXaXGVTD0i/8RAkrNAJ42hl1/3BDpYAyVLu1CUhN9rMn2SgCglv4g
rFcijH9lOcF8T2S0SEiMNfs=
=H4oJ
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
