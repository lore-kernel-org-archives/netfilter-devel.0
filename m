From: Guillaume Morin <guillaume@morinfr.org>
Subject: [PATCH] fix unclean udp checksum check
Date: Tue, 10 Sep 2002 16:33:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020910143343.GA22297@morinfr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi folk,

unclean does not handle udp packets with a null checksum, altough udp
checksums are not mandatory.

Here is the (trivial) patch which fixes that :

diff -uNr linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c linux/net/ipv4/netfilter/ipt_unclean.c
--- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:22:57.000000000 +0200
@@ -211,7 +211,7 @@
 
 	/* Bad checksum?  Don't print, just say it's unclean. */
 	/* FIXME: SRC ROUTE packets won't match checksum --RR */
-	if (!more_frags && !embedded
+	if (!more_frags && !embedded && udph->check
 	    && csum_tcpudp_magic(iph->saddr, iph->daddr, datalen, IPPROTO_UDP,
 				 csum_partial((char *)udph, datalen, 0)) != 0)
 		return 0;

Please apply.

Regards,

-- 
Guillaume Morin <guillaume@morinfr.org>

              Linux is user friendly. Linux is not idiot friendly
             If you don't understand that, use Windows (Anonymous)
