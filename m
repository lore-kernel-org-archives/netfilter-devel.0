From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT question on holding back a port
Date: Thu, 19 Aug 2004 12:06:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819100619.GB3921@sunbeam.de.gnumonks.org>
References: <04EE7AD0450F7B498BA216312943A1A11555CE@blrse201.ap.infineon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gPQW1Pk7T/0rhUBV"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Atanu.Mondal@infineon.com
Content-Disposition: inline
In-Reply-To: <04EE7AD0450F7B498BA216312943A1A11555CE@blrse201.ap.infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gPQW1Pk7T/0rhUBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 18, 2004 at 03:38:09PM +0530, Atanu.Mondal@infineon.com wrote:
> Hi All,
> I have a unique requirement.. I am writing a SIP ALG and am facing with
> the following situation.

Are you aware that somebody else (forgot his name, please look in the
list archives) is already working on a SIP conntrack/nat ALG for
netfilter/iptables

> The local Lan SIP phone sends a registration message and along with it ,
> its own contact port number. This gets SRC natted and the SIP ALG
> changes
> the Lan contact address and contact port to a Firewall global address
> and contact port... A DNAT rule also get added dynamically on this
> global address and contact port so that any WAN phone calling on this
> global address and contact port will get DNAT ed to the lan SIP phone.

you don't add rules in such a case but 'raise expectations'.  Please
read the numerous other NAT helpers available in patch-o-matic-ng.

> Now any phone on the WAN can connect the lan phone by calling on this
> contact address and contact port.
> =20
> My problem arises from the part that if the conntrack created by the
> Registration message goes off, and any other application is given that
> global port(NAT checks only for unique tuple match to assign port)..

I don't really see how this would happen if you raise an expectation
with unspecified source port/ip.

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

--gPQW1Pk7T/0rhUBV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJHubXaXGVTD0i/8RAgs5AKCeVThaL8ngBlqsRkNr6c6DjJoQLwCcCfbQ
1uWzzxsqs1yBKAweCyAtCsg=
=Wsmf
-----END PGP SIGNATURE-----

--gPQW1Pk7T/0rhUBV--
