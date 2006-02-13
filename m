From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Mon, 13 Feb 2006 03:41:52 +0100
Message-ID: <43EFF1F0.1090701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090002090508010600040003"
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
--------------090002090508010600040003
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

[NF_CONNTRACK] first conntrack ID must be 1 not 2

The first conntrack ID must be 1. If a new conntrack is created, the
general ID counter must be post-incremented instead pre-incremented
since [ip|nf]_conntrack_next_id is initialized to 1. Same applies for
expectations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090002090508010600040003
Content-Type: text/plain;
 name="id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="id.patch"

[NETFILTER] first conntrack ID must be 1 not 2

The first conntrack ID must be 1. If a new conntrack is created, the
general ID counter must be post-incremented instead pre-incremented since
[ip|nf]_conntrack_next_id is initialized to 1. Same applies for expectations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2006-02-13 01:05:04.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_core.c	2006-02-13 01:47:04.000000000 +0100
@@ -682,7 +682,7 @@ static void __nf_conntrack_hash_insert(s
 				       unsigned int hash,
 				       unsigned int repl_hash) 
 {
-	ct->id = ++nf_conntrack_next_id;
+	ct->id = nf_conntrack_next_id++;
 	list_prepend(&nf_conntrack_hash[hash],
 		     &ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	list_prepend(&nf_conntrack_hash[repl_hash],
@@ -1247,7 +1247,7 @@ static void nf_conntrack_expect_insert(s
 	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
-	exp->id = ++nf_conntrack_expect_next_id;
+	exp->id = nf_conntrack_expect_next_id++;
 	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(expect_create);
 }
Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-02-04 14:34:40.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_core.c	2006-02-13 01:46:42.000000000 +0100
@@ -417,7 +417,7 @@ static void __ip_conntrack_hash_insert(s
 					unsigned int hash,
 					unsigned int repl_hash) 
 {
-	ct->id = ++ip_conntrack_next_id;
+	ct->id = ip_conntrack_next_id++;
 	list_prepend(&ip_conntrack_hash[hash],
 		     &ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	list_prepend(&ip_conntrack_hash[repl_hash],
@@ -971,7 +971,7 @@ static void ip_conntrack_expect_insert(s
 	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
-	exp->id = ++ip_conntrack_expect_next_id;
+	exp->id = ip_conntrack_expect_next_id++;
 	atomic_inc(&exp->use);
 	CONNTRACK_STAT_INC(expect_create);
 }

--------------090002090508010600040003--
