Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC2FC41513
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjHPQDT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344402AbjHPQCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:02:50 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB9010F0;
        Wed, 16 Aug 2023 09:02:47 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 033B717F61;
        Wed, 16 Aug 2023 19:02:46 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id DA33A17F5C;
        Wed, 16 Aug 2023 19:02:45 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id A79913C0325;
        Wed, 16 Aug 2023 19:02:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1692201763; bh=wAKYWlRT1Luq45cPjoozO/I4AAx4gv4ALqkvKffGThE=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=dj8yEXAMRiBMPMkeE9+vyD55NUQnN7IoNPEztg+XovLAyqRLB2cqWx5Aj0Nj5xOw0
         s6BKfx/xpIKln3Ye9k3uPi/WOJFIiV5653ZnCpYafiPXA435078ot4Z9gYHJ9d4JTX
         7b+pLnCbGaExK+K/mILQuSieqJhrgBn7DjtJw82s=
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 37GG2djE170631;
        Wed, 16 Aug 2023 19:02:39 +0300
Date:   Wed, 16 Aug 2023 19:02:39 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     "Paul E. McKenney" <paulmck@kernel.org>
cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        rcu@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Jiejian Wu <jiejian@linux.alibaba.com>,
        Jiri Wiesner <jwiesner@suse.de>
Subject: Re: [PATCH RFC net-next 01/14] rculist_bl: add
 hlist_bl_for_each_entry_continue_rcu
In-Reply-To: <958d687d-9f7f-4baf-af26-2ec351ef8699@paulmck-laptop>
Message-ID: <a3bba801-5253-5ab1-4dce-43c5b7cb407c@ssi.bg>
References: <20230815173031.168344-1-ja@ssi.bg> <20230815173031.168344-2-ja@ssi.bg> <958d687d-9f7f-4baf-af26-2ec351ef8699@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 15 Aug 2023, Paul E. McKenney wrote:

> On Tue, Aug 15, 2023 at 08:30:18PM +0300, Julian Anastasov wrote:
> > Add hlist_bl_for_each_entry_continue_rcu and hlist_bl_next_rcu
> > 
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > ---
> >  include/linux/rculist_bl.h | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
> > index 0b952d06eb0b..93a757793d83 100644
> > --- a/include/linux/rculist_bl.h
> > +++ b/include/linux/rculist_bl.h
> > @@ -24,6 +24,10 @@ static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> >  		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
> >  }
> >  
> > +/* return the next element in an RCU protected list */
> > +#define hlist_bl_next_rcu(node)	\
> > +	(*((struct hlist_bl_node __rcu **)(&(node)->next)))
> > +
> >  /**
> >   * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
> >   * @n: the element to delete from the hash list.
> > @@ -98,4 +102,17 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
> >  		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
> >  		pos = rcu_dereference_raw(pos->next))
> >  
> > +/**
> > + * hlist_bl_for_each_entry_continue_rcu - iterate over a list continuing after
> > + *   current point
> 
> Please add a comment to the effect that the element continued from
> must have been either: (1) Iterated to within the same RCU read-side
> critical section or (2) Nailed down using some lock, reference count,
> or whatever suffices to keep the continued-from element from being freed
> in the meantime.

	I created 2nd version which has more changes. I'm not sure
what are the desired steps for this patch, should I keep it as part
of my patchset if accepted? Or should I post it separately? Here it
is v2 for comments.

[PATCHv2 RFC] rculist_bl: add hlist_bl_for_each_entry_continue_rcu

Change the old hlist_bl_first_rcu to hlist_bl_first_rcu_dereference
to indicate that it is a RCU dereference.

Add hlist_bl_next_rcu and hlist_bl_first_rcu to use RCU pointers
and use them to fix sparse warnings.

Add hlist_bl_for_each_entry_continue_rcu.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 include/linux/rculist_bl.h | 49 +++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
index 0b952d06eb0b..36363b876e53 100644
--- a/include/linux/rculist_bl.h
+++ b/include/linux/rculist_bl.h
@@ -8,21 +8,31 @@
 #include <linux/list_bl.h>
 #include <linux/rcupdate.h>
 
+/* return the first ptr or next element in an RCU protected list */
+#define hlist_bl_first_rcu(head)	\
+	(*((struct hlist_bl_node __rcu **)(&(head)->first)))
+#define hlist_bl_next_rcu(node)	\
+	(*((struct hlist_bl_node __rcu **)(&(node)->next)))
+
 static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
 					struct hlist_bl_node *n)
 {
 	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
 	LIST_BL_BUG_ON(((unsigned long)h->first & LIST_BL_LOCKMASK) !=
 							LIST_BL_LOCKMASK);
-	rcu_assign_pointer(h->first,
+	rcu_assign_pointer(hlist_bl_first_rcu(h),
 		(struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
 }
 
-static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
-{
-	return (struct hlist_bl_node *)
-		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
-}
+#define hlist_bl_first_rcu_dereference(head)				\
+({									\
+	struct hlist_bl_head *__head = (head);				\
+									\
+	(struct hlist_bl_node *)					\
+	((unsigned long)rcu_dereference_check(hlist_bl_first_rcu(__head), \
+					      hlist_bl_is_locked(__head)) & \
+					      ~LIST_BL_LOCKMASK);	\
+})
 
 /**
  * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
@@ -73,7 +83,7 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
 {
 	struct hlist_bl_node *first;
 
-	/* don't need hlist_bl_first_rcu because we're under lock */
+	/* don't need hlist_bl_first_rcu* because we're under lock */
 	first = hlist_bl_first(h);
 
 	n->next = first;
@@ -93,9 +103,30 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
  *
  */
 #define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)		\
-	for (pos = hlist_bl_first_rcu(head);				\
+	for (pos = hlist_bl_first_rcu_dereference(head);		\
 		pos &&							\
 		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(hlist_bl_next_rcu(pos)))
+
+/**
+ * hlist_bl_for_each_entry_continue_rcu - continue iteration over list of given
+ *   type
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_bl_node to use as a loop cursor.
+ * @member:	the name of the hlist_bl_node within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position which must have been in the list when the RCU read
+ * lock was taken.
+ * This would typically require either that you obtained the node from a
+ * previous walk of the list in the same RCU read-side critical section, or
+ * that you held some sort of non-RCU reference (such as a reference count)
+ * to keep the node alive *and* in the list.
+ */
+#define hlist_bl_for_each_entry_continue_rcu(tpos, pos, member)		\
+	for (pos = rcu_dereference_raw(hlist_bl_next_rcu(&(tpos)->member)); \
+	     pos &&							\
+	     ({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = rcu_dereference_raw(hlist_bl_next_rcu(pos)))
 
 #endif
-- 
2.41.0


Regards

--
Julian Anastasov <ja@ssi.bg>

