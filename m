From: Andreas Hess <hess@tkn.tu-berlin.de>
Subject: Netfilter Queue
Date: Mon, 2 Feb 2004 12:08:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402021208.29583.hess@tkn.tu-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Description: clearsigned data
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

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I have written a UDP packet processing kernel module that registers itself =
to=20
the PREROUTING hook of the Netfilter architecture. Now, each UDP packet tha=
t=20
arrives at this hook is passed  to my module.=20
And this is the point!
What exactly does this mean?
As far as I understand it: there are module-specific queues, in which the=20
packets are inserted?
If so, is there a possibility to influence the lengths of these queues?

I would like to realize a means to adapt the queue length respectively the=
=20
amount of packets waiting to be processed by a module according the current=
=20
traffic load. (high traffic load -> short queue length).

Is such a thing possible?

Thanks muchly for your time

Andreas
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAHi+r68eBr8WIgcgRApAfAJ49XWvaqKUA5Grc+Xm9XufnN+NKdACgiSMd
X1aJF7qTk8PmtW5Wb/Y1t74=3D
=3DWkb1
=2D----END PGP SIGNATURE-----
