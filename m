From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] [CONNTRACK] cleanup the conntrack ID initialization
Date: Mon, 27 Feb 2006 03:10:35 +0100
Message-ID: <44025F9B.5040902@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080308090609030306020301"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
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
--------------080308090609030306020301
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Currently the first conntrack ID assigned is 2, use 1 instead.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------080308090609030306020301
Content-Type: text/plain;
 name="init.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="init.patch"

[CONNTRACK] cleanup the conntrack ID initialization

Currently the first conntrack ID assigned is 2, use 1 instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2006-02-25 13:45:51.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_core.c	2006-02-25 17:41:42.000000000 +0100
@@ -85,8 +85,8 @@ unsigned int nf_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
 
-static unsigned int nf_conntrack_next_id = 1;
-static unsigned int nf_conntrack_expect_next_id = 1;
+static unsigned int nf_conntrack_next_id;
+static unsigned int nf_conntrack_expect_next_id;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct notifier_block *nf_conntrack_chain;
 struct notifier_block *nf_conntrack_expect_chain;
Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-02-25 13:45:44.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_core.c	2006-02-25 17:41:55.000000000 +0100
@@ -77,8 +77,8 @@ unsigned int ip_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
 
-static unsigned int ip_conntrack_next_id = 1;
-static unsigned int ip_conntrack_expect_next_id = 1;
+static unsigned int ip_conntrack_next_id;
+static unsigned int ip_conntrack_expect_next_id;
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 struct notifier_block *ip_conntrack_chain;
 struct notifier_block *ip_conntrack_expect_chain;

--------------080308090609030306020301--
