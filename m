From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 00/20]: Netfilter Update part II
Date: Sun, 03 Dec 2006 13:15:15 +0900 (JST)
Message-ID: <200612030415.kB34FHS4012691@toshiba.co.jp>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Sat,  2 Dec 2006 15:49:36 +0100 (MET)

> Hi Dave,
> 
> following is part two of my netfilter update for 2.6.20, containing
> NAT support for nf_conntrack and ports of all conntrack/NAT helpers.
> With these patches nf_conntrack is finally a full replacement for
> ip_conntrack, which is now scheduled for removal in 2.6.22 after some
> stabilization of the new code.
> 
> You can also pull these patches from
> http://people.netfilter.org/~kaber/nf-2.6.20-nat.git

I've tested some kconfig combinations. Some helpers seem to need
netfilter.h for NF_{ACCEPT,DROP}, in the case that IPv4 NAT is disabled.
And ecache includes some unnecessary headers.

-- Yasuyuki Kozakai

>From 0e329162380f9f7342bff139087e1964dcb94bbc Mon Sep 17 00:00:00 2001
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Sun, 3 Dec 2006 06:41:20 +0900
Subject: [NETFILTER]: nf_conntrack: fix header inclusions for helpers

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/netfilter/nf_conntrack_amanda.c     |    1 +
 net/netfilter/nf_conntrack_ecache.c     |    4 ----
 net/netfilter/nf_conntrack_netbios_ns.c |    1 +
 net/netfilter/nf_conntrack_sip.c        |    1 +
 net/netfilter/nf_conntrack_tftp.c       |    1 +
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 5c495dc..b8869ea 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -15,6 +15,7 @@
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/udp.h>
+#include <linux/netfilter.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_expect.h>
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index d051694..1a223e0 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -21,10 +21,6 @@
 #include <linux/netdevice.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_expect.h>
-#include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
 ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 4fad3ad..a5b234e 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -24,6 +24,7 @@
 #include <linux/if_addr.h>
 #include <linux/in.h>
 #include <linux/ip.h>
+#include <linux/netfilter.h>
 #include <net/route.h>
 
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index e0c0679..eb2a241 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -14,6 +14,7 @@
 #include <linux/inet.h>
 #include <linux/in.h>
 #include <linux/udp.h>
+#include <linux/netfilter.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_expect.h>
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index d46a126..f5bffe2 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -9,6 +9,7 @@
 #include <linux/moduleparam.h>
 #include <linux/in.h>
 #include <linux/udp.h>
+#include <linux/netfilter.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
-- 
1.4.4
