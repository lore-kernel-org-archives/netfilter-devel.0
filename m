From: netfilter@interlinx.bc.ca
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Wed, 26 Feb 2003 18:54:06 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226235405.GA4609@pc.ilinx>
References: <200302262353.h1QNrjC22019@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200302262353.h1QNrjC22019@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2003 at 09:53:45AM +1100, Ian Latter wrote:
>=20
> ahhh .. Brian ;-)  Didn't see your sig b4 ...

S'ok.  It was funny.

> Instead of relying on outgoing connections to maintain the live session,
> leave that out for the time being, and set up an untimed inbound expectat=
ion.

But unless I am mistaken, inbound expectations have to be related to
an ESTABLISHED connection.  That is fine, except as soon as the
ESTABLISHED connection goes away so does it's expectation(s).  With the
nature of P2P like Gnutella, connections come and go like the wind.

That is why the expectation (which is the same for every outgoing and
incoming connection) needs to be refreshed with new master
connections.

> s'cool ... let one out set it off ... and the ins can look after themselv=
es ...

Right.  I do refresh the expecation for every outbound connection, but
need to refresh on inbound connections as well as outbound connections
can be few and far between once the client has made it's presence
known.

> Whenever your "end condition" occurs for the client ... then unload all
> of the open expectations ....

Well, the expectation (there is only one, it's the same expectation
for all masters everybody:allports->client:localport) goes away when
it times out or the master connection goes away.  That is clean enough
for me.

> so ... a or b rings true, then trash the open
> expects ..

It's just cleaner to let the framework do that for me.

> Even if there's nothing in the payload ... if the NAT has been a masq or
> some other non ip-to-ip mapping, then the helper will need to rewrite the
> ip headers ...

Right.  I am already doing that.  I do alter the payload in the
outgoing connection if needed -- although with gtk-gnutella, it somehow
determines the outside address of the iptables box so technically it's
not needed.

> this had to be done in rsh .. which works like ftp ... one
> out with a port in the proto for where a new one should come back ..
> this then hits the firewall (tables) as a local port, which then needs to
> be re-written.

Right.  That I am doing already as well.  I have successfully run two
different clients behind my modules and they both work (while both are
using the same local port), so I must be doing something right.  :-)

> I don't see your proto as being tremendously different from ftp ... 'cept
> that the data sessions can be many+ and they can come from
> the universe and not the master destination ...  should be pretty straight
> forward ...

'Tis really.  In my original message, I think I said it was 99%
working and thought I had to use a hack to get it to work when indeed
my hack was (close to) the right solution.  I based heavily on the ftp
and/or irc modules.

b.

--=20
Brian J. Murrell

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+XVOdl3EQlGLyuXARApV/AKDFB8/NBrwQU00AnrD0hcVgw0GTRwCeIiu8
LMlGFQ5uFIHxcqF9+waF5rM=
=n2cN
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
