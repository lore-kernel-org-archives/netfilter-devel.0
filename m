From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] trivial CONNMARK typo
Date: Mon, 2 Aug 2004 21:58:26 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040803045826.GA22598@linuxace.com>
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

The below fixes bugzilla #207...

Phil



diff -ru pom-orig/CONNMARK/linux/Documentation/Configure.help.ladd pom-new/CONNMARK/linux/Documentation/Configure.help.ladd
--- pom-orig/CONNMARK/linux/Documentation/Configure.help.ladd   2004-02-19 06:30:07.000000000 -0500
+++ pom-new/CONNMARK/linux/Documentation/Configure.help.ladd    2004-07-30 18:30:19.000000000 -0400
@@ -17,7 +17,7 @@
   ipt_CONNMARK.o.  If unsure, say `N'.
 
 connmark match support
-CONFIP_IP_NF_MATCH_CONNMARK
+CONFIG_IP_NF_MATCH_CONNMARK
   This option adds a `connmark' match, which allows you to match the
   connection mark value previously set for the session by `CONNMARK'. 
 
