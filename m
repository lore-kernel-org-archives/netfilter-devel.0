From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH, TRIVIAL] remove more memsets
Date: Sun, 29 Jun 2003 21:43:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EFF4176.8030704@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000708000203020709000608"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000708000203020709000608
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
these patches (2.4 and 2.5) removes the remaining unnecessary memsets.
Best regards,
Patrick

--------------000708000203020709000608
Content-Type: text/plain;
 name="nf-more-memsets-2.4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-more-memsets-2.4.diff"

===== net/ipv4/netfilter/ip_conntrack_amanda.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ip_conntrack_amanda.c	Mon Apr 28 03:52:54 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_amanda.c	Sun Jun 29 21:30:43 2003
@@ -205,7 +205,6 @@
 {
 	int ret;
 
-	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
 	amanda_helper.tuple.src.u.udp.port = htons(10080);
 	amanda_helper.tuple.dst.protonum = IPPROTO_UDP;
 	amanda_helper.mask.src.u.udp.port = 0xFFFF;
===== net/ipv4/netfilter/ip_conntrack_tftp.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ip_conntrack_tftp.c	Mon Mar 31 17:08:21 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_tftp.c	Sun Jun 29 21:31:10 2003
@@ -94,8 +94,6 @@
 
 	for (i = 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
 		/* Create helper structure */
-		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
-
 		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
 		tftp[i].mask.dst.protonum = 0xFFFF;
===== net/ipv4/netfilter/ip_nat_amanda.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ip_nat_amanda.c	Wed Jun 25 00:16:00 2003
+++ edited/net/ipv4/netfilter/ip_nat_amanda.c	Sun Jun 29 21:31:40 2003
@@ -195,8 +195,6 @@
 	struct ip_nat_helper *hlpr;
 
 	hlpr = &ip_nat_amanda_helper;
-	memset(hlpr, 0, sizeof(struct ip_nat_helper));
-
 	hlpr->tuple.dst.protonum = IPPROTO_UDP;
 	hlpr->tuple.src.u.udp.port = htons(10080);
 	hlpr->mask.src.u.udp.port = 0xFFFF;
===== net/ipv4/netfilter/ip_nat_tftp.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ip_nat_tftp.c	Mon Mar 31 17:08:21 2003
+++ edited/net/ipv4/netfilter/ip_nat_tftp.c	Sun Jun 29 21:31:53 2003
@@ -160,8 +160,6 @@
 		ports[0] = TFTP_PORT;
 
 	for (i = 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
-		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
-
 		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
 		tftp[i].mask.dst.protonum = 0xFFFF;

--------------000708000203020709000608
Content-Type: text/plain;
 name="nf-more-memsets-2.5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-more-memsets-2.5.diff"

===== net/ipv4/netfilter/ip_conntrack_tftp.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ip_conntrack_tftp.c	Fri May 23 09:53:22 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_tftp.c	Sun Jun 29 21:38:52 2003
@@ -97,8 +97,6 @@
 
 	for (i = 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
 		/* Create helper structure */
-		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
-
 		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
 		tftp[i].mask.dst.protonum = 0xFFFF;
===== net/ipv4/netfilter/ip_nat_amanda.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ip_nat_amanda.c	Wed Jun 25 00:34:39 2003
+++ edited/net/ipv4/netfilter/ip_nat_amanda.c	Sun Jun 29 21:38:53 2003
@@ -195,8 +195,6 @@
 	struct ip_nat_helper *hlpr;
 
 	hlpr = &ip_nat_amanda_helper;
-	memset(hlpr, 0, sizeof(struct ip_nat_helper));
-
 	hlpr->tuple.dst.protonum = IPPROTO_UDP;
 	hlpr->tuple.src.u.udp.port = htons(10080);
 	hlpr->mask.src.u.udp.port = 0xFFFF;
===== net/ipv4/netfilter/ip_nat_tftp.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ip_nat_tftp.c	Tue May  6 10:04:01 2003
+++ edited/net/ipv4/netfilter/ip_nat_tftp.c	Sun Jun 29 21:38:53 2003
@@ -164,8 +164,6 @@
 		ports[0] = TFTP_PORT;
 
 	for (i = 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
-		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
-
 		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
 		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
 		tftp[i].mask.dst.protonum = 0xFFFF;

--------------000708000203020709000608--
