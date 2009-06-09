From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 00:58:15 +0200
Message-ID: <4A2EE907.70609@netfilter.org>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090504070505050503090909"
Cc: netfilter-devel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34987 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZFIW6W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:58:22 -0400
In-Reply-To: <4A2EE610.9020207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090504070505050503090909
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Hi Patrick,
>>>
>>> A couple of minor issues related to this patch.
>>>
>>> Patrick McHardy wrote:
>>>>> +    hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
>>>> Why is _rcu used? The lists are never used for a lookup.
>>>
>>> There's no hlist_nulls_del() operation without rcu. I have a patch here
>>> to add hlist_nulls_add_head() and hlist_nulls_del() although I guess
>>> that you are going to tell me that you cannot apply that patch? So,
>>> where to go?
>>
>> Either way is fine I guess. Adding non _rcu function makes sense
>> I think (Eric CCed to correct me :)). But there's also no harm
>> in using the RCU functions as long as you add a comment stating
>> that you don't in fact rely on the RCU properties to avoid confusing
>> people.
> 
> But to clarify: the non-RCU functions would be preferred :)

OK :). Eric, could you tell what if this patch is OK? It's based on the
RCU version.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090504070505050503090909
Content-Type: text/x-diff;
 name="hlist-nulls-add-head.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hlist-nulls-add-head.patch"

list_nulls: add hlist_nulls_add_head and hlist_nulls_del

This patch adds the hlist_nulls_add_head() function which is
based on hlist_nulls_add_head_rcu() but without the use of
rcu_assign_pointer(). It also adds hlist_nulls_del which is
exactly the same hlist_nulls_del_rcu.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/list_nulls.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)


diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index 93150ec..5d10ae3 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -56,6 +56,18 @@ static inline int hlist_nulls_empty(const struct hlist_nulls_head *h)
 	return is_a_nulls(h->first);
 }
 
+static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
+					struct hlist_nulls_head *h)
+{
+	struct hlist_nulls_node *first = h->first;
+
+	n->next = first;
+	n->pprev = &h->first;
+	h->first = n;
+	if (!is_a_nulls(first))
+		first->pprev = &n->next;
+}
+
 static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 {
 	struct hlist_nulls_node *next = n->next;
@@ -65,6 +77,12 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 		next->pprev = pprev;
 }
 
+static inline void hlist_nulls_del(struct hlist_nulls_node *n)
+{
+	__hlist_nulls_del(n);
+	n->pprev = LIST_POISON2;
+}
+
 /**
  * hlist_nulls_for_each_entry	- iterate over list of given type
  * @tpos:	the type * to use as a loop cursor.

--------------090504070505050503090909--
