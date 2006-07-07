From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/10][CONNTRACK] remove write lock in
	ip_conntrack_hash_insert
Date: Fri, 07 Jul 2006 04:13:57 +0200
Message-ID: <44ADC365.7060800@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040802020701070600050907"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------040802020701070600050907
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The insertion into hashes is composed of two steps: insertion itself and 
timer activation, this two steps process must be atomic. Therefore, the 
ip_conntrack_hash_insert call and timer activation must be done inside 
appropiate write lock.

This patch depends on [PATCH 3/10]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040802020701070600050907
Content-Type: text/plain;
 name="04insert.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04insert.patch"

[CONNTRACK] remove write lock in ip_conntrack_hash_insert

The insertion into hashes is composed of two steps: insertion itself and
timer activation, this two steps process must be atomic. Therefore, 
the ip_conntrack_hash_insert call and timer activation must be done inside
appropiate write lock.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-06 23:27:55.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-06 23:28:41.000000000 +0200
@@ -428,12 +428,12 @@ void ip_conntrack_hash_insert(struct ip_
 {
 	unsigned int hash, repl_hash;
 
+	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
+	
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	write_lock_bh(&ip_conntrack_lock);
 	__ip_conntrack_hash_insert(ct, hash, repl_hash);
-	write_unlock_bh(&ip_conntrack_lock);
 }
 
 /* Confirm a connection given skb; places it in hash table */
Index: net-2.6/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_core.c	2006-07-06 23:28:49.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_core.c	2006-07-06 23:29:11.000000000 +0200
@@ -678,12 +678,12 @@ void nf_conntrack_hash_insert(struct nf_
 {
 	unsigned int hash, repl_hash;
 
+	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
+
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	write_lock_bh(&nf_conntrack_lock);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
-	write_unlock_bh(&nf_conntrack_lock);
 }
 
 /* Confirm a connection given skb; places it in hash table */

--------------040802020701070600050907--
