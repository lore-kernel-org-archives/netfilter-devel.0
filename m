From: Harald Welte <laforge@gnumonks.org>
Subject: Re: tos 0x62
Date: Fri, 20 Sep 2002 17:01:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920170100.H3810@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0209171317130.6328-100000@webdev.ines.ro>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrei Ivanov <andrei.ivanov@ines.ro>
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <Pine.LNX.4.44.0209171317130.6328-100000@webdev.ines.ro>; from andrei.ivanov@ines.ro on Tue, Sep 17, 2002 at 01:22:48PM +0300
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

On Tue, Sep 17, 2002 at 01:22:48PM +0300, Andrei Ivanov wrote:
> 
> Hello,
> I'm trying to filter packets which have a TOS value of 0x62, and it seems
> I cannot.

because it's an invalid TOS value.

> I tried the tos module, but it only knows valid tos values.

right.

> I looked for the ftos module from patch-o-matic, but it seems it has been
> obsoleted by DSCP and ECN module.

yes. they also only accept allowed combinations of the bit.

- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9izgsXaXGVTD0i/8RAiPqAJ4oml9PvP1LNV/nnu9+Xhg8OJhSqQCfdG24
ceKiBU0A7cqmceCAqmcrGLk=
=XY5H
-----END PGP SIGNATURE-----
