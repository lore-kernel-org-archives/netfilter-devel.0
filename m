From: Abraham vd Merwe <abraham@2d3d.co.za>
Subject: questions about netfilter/iptables api
Date: Tue, 9 Jul 2002 16:44:02 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020709164402.A6622@crystal.2d3d.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I'm trying to figure out how to prepend rules into the INPUT/OUTPUT chains.
The way I see it, you do

1. getsockopt IPT_SO_GET_INFO and IPT_SO_GET_ENTRIES to get current entries
in chain.

2. construct a ``struct ipt_entry'' with the new rule.

3. construct a ``struct ipt_replace'' entry with new entry + old entries.

4. do setsockopt IPT_SO_SET_REPLACE to insert new entry in the chain.

Now, what I can't figure out is what those hook_entry and underflow arrays
in ``struct ipt_replace'' are used for and what offsets I need to put in th=
em.

Also, I see that iptables goes and appends elems entries for some of the
struct ipt_entry entries. When do I need to do that and is it necessary for
simple rules like these:

-I INPUT -d net/mask -i eth0
-I OUTPUT -s net/mask -o eth1
-I INPUT -d net/mask -p tcp --source-port 23 -i eth0
etc.

I don't see why any additional info would be necessary since you can fit all
that info in the the ``struct ipt_ip'' field.

PS: Please CC me when replying. I'm not subscribed to the list.

--=20

Regards
 Abraham

Well, O.K.  I'll compromise with my principles because of EXISTENTIAL DESPA=
IR!

__________________________________________________________
 Abraham vd Merwe - 2d3D, Inc.

 Device Driver Development, Outsourcing, Embedded Systems

  Cell: +27 82 565 4451         Snailmail:
   Tel: +27 21 761 7549            Block C, Aintree Park
   Fax: +27 21 761 7648            Doncaster Road
 Email: abraham@2d3d.co.za         Kenilworth, 7700
  Http: http://www.2d3d.com        South Africa


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.4 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9KvayzNXhP0RCUqMRAkDMAJ0TKjTPs9t9ms6JZmIc7XXE4BKCAgCcDkgp
I4nhuelHz/y+5ubfA4DQFLI=
=9Upl
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
