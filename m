From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 5/7] kill useless included headers
Date: Fri, 04 Nov 2005 19:00:38 +0100
Message-ID: <436BA1C6.4080707@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090605080900030105020901"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090605080900030105020901
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Kill some useless headers included in ctnetlink. They aren't used in any
way.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090605080900030105020901
Content-Type: text/plain;
 name="08-kill-header.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08-kill-header.patch"

Kill some useless headers included in ctnetlink. They aren't used in any 
way.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:02:36.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:31:02.000000000 +0100
@@ -28,11 +28,8 @@
 #include <linux/netlink.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
-#include <linux/rtnetlink.h>
 
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>

--------------090605080900030105020901--
