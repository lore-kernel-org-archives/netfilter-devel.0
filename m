From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] update pptp contrack for 2.4.29
Date: Sun, 30 Jan 2005 09:23:46 -0800
Message-ID: <20050130172346.GA14821@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
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


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Since CONFIG_IP_NF_NAT_LOCAL disappeared, the following is needed for
2.4.29+.

Phil



--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pptp-2429

diff -ru pom-orig/pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd_2 pom/pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd_2
--- pom-orig/pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd_2	2004-03-05 04:30:25.000000000 -0500
+++ pom/pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd_2	2005-01-30 12:20:52.954915072 -0500
@@ -1,4 +1,4 @@
-      bool '    NAT of local connections (READ HELP)' CONFIG_IP_NF_NAT_LOCAL
+      dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIRECT $CONFIG_IP_NF_NAT
       if [ "$CONFIG_IP_NF_PPTP" = "m" ]; then
         define_tristate CONFIG_IP_NF_NAT_PPTP m
       else

--7JfCtLOvnd9MIVvH--
