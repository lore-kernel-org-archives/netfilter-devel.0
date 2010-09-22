From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: ctnetlink: add support for user-space
 expectation helpers
Date: Wed, 22 Sep 2010 13:07:13 +0200
Message-ID: <4C99E361.2020501@netfilter.org>
References: <20100921092843.3279.6914.stgit@decadence> <20100921093529.3279.30748.stgit@decadence> <4C98CD4C.3040700@trash.net> <4C9933F1.2060200@netfilter.org> <4C99A614.1030207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020402030808060403030107"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60165 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0IVLHV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:07:21 -0400
In-Reply-To: <4C99A614.1030207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020402030808060403030107
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Patrick,

On 22/09/10 08:45, Patrick McHardy wrote:
>> diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
>> index fdc50ca..23a1a08 100644
>> --- a/include/linux/netfilter/nf_conntrack_common.h
>> +++ b/include/linux/netfilter/nf_conntrack_common.h
>> @@ -103,6 +103,7 @@ enum ip_conntrack_expect_events {
>>  /* expectation flags */
>>  #define NF_CT_EXPECT_PERMANENT		0x1
>>  #define NF_CT_EXPECT_INACTIVE		0x2
>> +#define NF_CT_EXPECT_USERSPACE		0x4
> 
> Does this flag need to be exposed to userspace? I also don't
> see anything preventing userspace incorrectly setting it on
> an expectation that actually does have a master, which will
> probably cause problems later on.

I have reworked the patch again: the flag is exposed to user-space but
you cannot set/unset it.

>> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
>> index acb29cc..361a8ba 100644
>> --- a/net/netfilter/nf_conntrack_expect.c
>> +++ b/net/netfilter/nf_conntrack_expect.c
>> @@ -38,20 +38,26 @@ static int nf_ct_expect_hash_rnd_initted __read_mostly;
>>  
>>  static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
>>  
>> +static HLIST_HEAD(nf_ct_userspace_expect_list);
>> +static int nf_ct_userspace_expect_list_counter;
> 
> This counter is write-only.

Removed this counter!

I have also modified the /proc output to display USERSPACE for
expectation whose user-space flag is set (this was missing in the
previous patch).

--------------020402030808060403030107
Content-Type: text/x-patch;
 name="exp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="exp.patch"

netfilter: ctnetlink: add support for user-space expectation helpers

This patch adds the basic infrastructure to support user-space
expectation helpers via ctnetlink and the netfilter queuing
infrastructure NFQUEUE. Basically, this patch:

* adds NF_CT_EXPECT_USERSPACE flag to identify user-space
created expectations. I have also added a sanity check in
__nf_ct_expect_check() to avoid that kernel-space helpers
may create an expectation if the master conntrack has no
helper assigned.
* adds some branches to check if the master conntrack helper
exists, otherwise we skip the code that refers to kernel-space
helper such as the local expectation list and the expectation
policy.
* allows to set the timeout for user-space expectations with
no helper assigned.
* a list of expectations created from user-space that depends
on ctnetlink (if this module is removed, they are deleted).
* includes USERSPACE in the /proc output for expectations
that have been created by a user-space helper.

This patch also modifies ctnetlink to skip including the helper
name in the Netlink messages if no kernel-space helper is set
(since no user-space expectation has not kernel-space kernel
assigned).

You can access an example user-space FTP conntrack helper at:
http://people.netfilter.org/pablo/nf-ftp-helper-userspace-POC.tar.bz

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    1 
 include/net/netfilter/nf_conntrack_expect.h   |    1 
 net/netfilter/nf_conntrack_expect.c           |   62 +++++++++++++++++++------
 net/netfilter/nf_conntrack_netlink.c          |   46 ++++++++++++-------
 4 files changed, 79 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index fdc50ca..23a1a08 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -103,6 +103,7 @@ enum ip_conntrack_expect_events {
 /* expectation flags */
 #define NF_CT_EXPECT_PERMANENT		0x1
 #define NF_CT_EXPECT_INACTIVE		0x2
+#define NF_CT_EXPECT_USERSPACE		0x4
 
 #ifdef __KERNEL__
 struct ip_conntrack_stat {
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 96bb42a..416b838 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -85,6 +85,7 @@ nf_ct_find_expectation(struct net *net, u16 zone,
 void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
 void nf_ct_remove_expectations(struct nf_conn *ct);
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
+void nf_ct_remove_userspace_expectations(void);
 
 /* Allocate space for an expectation: this is mandatory before calling
    nf_ct_expect_related.  You will have to call put afterwards. */
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index acb29cc..b30a1f2 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -38,20 +38,23 @@ static int nf_ct_expect_hash_rnd_initted __read_mostly;
 
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 
+static HLIST_HEAD(nf_ct_userspace_expect_list);
+
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct net *net = nf_ct_exp_net(exp);
 
-	NF_CT_ASSERT(master_help);
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
 	hlist_del_rcu(&exp->hnode);
 	net->ct.expect_count--;
 
 	hlist_del(&exp->lnode);
-	master_help->expecting[exp->class]--;
+	if (!(exp->flags & NF_CT_EXPECT_USERSPACE))
+		master_help->expecting[exp->class]--;
+
 	nf_ct_expect_put(exp);
 
 	NF_CT_STAT_INC(net, expect_delete);
@@ -320,16 +323,21 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 
 	atomic_inc(&exp->use);
 
-	hlist_add_head(&exp->lnode, &master_help->expectations);
-	master_help->expecting[exp->class]++;
+	if (master_help) {
+		hlist_add_head(&exp->lnode, &master_help->expectations);
+		master_help->expecting[exp->class]++;
+	} else if (exp->flags & NF_CT_EXPECT_USERSPACE)
+		hlist_add_head(&exp->lnode, &nf_ct_userspace_expect_list);
 
 	hlist_add_head_rcu(&exp->hnode, &net->ct.expect_hash[h]);
 	net->ct.expect_count++;
 
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
-	p = &master_help->helper->expect_policy[exp->class];
-	exp->timeout.expires = jiffies + p->timeout * HZ;
+	if (master_help) {
+		p = &master_help->helper->expect_policy[exp->class];
+		exp->timeout.expires = jiffies + p->timeout * HZ;
+	}
 	add_timer(&exp->timeout);
 
 	atomic_inc(&exp->use);
@@ -380,7 +388,9 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	unsigned int h;
 	int ret = 1;
 
-	if (!master_help->helper) {
+	/* Don't allow expectations created from kernel-space with no helper */
+	if (!(expect->flags & NF_CT_EXPECT_USERSPACE) &&
+	    (!master_help || (master_help && !master_help->helper))) {
 		ret = -ESHUTDOWN;
 		goto out;
 	}
@@ -398,13 +408,16 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 		}
 	}
 	/* Will be over limit? */
-	p = &master_help->helper->expect_policy[expect->class];
-	if (p->max_expected &&
-	    master_help->expecting[expect->class] >= p->max_expected) {
-		evict_oldest_expect(master, expect);
-		if (master_help->expecting[expect->class] >= p->max_expected) {
-			ret = -EMFILE;
-			goto out;
+	if (master_help) {
+		p = &master_help->helper->expect_policy[expect->class];
+		if (p->max_expected &&
+		    master_help->expecting[expect->class] >= p->max_expected) {
+			evict_oldest_expect(master, expect);
+			if (master_help->expecting[expect->class]
+						>= p->max_expected) {
+				ret = -EMFILE;
+				goto out;
+			}
 		}
 	}
 
@@ -439,6 +452,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
 
+void nf_ct_remove_userspace_expectations(void)
+{
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *n, *next;
+
+	hlist_for_each_entry_safe(exp, n, next,
+				  &nf_ct_userspace_expect_list, lnode) {
+		if (del_timer(&exp->timeout)) {
+			nf_ct_unlink_expect(exp);
+			nf_ct_expect_put(exp);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(nf_ct_remove_userspace_expectations);
+
 #ifdef CONFIG_PROC_FS
 struct ct_expect_iter_state {
 	struct seq_net_private p;
@@ -529,8 +557,12 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		seq_printf(s, "PERMANENT");
 		delim = ",";
 	}
-	if (expect->flags & NF_CT_EXPECT_INACTIVE)
+	if (expect->flags & NF_CT_EXPECT_INACTIVE) {
 		seq_printf(s, "%sINACTIVE", delim);
+		delim = ",";
+	}
+	if (expect->flags & NF_CT_EXPECT_USERSPACE)
+		seq_printf(s, "%sUSERSPACE", delim);
 
 	helper = rcu_dereference(nfct_help(expect->master)->helper);
 	if (helper) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0804e0e..b4077be 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1560,8 +1560,8 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
-	struct nf_conntrack_helper *helper;
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
+	struct nf_conn_help *help;
 
 	if (timeout < 0)
 		timeout = 0;
@@ -1578,9 +1578,14 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
 	NLA_PUT_BE32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags));
-	helper = rcu_dereference(nfct_help(master)->helper);
-	if (helper)
-		NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
+	help = nfct_help(master);
+	if (help) {
+		struct nf_conntrack_helper *helper;
+
+		helper = rcu_dereference(help->helper);
+		if (helper)
+			NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
+	}
 
 	return 0;
 
@@ -1921,24 +1926,32 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
-	help = nfct_help(ct);
-
-	if (!help || !help->helper) {
-		/* such conntrack hasn't got any helper, abort */
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		err = -ENOMEM;
 		goto out;
 	}
+	help = nfct_help(ct);
+	if (!help) {
+		if (!cda[CTA_EXPECT_TIMEOUT]) {
+			err = -EINVAL;
+			goto out;
+		}
+		exp->timeout.expires =
+		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
 
-	if (cda[CTA_EXPECT_FLAGS])
-		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
-	else
-		exp->flags = 0;
+		exp->flags = NF_CT_EXPECT_USERSPACE;
+		if (cda[CTA_EXPECT_FLAGS]) {
+			exp->flags |=
+				ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
+		}
+	} else {
+		if (cda[CTA_EXPECT_FLAGS]) {
+			exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
+			exp->flags &= ~NF_CT_EXPECT_USERSPACE;
+		} else
+			exp->flags = 0;
+	}
 
 	exp->class = 0;
 	exp->expectfn = NULL;
@@ -2109,6 +2122,7 @@ static void __exit ctnetlink_exit(void)
 {
 	pr_info("ctnetlink: unregistering from nfnetlink.\n");
 
+	nf_ct_remove_userspace_expectations();
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	nf_ct_expect_unregister_notifier(&ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(&ctnl_notifier);

--------------020402030808060403030107--
