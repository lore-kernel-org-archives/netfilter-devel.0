From: Harald Welte <laforge@gnumonks.org>
Subject: Re: '-m owner' problem (bug?)
Date: Fri, 20 Sep 2002 17:05:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920170513.L3810@sunbeam.de.gnumonks.org>
References: <20020918170408.GA12455@callisto.yi.org>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dan Aloni <da-x@gmx.net>
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <20020918170408.GA12455@callisto.yi.org>; from da-x@gmx.net on Wed, Sep 18, 2002 at 08:04:08PM +0300
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

On Wed, Sep 18, 2002 at 08:04:08PM +0300, Dan Aloni wrote:
> (not subscribed to the list, please CC)
> 
> This command used to work in the past:
> 
>    iptables -A OUTPUT -o eth1 -m owner --uid-owner 0 -d 192.168.1.6/32 -j
>    ACCEPT

can you try to recompile the latest iptables package (1.2.7a) and see if
the problem persists?

This is not supposed to be the solution, I just want to know where the 
problem comes from...

> Dan Aloni

- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9izkoXaXGVTD0i/8RAhBoAKCpLlejJbeBKGqogK5fnW2TRSRzagCdE7QN
aAm61D0AfshHaM+I1WLAlmQ=
=p35l
-----END PGP SIGNATURE-----
