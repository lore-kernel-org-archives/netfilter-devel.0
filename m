From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: [PATCH] ipt_time: module revision fixup
Date: Thu, 6 Jan 2005 21:21:17 -0500
Message-ID: <20050107022117.GB26992@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Fabrice MARIE <fabrice@netfilter.org>
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

Use C99 initializers to allow for new match revision field.
Update function parameter list to match the corresponding function prototype.

Signed-off-by: Bill Rugolsky <brugolsky@telemetry-investments.com>

--- patch-o-matic-ng/time/linux/net/ipv4/netfilter/ipt_time.c.revision	2004-11-24 10:19:15.000000000 -0500
+++ patch-o-matic-ng/time/linux/net/ipv4/netfilter/ipt_time.c	2005-01-06 20:36:30.000000000 -0500
@@ -48,8 +48,6 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
       int *hotdrop)
 {
 	const struct ipt_time_info *info = matchinfo;   /* match info for rule */
@@ -124,8 +122,12 @@
 	return 1;
 }
 
-static struct ipt_match time_match
-= { { NULL, NULL }, "time", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match time_match = {
+	.name = "time",
+	.match = &match,
+	.checkentry = &checkentry,
+	.me = THIS_MODULE
+};
 
 static int __init init(void)
 {
