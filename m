From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 7/7] netfilter: connlimit: use rbtree for per-host
 conntrack obj storage
Date: Sun, 9 Mar 2014 22:45:13 +0100
Message-ID: <20140309214513.GD14012@breakpoint.cc>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
 <1394199435-14395-8-git-send-email-fw@strlen.de>
 <1394203677.20149.18.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140307161512.GF17526@breakpoint.cc>
 <1394390520.20149.108.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140309184357.GC14012@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51604 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbaCIVpP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 17:45:15 -0400
Content-Disposition: inline
In-Reply-To: <20140309184357.GC14012@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > Hmm, that would be nice.  I need to think about it again,
> > > problem is that moving it at this time could result in
> > > freeing the would-be parent of the new node.
> > 
> > Yeah, thats why fq_gc() is followed by a full lookup.
> > 
> > In practice, the lookup done in fq_gc() brings in cpu cache all the
> > cache lines, and second lookup is very fast.
> 
> I had wondered about this.  Ok, that makes sense.
> I'll change it to be more like fq.
> 
> Thanks for explaining this.

Not exactly pretty, but in most cases the restart won't be needed
(either because we found node-to-add-to or no stale node to remove).

I'll fold the following into patch #7, but will wait until Tuesday
before resend in order to give others a chance to comment.

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -202,7 +202,9 @@ count_tree(struct net *net, struct rb_root *root,
 	struct xt_connlimit_conn *conn;
 	unsigned int count = 0;
 	unsigned int gc_count = 0;
+	bool no_gc = false;
 
+ restart:
 	rbnode = &(root->rb_node);
 	while (*rbnode) {
 		int diff;
@@ -230,7 +232,7 @@ count_tree(struct net *net, struct rb_root *root,
 			return count + 1;
 		}
 
-		if (gc_count >= ARRAY_SIZE(gc_nodes))
+		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
 			continue;
 
 		/* only used for GC on hhead, retval and 'addit' ignored */
@@ -239,15 +241,22 @@ count_tree(struct net *net, struct rb_root *root,
 			gc_nodes[gc_count++] = rbconn;
 	}
 
+	if (gc_count) {
+		no_gc = true;
+		tree_nodes_free(root, gc_nodes, gc_count);
+		gc_count = 0;
+		goto restart;
+	}
+
 	/* no match, need to insert new node */
 	rbconn = kmem_cache_alloc(connlimit_rb_cachep, GFP_ATOMIC);
 	if (rbconn == NULL)
-		goto out;
+		return 0;
 
 	conn = kmem_cache_alloc(connlimit_conn_cachep, GFP_ATOMIC);
 	if (conn == NULL) {
 		kmem_cache_free(connlimit_rb_cachep, rbconn);
-		goto out;
+		return 0;
 	}
 
 	conn->tuple = *tuple;
@@ -259,10 +268,7 @@ count_tree(struct net *net, struct rb_root *root,
 
 	rb_link_node(&rbconn->node, parent, rbnode);
 	rb_insert_color(&rbconn->node, root);
-	count = 1;
- out:
-	tree_nodes_free(root, gc_nodes, gc_count);
-	return count;
+	return 1;
 }
 
 static int count_them(struct net *net,
