From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] DNAT/SNAT port range must use dash
Date: Sun, 16 Jan 2005 16:33:25 -0800
Message-ID: <20050117003325.GA1067@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

John McCann points out via bugzilla that iptables happily accepts this
syntax on DNAT/SNAT:

	--to x.x.x.x:y:z

but doesn't actually make use of the second port.  Clear up the confusion
by only accepting a dash between the ports.

This closes bugzilla #265.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-colons

diff -ru iptables-orig/extensions/libipt_DNAT.c iptables-new/extensions/libipt_DNAT.c
--- iptables-orig/extensions/libipt_DNAT.c	2004-12-28 08:11:59.000000000 -0500
+++ iptables-new/extensions/libipt_DNAT.c	2005-01-16 19:26:29.059808992 -0500
@@ -65,7 +65,7 @@
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
 	struct ip_nat_range range;
-	char *colon, *dash;
+	char *colon, *dash, *error;
 	struct in_addr *ip;
 
 	memset(&range, 0, sizeof(range));
@@ -85,6 +85,11 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", colon+1);
 
+		error = strchr(colon+1, ':');
+		if (error)
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid port:port syntax - use dash\n");
+
 		dash = strchr(colon, '-');
 		if (!dash) {
 			range.min.tcp.port
diff -ru iptables-orig/extensions/libipt_SNAT.c iptables-new/extensions/libipt_SNAT.c
--- iptables-orig/extensions/libipt_SNAT.c	2004-12-28 08:11:59.000000000 -0500
+++ iptables-new/extensions/libipt_SNAT.c	2005-01-16 19:13:42.446351952 -0500
@@ -65,7 +65,7 @@
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
 	struct ip_nat_range range;
-	char *colon, *dash;
+	char *colon, *dash, *error;
 	struct in_addr *ip;
 
 	memset(&range, 0, sizeof(range));
@@ -85,6 +85,11 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", colon+1);
 
+		error = strchr(colon+1, ':');
+		if (error)
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid port:port syntax - use dash\n");
+
 		dash = strchr(colon, '-');
 		if (!dash) {
 			range.min.tcp.port

--4Ckj6UjgE2iN1+kY--
