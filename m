From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] netfilter unclean match extension
Date: Tue, 22 Oct 2002 16:40:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022144050.GH3039@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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

Hi Dave!

Below is a non-crucial extension of the ipt_unclean.c module (courtesy
of Maciej Soltysiak).  Inclusion of this patch has time until
2.4.21-preX, no need for this in 2.4.20.

This patch extends unclean's module to match packets with IP unused bit
set.  This bit is the first bit in the fragmentation offset field of the
IP header. 

Exerpt from RFC 791: Various Control Flags.  Bit 0: reserved, must be zero

Checking for this zero-ness of Bit 0 is what the patch adds.

The bit may be used in very discrete OS fingerprinting as described by
Ofir Arkin in "Unverified Fields - A Problem with Firewalls & Firewall
Technology Today" available to read at:
http://www.sys-security.com/archive/papers/Unverified_Fields_1.0.pdf
http://www.sys-security.com/archive/papers/Unverified_Fields_1.0.ps

Please apply, thanks.


diff -Nru linux.orig/net/ipv4/netfilter/ipt_unclean.c linux/net/ipv4/netfilter/ipt_unclean.c
--- linux.orig/net/ipv4/netfilter/ipt_unclean.c	Thu Jan  1 01:00:00 1970
+++ linux/net/ipv4/netfilter/ipt_unclean.c	Tue Jun 11 19:26:11 2002
@@ -522,6 +522,16 @@
 		return 0;
 	}
 
+	/* CHECK: Do not use what is unused.
+	 * First bit of fragmentation flags should be unused.
+	 * May be used by OS fingerprinting tools.
+	 * 04 Jun 2002, Maciej Soltysiak, solt@dns.toxicfilms.tv
+	 */
+	if (ntohs(iph->frag_off)>>15) {
+		limpk("IP unused bit set\n");
+		return 0;
+	}
+
 	/* Per-protocol checks. */
 	switch (iph->protocol) {
 	case IPPROTO_ICMP:
-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
