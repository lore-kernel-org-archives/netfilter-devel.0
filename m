From: Harald Welte <laforge@netfilter.org>
Subject: Re: Can iptables do this?
Date: Fri, 13 Jun 2003 17:17:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030613151719.GD32593@sunbeam.de.gnumonks.org>
References: <see89d65.074@gwia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnnalMW64b1v2e1G"
Cc: jon_webb@binary-one.com, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wei Ming Long <WEI_Ming_Long@dsi.a-star.edu.sg>
Content-Disposition: inline
In-Reply-To: <see89d65.074@gwia>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MnnalMW64b1v2e1G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2003 at 03:33:45PM +0800, Wei Ming Long wrote:
> Correct me if I'm wrong, when the laptop with the preconfigured static ip
> comes into the network, it will do a arp broadcast to find the mac addres=
s of
> it's gateway, so can iptables capture this arp packet (at the same time r=
eply
> to this arp request),=20

iptables is called 'ip'tables, because it deals with IP packets.  So
iptables will never see any arp packets.

> extract the mac address and keep this in a table so that the next time
> this same laptop sends a http request packet out onto the
> network, the mac address in the packet header is extracted & mapped to the
> private ip address before resending this same http request packet out int=
o the
> internet cloud.=20

yes, but this is a total ugly layering violation.  And connection
tracking doesn't care about mac addresses, but about IP addresses.=20

Apart from that, it starts with broadcasts... the client will make
assumptions about the broadcast address of that network segment that
arne't true.  You will somehow need to convince the IP stack of your
gateway to reply to all linklayer ARP broadcasts, not just Arp requests
with the correct bcast address of that segment.

And don't even start to think about multicasting in that case...

> When the http reply packet comes back, iptables will look up
> the mac address <--> private ip table and then send this reply packet bac=
k to
> the laptop.=20
>=20
> Is this all possible? or is it possible to add code to netfilter to achie=
ve
> this? I'm prepared to write code to netfilter to do this if not already
> possible but just want to make sure that this feature or functionality is=
 not
> already present so that I don't have to do redundant job.

No, this has not been implemented yet, and I don't think that we want to
have such functionality in the official kernel.  Feel free to write it
as a netfilter module, though :)

> Thanks
> Matthew
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MnnalMW64b1v2e1G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+6er/XaXGVTD0i/8RAro7AJ4z+OeUA7bRYzpIev5ebHYbTfEduQCfQQ6Y
IMMMvzP8gllXjnXlLtobFsc=
=jY8/
-----END PGP SIGNATURE-----

--MnnalMW64b1v2e1G--
