From: =?iso-8859-2?q?Micha=B3_Margula?= <alchemyx@uznam.net.pl>
Subject: iptables bug
Date: Mon, 15 Mar 2004 12:24:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403151224.10441.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
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

Hello!

	In snapshot of 1.2.9 from 20040314, in file extensions/libipt_dstlimit.c o=
n=20
line 298 there is a typo - should be=20

        if (r->cfg.gc_interval !=3D IPT_DSTLIMIT_GCINTERVAL)

and now is IPT_DSTLIMIT_GCINTEVAL ;].

=2D-=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
