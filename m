From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Subject: Re: [PATCH 2.4/2.5]
Date: 29 Jun 2003 15:37:46 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056915465.9614.59.camel@pc>
References: <1056913883.1068.70.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V2XdYOphoWIQG+jx5cpD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
In-Reply-To: <1056913883.1068.70.camel@exile>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-V2XdYOphoWIQG+jx5cpD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2003-06-29 at 15:11, Filip Sneppe (Cronos) wrote:
> Hi Brian,
>=20
> Are you ok with the following two patches? They allow for the
> amanda conntrack/nat modules to track up to 8 ports - it has
> more or less become a common practice for most conntrack/nat
> helpers in the kernel.

In what scenario would there be a need for multiple ports?  The
connection is initiated from the Amanda "server" to the clients.  It's
the clients that listen on port 10080, and it's the connection from the
server to the clients that is watched for, natted and conntracked.

I am having a hard time thinking of a scenario where a client would want
to listen on a port other than it's default and/or listen on multiple
ports for commands from the backup server.

The patch (the 2.4 one anyway) looks syntactically correct.  It's just
the need for it that I am not quite seeing.

b.

--=20
Brian J. Murrell <netfilter@interlinx.bc.ca>

--=-V2XdYOphoWIQG+jx5cpD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA+/0AJl3EQlGLyuXARAljBAKDWt5HdRRL8RGzeqZZ8hdY8NL69RwCghnbb
YHZyC9OnpUDeSy/LzPxDGh8=
=EBq5
-----END PGP SIGNATURE-----

--=-V2XdYOphoWIQG+jx5cpD--
