From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: ctnetlink: cleanup master conntrack assignation
Date: Wed, 18 Mar 2009 17:42:49 +0100
Message-ID: <49C12489.5040500@trash.net>
References: <20090305160714.13755.83435.stgit@Decadence> <49BE6188.9020601@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090909010900050003030303"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45607 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZCRQmw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:42:52 -0400
In-Reply-To: <49BE6188.9020601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090909010900050003030303
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch moves the assignation of the master conntrack to
>> ctnetlink_create_conntrack(), which is where it really belongs.
>> This patch is a cleanup.
> 
> Applied, thanks.

I've added this patch on top to fix a RCU context imbalance.

This seems like a good opportunity to say this again: please (everyone)
compile your code using sparse. It catches this type and more bugs.

There is a second bug introduced by this patch:

	add_timer(&ct->timeout);
	nf_conntrack_hash_insert(ct);
	rcu_read_unlock();

	return ct;

The conntrack lock is not held, it might crash or create double entries.

--------------090909010900050003030303
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 0f5b3e85a3716efebb0150ebb7c6d022e2bf17d7
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Mar 18 17:36:40 2009 +0100

    netfilter: ctnetlink: fix rcu context imbalance
    
    Introduced by 7ec47496 (netfilter: ctnetlink: cleanup master conntrack assignation):
    
    net/netfilter/nf_conntrack_netlink.c:1275:2: warning: context imbalance in 'ctnetlink_create_conntrack' - different lock contexts for basic block
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 735ea9c..d1fe9d1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1146,7 +1146,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		return ERR_PTR(-ENOMEM);
 
 	if (!cda[CTA_TIMEOUT])
-		goto err;
+		goto err1;
 	ct->timeout.expires = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
@@ -1157,10 +1157,8 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
  		char *helpname;
  
  		err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
- 		if (err < 0) {
-			rcu_read_unlock();
-			goto err;
-		}
+ 		if (err < 0)
+			goto err2;
 
 		helper = __nf_conntrack_helper_find_byname(helpname);
 		if (helper == NULL) {
@@ -1168,28 +1166,26 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 #ifdef CONFIG_MODULES
 			if (request_module("nfct-helper-%s", helpname) < 0) {
 				err = -EOPNOTSUPP;
-				goto err;
+				goto err1;
 			}
 
 			rcu_read_lock();
 			helper = __nf_conntrack_helper_find_byname(helpname);
 			if (helper) {
-				rcu_read_unlock();
 				err = -EAGAIN;
-				goto err;
+				goto err2;
 			}
 			rcu_read_unlock();
 #endif
 			err = -EOPNOTSUPP;
-			goto err;
+			goto err1;
 		} else {
 			struct nf_conn_help *help;
 
 			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 			if (help == NULL) {
-				rcu_read_unlock();
 				err = -ENOMEM;
-				goto err;
+				goto err2;
 			}
 
 			/* not in hash table yet so not strictly necessary */
@@ -1198,44 +1194,34 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	} else {
 		/* try an implicit helper assignation */
 		err = __nf_ct_try_assign_helper(ct, GFP_ATOMIC);
-		if (err < 0) {
-			rcu_read_unlock();
-			goto err;
-		}
+		if (err < 0)
+			goto err2;
 	}
 
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
-		if (err < 0) {
-			rcu_read_unlock();
-			goto err;
-		}
+		if (err < 0)
+			goto err2;
 	}
 
 	if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 		err = ctnetlink_change_nat(ct, cda);
-		if (err < 0) {
-			rcu_read_unlock();
-			goto err;
-		}
+		if (err < 0)
+			goto err2;
 	}
 
 #ifdef CONFIG_NF_NAT_NEEDED
 	if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
 		err = ctnetlink_change_nat_seq_adj(ct, cda);
-		if (err < 0) {
-			rcu_read_unlock();
-			goto err;
-		}
+		if (err < 0)
+			goto err2;
 	}
 #endif
 
 	if (cda[CTA_PROTOINFO]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
-		if (err < 0) {
-			rcu_read_unlock();
-			goto err;
-		}
+		if (err < 0)
+			goto err2;
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
@@ -1253,12 +1239,12 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 		err = ctnetlink_parse_tuple(cda, &master, CTA_TUPLE_MASTER, u3);
 		if (err < 0)
-			goto err;
+			goto err2;
 
 		master_h = __nf_conntrack_find(&init_net, &master);
 		if (master_h == NULL) {
 			err = -ENOENT;
-			goto err;
+			goto err2;
 		}
 		master_ct = nf_ct_tuplehash_to_ctrack(master_h);
 		nf_conntrack_get(&master_ct->ct_general);
@@ -1271,7 +1257,10 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	rcu_read_unlock();
 
 	return ct;
-err:
+
+err2:
+	rcu_read_unlock();
+err1:
 	nf_conntrack_free(ct);
 	return ERR_PTR(err);
 }

--------------090909010900050003030303--
