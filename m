From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: bugs in ftp conntrack
Date: Sat, 26 May 2007 05:28:52 +0200
Message-ID: <1180150132.304.21.camel@henriknordstrom.net>
References: <380055457.11873@tsinghua.org.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-8f1/fB81kiCWnFFeDaGR"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <380055457.11873@tsinghua.org.cn>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-8f1/fB81kiCWnFFeDaGR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

fre 2007-05-25 klockan 09:10 +0800 skrev YU, Haitao:

> I think if it's possible that we don't record the new seqence of too new =
packets.
> "Too new packets" means the sequence of the packet is greater than all
> seq_aft_nl[] values.  We just wait until another "port", "227", etc. pack=
et is
> parsed correctly.

The best (save for doing a full TCP stream reassembly or proxying) would
be to drop such out-of-order packets, relying on the sender to
retransmit them later..  Might result in quite inefficient
communication, but will make the protocol parsing behave correctly.

Regards
Henrik

--=-8f1/fB81kiCWnFFeDaGR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlepcUNPQ5Kbx8daAQJ48gQAhC1VoHzj7A5ozSGsGy57jBYjijB7HwfX
FJNpYNdWV2Eg9Hp4lo4VYItvuCe8yNHsb4L4S7OhRfzDGl7qeql0andcwWHPW5mH
+HvKapNY/JW3ZwSu/6XcUfS8gU+stopi/5EX7CZhhnclcWxjJ1rOhoiNzawtlThg
G+0bZtuw0pU=
=cS5C
-----END PGP SIGNATURE-----

--=-8f1/fB81kiCWnFFeDaGR--
