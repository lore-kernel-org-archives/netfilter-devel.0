From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT question on holding back a port
Date: Thu, 19 Aug 2004 13:59:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819115902.GT3921@sunbeam.de.gnumonks.org>
References: <04EE7AD0450F7B498BA216312943A1A11555D0@blrse201.ap.infineon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FvI60RJo/OoThODE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Atanu.Mondal@infineon.com
Content-Disposition: inline
In-Reply-To: <04EE7AD0450F7B498BA216312943A1A11555D0@blrse201.ap.infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FvI60RJo/OoThODE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 2004 at 04:17:36PM +0530, Atanu.Mondal@infineon.com wrote:
> Hi Harald,
> Thank you for the reply. Yes I do understand that I can raise
> expectation to open up the port, but problem is that
> the unsuccesful expectation die down when the master conntract dies
> down.. Here in the SIP registration case.. the master
> conntrack gets built with REGISTRATION message and the next registration
> message will only come after the expiry period agreed
> by the SIP registrar and the client.. which is normally much longer than
> the default time for a UDP conntrack. Now once that
> conntrack dies down, so does the unsuccesful expectation(which is meant
> for an INVITE(phone call) message from the WAN side). So this
> design won't hold very good.=20

You then have to increase the timeout fo this UDP conntrack to make sure
it exists as long as any INVITE messages could arrive.

It's been some time since I last looked into SIP.  Do you get something
like an UNREGISTER message after which you can be sure not to expect any
more INVITE's ? =20

Also, if the to SIP parties agree on a timeout, why not use this timeout
for the UDP master connection?

> Also another problem is that .. we are opening up the firewall port for
> the RTP RTCP only after checking the SIP messages.So right=20
> now the master conntrack get built on getting an INVITE message and then
> the expectation is built for the RTP, RTCP messages.. which
> immediately follows and the expectation gets hit. If we are opening up a
> master connection based on the Registration message and then
> INVITE comes over an expectation.. then for RTP, RTCP we need to build
> another expectation of the child conntrack(build by the INVITE).
> Currently a two tier design is supported in iptable I beleive.. and no
> way I can have a 2nd level of expectation.

Oh yes, you can have.  Look at H.323 helper.  An expectation (causeed by
REGISTRATION) that is confirmed (by INVITE) has it's own conntrack that
can in turn have it's own expectations (RTP/RTCP).  There's no
limitation on the complexity of the connection relationship graph ;)

I'm looking forward to seeing your code :)

> Regards
> Atanu Mondal
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FvI60RJo/OoThODE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJJYGXaXGVTD0i/8RApT4AKCk/TlcdVT4qEK1IPk+53TduTXcZwCcD60L
T1R8MjyqLIq5fNwwn+V1Ls8=
=q9Vt
-----END PGP SIGNATURE-----

--FvI60RJo/OoThODE--
