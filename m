From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/**] Properly terminate option struct
Date: Tue, 24 Jul 2007 12:19:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241218590.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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



The option struct needs to be terminated, otherwise ip{,6}tables
will access illegal memory in merge_options().

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_NFLOG.c |    1 +
 extensions/libipt_NFLOG.c  |    1 +
 2 files changed, 2 insertions(+)

Index: iptables/extensions/libip6t_NFLOG.c
===================================================================
--- iptables.orig/extensions/libip6t_NFLOG.c
+++ iptables/extensions/libip6t_NFLOG.c
@@ -19,6 +19,7 @@ static struct option opts[] = {
 	{ "nflog-prefix",    1, 0, NFLOG_PREFIX },
 	{ "nflog-range",     1, 0, NFLOG_RANGE },
 	{ "nflog-threshold", 1, 0, NFLOG_THRESHOLD },
+	{NULL},
 };
 
 static void help(void)
Index: iptables/extensions/libipt_NFLOG.c
===================================================================
--- iptables.orig/extensions/libipt_NFLOG.c
+++ iptables/extensions/libipt_NFLOG.c
@@ -19,6 +19,7 @@ static struct option opts[] = {
 	{ "nflog-prefix",    1, 0, NFLOG_PREFIX },
 	{ "nflog-range",     1, 0, NFLOG_RANGE },
 	{ "nflog-threshold", 1, 0, NFLOG_THRESHOLD },
+	{NULL},
 };
 
 static void help(void)
