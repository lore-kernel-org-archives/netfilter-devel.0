From: Harald Welte <laforge@gnumonks.org>
Subject: Re: IPTABLES port forward to port range using DNAT
Date: Sun, 9 Feb 2003 10:38:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209093820.GP13269@naboo.fugue.com>
References: <6BCA929C2000D411BE2800E018C1BB81432ECA@URS01>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ToWwKEyhugL+MAz"
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jesse Lang <jlang@bureauofcollection.com>
Content-Disposition: inline
In-Reply-To: <6BCA929C2000D411BE2800E018C1BB81432ECA@URS01>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9ToWwKEyhugL+MAz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2003 at 02:04:04PM -0600, Jesse Lang wrote:

> Here's the deal:
> I have a proprietary machine that uses one client per port ports available
> are let's say 2000-2299
> Now, I'd like to have iptables do some magic for me where I could connect=
 as
> many clients to a port (ie 2300) on an iptables/linux box and have iptabl=
es
> find the first available port in that range.  I set up forwarding and
> DNAT/SNAT to accomplish this, but iptables seems to always go for the fir=
st
> port 2000, whether it's in use or not.

this is because the port is not 'in use'.  netfilter/iptables implements
the most sophisticated version of NAT (referred to as 'symmetric NAT-PT'
in some ietf documents).  We don't occupy a port number for everry
connection.  the same port number on the NAT address[es] can be used for
multiple connection, as long as the tuple (srcip,srcport,dstip,dstport)
is unique.

> Any help would be appreciated.  Thanks.

I don't see how your goal can be achieved - and to be honest I don't see
why you would want to have a setup like this.  This way of doing port
forwarding (where one port number is used for every connection on the
NAT device) seems a bit 'antique' to me.

> Jesse Lang
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--9ToWwKEyhugL+MAz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+RiGMXaXGVTD0i/8RAmy4AJ9Vs0TgP1lR27pH3MvWJq3/JVgvEACfU6SS
XY3/FFVunO4/JdiOVqekLIo=
=p07k
-----END PGP SIGNATURE-----

--9ToWwKEyhugL+MAz--
