From: Harald Welte <laforge@sunbeam.franken.de>
Subject: Re: [PATCH]: make libipt_mark/connmark work with iptables-save/restore
Date: Fri, 20 Sep 2002 17:02:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920170228.I3810@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0209171556190.23114-100000@the.brain.uni-freiburg.de>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@the.brain.uni-freiburg.de>
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <Pine.LNX.4.44.0209171556190.23114-100000@the.brain.uni-freiburg.de>; from kaber@the.brain.uni-freiburg.de on Tue, Sep 17, 2002 at 03:57:49PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Tue, Sep 17, 2002 at 03:57:49PM +0200, Patrick McHardy wrote:
> 
> Hi.
> The attached patch makes libipt_mark and libipt_connmark work with
> iptables-save/restore. I couldn't figure out how to make a pure userspace
> patch, but maybe you don't want to put it into patch-o-matic but apply
> directly.

Stuff which only touches userspace should never be in patch-o-matic. 
Patch-o-matic is for kernel stuff.

> Bye,
> Patrick

- -- 
Live long and prosper
- - Harald Welte / laforge@sunbeam.franken.de   http://www.sunbeam.franken.de/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9iziEXaXGVTD0i/8RAn8QAKCDc+ZKMWmBiD4XCfDNohR+o2vMEwCfbsmC
oOY0hWIAZhE32JSoITWoAq0=
=9ij3
-----END PGP SIGNATURE-----
