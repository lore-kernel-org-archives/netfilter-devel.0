From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Weight in SAME and SNAT targets?
Date: Thu, 19 Dec 2002 23:17:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021219221710.GL8159@noir.cb.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkHPBKJ2pKcVUM5H"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WkHPBKJ2pKcVUM5H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello dear developers!

According to the documentation, when doing SNAT to multiple IPs, it chooses
the IP with the lowest number of active connections. I assume SAME uses a
similar method as well.

I tried very hard to find the place in the code responsible for this, but
apparently I am blind or my grep is fscked. Could you please kindly direct me
to the file with the code and perhaps even some docs?

I currently use SNAT and SAME to loadbalance over several lines (don't explain
to me it shouldn't be done this way, our provider can't manage to persuade
their cisco to do "normal" loadbalancing so this is the only way that works).
However, soon we'll have lines with different bandwidth, and the current
method would cause suboptimal results (well, I can theoretically use more IPs
per line to do this, this possibility is being investigated). But this
wouldn't be necessary if it was possible to give the IPs different weight. I
don't think coding this is that difficult, but not being able to find the
responsible lines in code is a big showstopper.

Anyway, netfilter rocks, you can do a lot of cool stuff with it.

Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505122023

--
                   Press every key to continue.

--WkHPBKJ2pKcVUM5H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+AkVmzogxsPZwLzcRAp92AJ9Qr1NNRlrexJ3HmArJvkdccp4BeACgjGXm
wiIarqAE7+uqT9vFhzmXc4o=
=sGCd
-----END PGP SIGNATURE-----

--WkHPBKJ2pKcVUM5H--
