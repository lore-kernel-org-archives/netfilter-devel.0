From: Harald Welte <laforge@netfilter.org>
Subject: Re: Why "Connection tracking" decreases performance of netfilter!? any idea ?
Date: Sun, 27 Apr 2003 15:07:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427130738.GH990@sunbeam.de.gnumonks.org>
References: <20030422143455.19432.qmail@web80506.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0NUq3YI6/rBc6tSL"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mahdi Samadi <my_seclab@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030422143455.19432.qmail@web80506.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0NUq3YI6/rBc6tSL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 07:34:55AM -0700, Mahdi Samadi wrote:
> Hello to all
> Dose any know why connection tracking decreases the performance of Linux?

Please stop and think for a minute.  You are trying to keep track of the
state of two TCP stacks, allocating about 340 bytes of kernel-only
memory and adding significant l3/l4 parsing to every packet - and you
are asking why that decreases performance???

> Is it any way to have both of them? (connection tracking and performance)
> I alse check this situation by changing the value of
> "ip_conntrack_max" to high, but performance is still very bad,Is there
> a configuration for kernel to solve this problem?=20

Pleae read the FAQ and the mailing list archives.  You need to change
the hash bucket number.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0NUq3YI6/rBc6tSL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9YaXaXGVTD0i/8RAsXpAJsGxjHWx0jTVlvNzLXaAKCoBJXs0QCfRF/R
MBQkwM/xMUj7xe6DL1DZW1k=
=iARb
-----END PGP SIGNATURE-----

--0NUq3YI6/rBc6tSL--
