From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables and SPI...
Date: Sun, 2 Nov 2003 16:06:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031102150623.GX1536@sunbeam.de.gnumonks.org>
References: <Law10-F126ORH9HWP5R0002a333@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vS2hnRoLMmJ4tslQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dimitri borjac <dimitri_borjac@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Law10-F126ORH9HWP5R0002a333@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vS2hnRoLMmJ4tslQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2003 at 03:32:46PM +0000, dimitri borjac wrote:
> what i'm trying to do is to perform NAT based on IP_addresses/Ports/SPIs.
>=20
> The situation would be different users NATted by a common local gateway=
=20
> (all the users are located on the same private network), making each one =
an=20
> IPsec tunnel (using ESP) to the same remote gateway.
>=20
> The different tunnels start from each user, go through the local gateway=
=20
> (which NATts the users) and end at the remote gateway.

ok, so we are talking about=20

- NAT'ing the IKE connection on port 500
and=20
- NAT'ing the AH/ESP connection that is proto AH or ESP and has no port
  but just the SPI.

Basically what you are asking for, is ip_conntrack_{proto,nat}_{ah,esp}.c

> The problem for the local gateway is to NAT the different VPN, based on t=
he=20
> private IP adresses of the users, the ports used (port 50 for ESP...) and=
=20
> the SPIs (in order to distinguish the different tunnels).

it's l4 protocol 50, not port 50.

> The problem is not for the chosen ipsec implementation since the local=20
> gateway only NATts and forwards the ispec packets.=20

oh yes, with standard ipsec you will run into problems.  IPsec does
generally NOT work across NAT boxes, unless you use the UDP
encapsulation mechanism.  Please try to read some general information
about IPsec and NAT.

> But with the current version of iptables, is it possible for the local
> gateway to perform NAT based on the SPIs (and @IP and ports...) ?  (i
> saw that extracting the SPI from the ESP header is possible thx to
> last p-o-m... but NAT with it ?)

no, however it is easy to implement.  The problem is 'just' that it
still wouldn't work because of IPsec's shortcomings wrt. NAT.

> Regards,
> dimo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vS2hnRoLMmJ4tslQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pR1vXaXGVTD0i/8RAoZLAKCycO7MFZfEhomR6upW89zBus/5rQCglTAa
G31vYhk+ifhqYfZb9x8t4Bw=
=GgCk
-----END PGP SIGNATURE-----

--vS2hnRoLMmJ4tslQ--
