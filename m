From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT 20070806
Date: Mon, 6 Aug 2007 15:08:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061506380.13469@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708061455480.13469@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708061455480.13469@fbirervta.pbzchgretzou.qr>
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


And the iptables part...

One currently has to load xt_TARPIT.ko by hand in this round because
iptables does not do that yet despite having received more
xt'ificiation in SVN already; and I have forgot to add
MODULE_ALIAS("ipt_TARPIT").

---
 extensions/.TARPIT-testx     |    2 ++
 extensions/libipt_TARPIT.man |   34 ++++++++++++++++++++++++++++++++++
 extensions/libxt_TARPIT.c    |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

Index: iptables/extensions/.TARPIT-testx
===================================================================
--- /dev/null
+++ iptables/extensions/.TARPIT-testx
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f "$KERNEL_DIR/net/netfilter/xt_TARPIT.c" ] && echo TARPIT
Index: iptables/extensions/libipt_TARPIT.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_TARPIT.man
@@ -0,0 +1,34 @@
+Captures and holds incoming TCP connections using no local
+per-connection resources. Connections are accepted, but immediately
+switched to the persist state (0 byte window), in which the remote
+side stops sending data and asks to continue every 60-240 seconds.
+Attempts to close the connection are ignored, forcing the remote side
+to time out the connection in 12-24 minutes.
+
+This offers similar functionality to LaBrea
+<http://www.hackbusters.net/LaBrea/> but doesn't require dedicated
+hardware or IPs. Any TCP port that you would normally DROP or REJECT
+can instead become a tarpit.
+
+To tarpit connections to TCP port 80 destined for the current machine:
+.IP
+iptables -A INPUT -p tcp -m tcp --dport 80 -j TARPIT
+.P
+To significantly slow down Code Red/Nimda-style scans of unused address
+space, forward unused ip addresses to a Linux box not acting as a router
+(e.g. "ip route 10.0.0.0 255.0.0.0 ip.of.linux.box" on a Cisco), enable IP
+forwarding on the Linux box, and add:
+.IP
+iptables -A FORWARD -p tcp -j TARPIT
+.IP
+iptables -A FORWARD -j DROP
+.TP
+NOTE:
+If you use the conntrack module while you are using TARPIT, you should
+also use the NOTRACK target, or the kernel will unnecessarily allocate
+resources for each TARPITted connection. To TARPIT incoming
+connections to the standard IRC port while using conntrack, you could:
+.IP
+iptables -t raw -A PREROUTING -p tcp --dport 6667 -j NOTRACK
+.IP
+iptables -A INPUT -p tcp --dport 6667 -j TARPIT
Index: iptables/extensions/libxt_TARPIT.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_TARPIT.c
@@ -0,0 +1,37 @@
+/* Shared library add-on to iptables for TARPIT support */
+#include <stdio.h>
+#include <getopt.h>
+#include <xtables.h>
+
+static void tarpit_help(void)
+{
+	printf("TARPIT takes no options\n\n");
+}
+
+static int tarpit_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
+{
+	return 0;
+}
+
+static void tarpit_check(unsigned int flags)
+{
+}
+
+static struct xtables_target tarpit_reg = {
+	.name          = "TARPIT",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(0),
+	.userspacesize = XT_ALIGN(0),
+	.help          = tarpit_help,
+	.parse         = tarpit_parse,
+	.final_check   = tarpit_check,
+	.print         = NULL,
+	.save          = NULL,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tarpit_reg);
+}
