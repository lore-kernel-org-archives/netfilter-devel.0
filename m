From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] trivial netfilter/iptables fixes
Date: Fri, 20 Sep 2002 17:19:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920171920.O3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline; filename="msg.pgp"
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

Hi Dave!

I'm not submitting those patches seperately, since they are all small trivial
fixes.

changelog:
	- fix module usage counting for ip6_tables.o
	- make ipt_ULOG compile on SPARC
	- fix to experimental ipt_unclean match (it considers udp w/out csum
	  unclean)

Please apply, thanks.

- --- linux.old/net/ipv6/netfilter/ip6_tables.c.old	Sun Sep 15 13:12:13 2002
+++ linux/net/ipv6/netfilter/ip6_tables.c	Sun Sep 15 13:12:48 2002
@@ -1469,6 +1469,9 @@
 	duprintf("table->private->number = %u\n",
 		 table->private->number);
 
+	/* save number of initial entries */
+	table->private->initial_entries = table->private->number;
+
 	table->lock = RW_LOCK_UNLOCKED;
 	list_prepend(&ip6t_tables, table);
 
- --- linux-2.4.20-pre7/net/ipv4/netfilter/ipt_ULOG.c.orig	2002-09-16 15:24:21.000000000 -0400
+++ linux-2.4.20-pre7/net/ipv4/netfilter/ipt_ULOG.c	2002-09-16 15:23:58.000000000 -0400
@@ -50,7 +50,7 @@
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
 #include <net/sock.h>
- -#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");

- --- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:22:57.000000000 +0200
@@ -211,7 +211,7 @@
 
 	/* Bad checksum?  Don't print, just say it's unclean. */
 	/* FIXME: SRC ROUTE packets won't match checksum --RR */
- -	if (!more_frags && !embedded
+	if (!more_frags && !embedded && udph->check
 	    && csum_tcpudp_magic(iph->saddr, iph->daddr, datalen, IPPROTO_UDP,
 				 csum_partial((char *)udph, datalen, 0)) != 0)
 		return 0;


- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9izx3XaXGVTD0i/8RAr4vAKCB+sTYFteElDY9HoDWaUrMdoJbagCgs8cW
KQcrGDwlW6Hz9JS1upecik8=
=NhvX
-----END PGP SIGNATURE-----
