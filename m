From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 1/3] CLUSTERIP: fix memcpy() length typo
Date: Tue, 30 Aug 2005 14:15:37 +0200
Message-ID: <20050830121550.250421000@nienna.balabit>
References: <20050830121535.985929000@nienna.balabit>
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=01-config_init_memcpy_typo.patch
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

CLUSTERIP: fix memcpy() length typo

Fix a trivial typo in clusterip_config_init().


Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>


Index: linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.13.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 13:41:22.059915425 +0200
+++ linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 14:12:40.317423733 +0200
@@ -144,7 +144,7 @@
 	memcpy(&c->clustermac, &i->clustermac, ETH_ALEN);
 	c->num_total_nodes = i->num_total_nodes;
 	c->num_local_nodes = i->num_local_nodes;
-	memcpy(&c->local_nodes, &i->local_nodes, sizeof(&c->local_nodes));
+	memcpy(&c->local_nodes, &i->local_nodes, sizeof(c->local_nodes));
 	c->hash_mode = i->hash_mode;
 	c->hash_initval = i->hash_initval;
 	atomic_set(&c->refcount, 1);

--
 Regards,
  Krisztian Kovacs
 
