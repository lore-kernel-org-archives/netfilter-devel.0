From: Guy Martin <gmsoft@tuxicoman.be>
Subject: [PATCH] fxp support for ip_conntrack_ftp.c
Date: Tue, 20 Dec 2005 14:13:15 +0100
Message-ID: <20051220141315.44643c09.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="Multipart=_Tue__20_Dec_2005_14_13_15_+0100_hVGyd60MozT3fAFH"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__20_Dec_2005_14_13_15_+0100_hVGyd60MozT3fAFH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi netfilter hackers,

This patch enables you to allow so called FXP transfer by allowing connection from a different source address than the one which initiated the transfer.

To enable, simply modprobe ip_conntrack_ftp fxp=1.


Cheers,
  Guy

--Multipart=_Tue__20_Dec_2005_14_13_15_+0100_hVGyd60MozT3fAFH
Content-Type: text/x-patch;
 name="ip_conntrack_ftp-fxp-support.diff"
Content-Disposition: attachment; filename="ip_conntrack_ftp-fxp-support.diff"
Content-Transfer-Encoding: 7bit

--- ip_conntrack_ftp.c.orig	2005-10-22 12:17:51.200359000 +0200
+++ ip_conntrack_ftp.c	2005-12-01 19:53:12.567374000 +0100
@@ -36,6 +36,9 @@
 static int loose;
 module_param(loose, int, 0600);
 
+static int fxp;
+module_param(fxp, int, 0600);
+
 unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
 				enum ip_ct_ftp_type type,
@@ -416,9 +419,20 @@
 	exp->tuple.dst.u.tcp.port = htons(array[4] << 8 | array[5]);
 	exp->tuple.src.u.tcp.port = 0; /* Don't care. */
 	exp->tuple.dst.protonum = IPPROTO_TCP;
-	exp->mask = ((struct ip_conntrack_tuple)
-		{ { 0xFFFFFFFF, { 0 } },
-		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+	if (!fxp) {
+		exp->mask = ((struct ip_conntrack_tuple)
+			{ { 0, { 0 } },
+			{ 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+		DEBUGP("conntrack_ftp: FXP Mode, relate from: anywhere to: %u.%u.%u.%u:%u\n",
+			array[0], array[1], array[2], array[3], (array[4] << 8 | array[5]));
+	} else {
+		exp->mask = ((struct ip_conntrack_tuple)
+			{ { 0xFFFFFFFF, { 0 } },
+			  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+		DEBUGP("conntrack_ftp: relate from: %u.%u.%u.%u to %u.%u.%u.%u:%u\n",
+			NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+			array[0], array[1], array[2], array[3], (array[4] << 8 | array[5]));
+	}
 
 	exp->expectfn = NULL;
 

--Multipart=_Tue__20_Dec_2005_14_13_15_+0100_hVGyd60MozT3fAFH--
