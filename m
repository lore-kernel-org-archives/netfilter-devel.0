From: Guillaume Morin <guillaume@morinfr.org>
Subject: [PATCH] ipt_unclean.c:  fix for UDP zero source port check
Date: Sat, 12 Oct 2002 01:08:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021011230813.GA5516@morinfr.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EuxKj2iCbKjpUGkD"
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


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

RFC768 allows the source port of an UDP packet to be zero. Currently,
the unclean match reports such a packet as unclean. This is bogus. Here
is the patch which fixes that :

--- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-10-12 00:56:09.000000000 +0200
@@ -216,10 +216,9 @@
 				 csum_partial((char *)udph, datalen, 0)) != 0)
 		return 0;
 
-	/* CHECK: Ports can't be zero. */
-	if (!udph->source || !udph->dest) {
-		limpk("UDP zero ports %u/%u\n",
-		      ntohs(udph->source), ntohs(udph->dest));
+	/* CHECK: Destination port can't be zero. */
+	if (!udph->dest) {
+		limpk("UDP zero destination port\n");
 		return 0;
 	}


Regards,

-- 
Guillaume Morin <guillaume@morinfr.org>

       Unwisely, Santa offered a teddy bear to James, unaware that he had
             been mauled by a grizzly earlier that year (T. Burton)

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=unclean_fix2

--- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-10-12 00:56:09.000000000 +0200
@@ -216,10 +216,9 @@
 				 csum_partial((char *)udph, datalen, 0)) != 0)
 		return 0;
 
-	/* CHECK: Ports can't be zero. */
-	if (!udph->source || !udph->dest) {
-		limpk("UDP zero ports %u/%u\n",
-		      ntohs(udph->source), ntohs(udph->dest));
+	/* CHECK: Destination port can't be zero. */
+	if (!udph->dest) {
+		limpk("UDP zero destination port\n");
 		return 0;
 	}
 

--EuxKj2iCbKjpUGkD--
