From: Harald Welte <laforge@netfilter.org>
Subject: Re: access skb from conntrack helper?
Date: Fri, 28 Feb 2003 16:58:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030228155844.GA1976@naboo.de.gnumonks.org>
References: <200302272358.h1RNwlq23691@lightforge.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gong Su <gongsu@cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <200302272358.h1RNwlq23691@lightforge.cs.columbia.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2003 at 06:58:46PM -0500, Gong Su wrote:
> I'd like to be able to track, for each conntrack record satisfying certain
> condition, some higher layer info such as the socket from which the packe=
ts
> are being sent, etc. Unfortunately, only the packet header, not the skb, =
is
> passed to conntrack helpers. Is there any way for a conntrack helper to
> get access to the skb when it's called? Thank you.

I don't really see a reason why this couldn't be changed.  I have no
problem with changing the first argument of struct
ip_conntrack_helper.help from 'struct iphdr *' to 'struct sk_buff *'.

If you provide me with a patch for 2.4.21-pre4 (and maybe even for all
helpers in patch-o-matic), I'm happy to merge it into the kernel.

> --=20
> /Gong

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+X4c0XaXGVTD0i/8RAtyKAJ435C5V/RGB9Ex1NUUlQJ4j4AM6YgCbB04l
VhqHda/yZ7d7mI9K+a0j3Mk=
=pZ99
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
