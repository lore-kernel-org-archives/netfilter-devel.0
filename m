From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2.1] conntrack: add /proc entry to disable helper by
 default
Date: Thu, 12 Apr 2012 17:26:51 +0200
Message-ID: <20120412152651.GA10677@1984>
References: <1332917824-4839-1-git-send-email-eric@regit.org>
 <1332940790-18337-1-git-send-email-eric@regit.org>
 <1332940790-18337-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50846 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934449Ab2DLP1E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:27:04 -0400
Content-Disposition: inline
In-Reply-To: <1332940790-18337-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eric,

On Wed, Mar 28, 2012 at 03:19:50PM +0200, Eric Leblond wrote:
> This patch gives the user different methods to disable
> the attachment of helper to all connections on a given
> port. The idea is to allow the user to choose with the CT target
> the helper assignement he wants to have.
> 
> First method it to use the 'nf_conntrack_helper' option on the
> nf_conntrack module and set it to 0. As this is a constraint to do
> this at the time of the loading, a /proc entry is also available.
> Setting sys/net/netfilter/nf_conntrack_auto_assign_helper to 0 will
> disable the automatic assignement of the helper.

I have modified your patch a bit, please find the one I plan to apply
enclosed to this email.

I have also heavily rewritten the description. I decided to keep you
as author, if you're OK with it.

Regarding this:
http://www.netfilter.org/news.html#2012-04-03

I'll expand those news to be a bit more verbose, as it will be the
reference the patch will point to.

You can find the list of changes below.

> ---
>  include/net/netfilter/nf_conntrack_helper.h |    3 +
>  include/net/netns/conntrack.h               |    2 +
>  net/netfilter/nf_conntrack_core.c           |    6 ++
>  net/netfilter/nf_conntrack_helper.c         |   82 ++++++++++++++++++++++++++-
>  4 files changed, 92 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 5767dc2..a1f9955 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -63,6 +63,9 @@ static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
>  extern int nf_conntrack_helper_init(void);
>  extern void nf_conntrack_helper_fini(void);
>  
> +extern int nf_conntrack_helper_init_net(struct net *net);
> +extern void nf_conntrack_helper_fini_net(struct net *net);

I have modified this, so now nf_conntrack_helper_[init|fini] take
struct net instead. Thus, we don't need these new functions.

> +
>  extern int nf_conntrack_broadcast_help(struct sk_buff *skb,
>  				       unsigned int protoff,
>  				       struct nf_conn *ct,
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
> index 7a911ec..7e21aec 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -26,11 +26,13 @@ struct netns_ct {
>  	int			sysctl_tstamp;
>  	int			sysctl_checksum;
>  	unsigned int		sysctl_log_invalid; /* Log invalid packets */
> +	int			sysctl_auto_assign_helper;
>  #ifdef CONFIG_SYSCTL
>  	struct ctl_table_header	*sysctl_header;
>  	struct ctl_table_header	*acct_sysctl_header;
>  	struct ctl_table_header	*tstamp_sysctl_header;
>  	struct ctl_table_header	*event_sysctl_header;
> +	struct ctl_table_header	*helper_sysctl_header;
>  #endif
>  	char			*slabname;
>  };
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index cbdb754..b30d845 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1357,6 +1357,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
>  	nf_conntrack_tstamp_fini(net);
>  	nf_conntrack_acct_fini(net);
>  	nf_conntrack_expect_fini(net);
> +	nf_conntrack_helper_fini_net(net);
>  	kmem_cache_destroy(net->ct.nf_conntrack_cachep);
>  	kfree(net->ct.slabname);
>  	free_percpu(net->ct.stat);
> @@ -1587,9 +1588,14 @@ static int nf_conntrack_init_net(struct net *net)
>  	ret = nf_conntrack_timeout_init(net);
>  	if (ret < 0)
>  		goto err_timeout;
> +	ret = nf_conntrack_helper_init_net(net);
> +	if (ret < 0)
> +		goto err_helper;
>  
>  	return 0;
>  
> +err_helper:
> +	nf_conntrack_helper_fini_net(net);
>  err_timeout:
>  	nf_conntrack_timeout_fini(net);
>  err_ecache:
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 436b7cb..d27252e 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -34,6 +34,67 @@ static struct hlist_head *nf_ct_helper_hash __read_mostly;
>  static unsigned int nf_ct_helper_hsize __read_mostly;
>  static unsigned int nf_ct_helper_count __read_mostly;
>  
> +static bool nf_ct_auto_assign_helper __read_mostly = 1;
> +module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
> +MODULE_PARM_DESC(nf_conntrack_helper, "Assign helper to connection based on port (default 1)");

I have modified the description.

> +
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table helper_sysctl_table[] = {
> +	{
> +		.procname	= "nf_conntrack_auto_assign_helper",

I have renamed this to "nf_conntrack_helper"

> +		.data		= &init_net.ct.sysctl_auto_assign_helper,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{}
> +};
> +
> +static int nf_conntrack_helper_init_sysctl(struct net *net)
> +{
> +	struct ctl_table *table;
> +
> +	table = kmemdup(helper_sysctl_table, sizeof(helper_sysctl_table),
> +			GFP_KERNEL);
> +	if (!table)
> +		goto out;
> +
> +	table[0].data = &net->ct.sysctl_auto_assign_helper;
> +
> +	net->ct.helper_sysctl_header = register_net_sysctl_table(net,
> +			nf_net_netfilter_sysctl_path, table);
> +	if (!net->ct.helper_sysctl_header) {
> +		printk(KERN_ERR "nf_conntrack_helper: can't register to sysctl.\n");
> +		goto out_register;
> +	}
> +	return 0;
> +
> +out_register:
> +	kfree(table);
> +out:
> +	return -ENOMEM;
> +}
> +
> +static void nf_conntrack_helper_fini_sysctl(struct net *net)
> +{
> +	struct ctl_table *table;
> +
> +	table = net->ct.helper_sysctl_header->ctl_table_arg;
> +	unregister_net_sysctl_table(net->ct.helper_sysctl_header);
> +	kfree(table);
> +}
> +#else
> +static int nf_conntrack_helper_init_sysctl(struct net *net)
> +{
> +	return 0;
> +}
> +
> +static void nf_conntrack_helper_fini_sysctl(struct net *net)
> +{
> +}
> +#endif /* CONFIG_SYSCTL */
> +
> +
>  

I removed these extra empty lines.

>  /* Stupid hash, but collision free for the default registrations of the
>   * helpers currently in the kernel. */
> @@ -118,6 +179,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  {
>  	struct nf_conntrack_helper *helper = NULL;
>  	struct nf_conn_help *help;
> +	struct net *net = nf_ct_net(ct);
>  	int ret = 0;
>  
>  	if (tmpl != NULL) {
> @@ -127,8 +189,10 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  	}
>  
>  	help = nfct_help(ct);
> -	if (helper == NULL)
> +
> +	if (net->ct.sysctl_auto_assign_helper && helper == NULL)
>  		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +
>  	if (helper == NULL) {
>  		if (help)
>  			RCU_INIT_POINTER(help->helper, NULL);
> @@ -324,6 +388,10 @@ int nf_conntrack_helper_init(void)
>  	if (!nf_ct_helper_hash)
>  		return -ENOMEM;
>  
> +	printk(KERN_INFO "nf_conntrack: automatic assignation of helper to"
> +	       " connection will be disabled soon. Set nf_conntrack_helper"
> +	       " option to 1 to keep old behavior.\n");

We spot this message only once now. So we don't disturb all Linux
kernel users with this message, only those using conntrack helpers.

> +
>  	err = nf_ct_extend_register(&helper_extend);
>  	if (err < 0)
>  		goto err1;
> @@ -335,8 +403,20 @@ err1:
>  	return err;
>  }
>  
> +int nf_conntrack_helper_init_net(struct net *net)
> +{
> +	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
> +
> +	return nf_conntrack_helper_init_sysctl(net);
> +}
> +
>  void nf_conntrack_helper_fini(void)
>  {
>  	nf_ct_extend_unregister(&helper_extend);
>  	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
>  }
> +
> +void nf_conntrack_helper_fini_net(struct net *net)
> +{
> +	nf_conntrack_helper_fini_sysctl(net);
> +}
> -- 
> 1.7.9.1
> 

BTW, you may notice a glitch in my patch. There's two
nf_conntrack_timeout_fini() invocation in the error path of
nf_conntrack_init_net. That's already corrected in davem's tree but it
didn't reached linux-next tree yet.

--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-netfilter-nf_ct_helper-allow-to-disable-automatic-he.patch"

>From cb44ff4724d398004cea7becae2cf8a82cbc9360 Mon Sep 17 00:00:00 2001
From: Eric Leblond <eric@regit.org>
Date: Wed, 28 Mar 2012 03:19:50 +0000
Subject: [PATCH 2/2] netfilter: nf_ct_helper: allow to disable automatic helper assignment

This patch allows you to disable automatic conntrack helper
lookup based on TCP/UDP ports, eg.

echo 0 > /proc/sys/net/netfilter/nf_conntrack_helper

[ Note: flows that already got a helper will keep using it even
  if automatic helper assignment has been disabled ]

Once this behaviour has been disabled, you have to explicitly
use the iptables CT target to attach helper to flows.

There are good reasons to stop supporting automatic helper
assignment, for further information, please read:

http://www.netfilter.org/news.html#2012-04-03

This patch also adds one message to inform that automatic helper
assignment is deprecated and it will be removed soon (this is
spotted only once, with the first flow that gets a helper attached
to make it as less annoying as possible).

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h |    4 +-
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |   15 ++--
 net/netfilter/nf_conntrack_helper.c         |  109 ++++++++++++++++++++++++---
 4 files changed, 109 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 5767dc2..1d18894 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -60,8 +60,8 @@ static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
 }
 
-extern int nf_conntrack_helper_init(void);
-extern void nf_conntrack_helper_fini(void);
+extern int nf_conntrack_helper_init(struct net *net);
+extern void nf_conntrack_helper_fini(struct net *net);
 
 extern int nf_conntrack_broadcast_help(struct sk_buff *skb,
 				       unsigned int protoff,
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 7a911ec..7e21aec 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -26,11 +26,13 @@ struct netns_ct {
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
+	int			sysctl_auto_assign_helper;
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 	struct ctl_table_header	*acct_sysctl_header;
 	struct ctl_table_header	*tstamp_sysctl_header;
 	struct ctl_table_header	*event_sysctl_header;
+	struct ctl_table_header	*helper_sysctl_header;
 #endif
 	char			*slabname;
 };
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6cd8e32..a2f3b5d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1336,7 +1336,6 @@ static void nf_conntrack_cleanup_init_net(void)
 	while (untrack_refs() > 0)
 		schedule();
 
-	nf_conntrack_helper_fini();
 	nf_conntrack_proto_fini();
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	nf_ct_extend_unregister(&nf_ct_zone_extend);
@@ -1354,6 +1353,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 	}
 
 	nf_ct_free_hashtable(net->ct.hash, net->ct.htable_size);
+	nf_conntrack_helper_fini(net);
 	nf_conntrack_timeout_fini(net);
 	nf_conntrack_ecache_fini(net);
 	nf_conntrack_tstamp_fini(net);
@@ -1504,10 +1504,6 @@ static int nf_conntrack_init_init_net(void)
 	if (ret < 0)
 		goto err_proto;
 
-	ret = nf_conntrack_helper_init();
-	if (ret < 0)
-		goto err_helper;
-
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	ret = nf_ct_extend_register(&nf_ct_zone_extend);
 	if (ret < 0)
@@ -1525,10 +1521,8 @@ static int nf_conntrack_init_init_net(void)
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 err_extend:
-	nf_conntrack_helper_fini();
-#endif
-err_helper:
 	nf_conntrack_proto_fini();
+#endif
 err_proto:
 	return ret;
 }
@@ -1589,9 +1583,14 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_timeout_init(net);
 	if (ret < 0)
 		goto err_timeout;
+	ret = nf_conntrack_helper_init(net);
+	if (ret < 0)
+		goto err_helper;
 
 	return 0;
 
+err_helper:
+	nf_conntrack_timeout_fini(net);
 err_timeout:
 	nf_conntrack_timeout_fini(net);
 err_ecache:
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 436b7cb..16c35ef 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -34,6 +34,66 @@ static struct hlist_head *nf_ct_helper_hash __read_mostly;
 static unsigned int nf_ct_helper_hsize __read_mostly;
 static unsigned int nf_ct_helper_count __read_mostly;
 
+static bool nf_ct_auto_assign_helper __read_mostly = true;
+module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
+MODULE_PARM_DESC(nf_conntrack_helper,
+		 "Enable automatic conntrack helper assignment (default 1)");
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table helper_sysctl_table[] = {
+	{
+		.procname	= "nf_conntrack_helper",
+		.data		= &init_net.ct.sysctl_auto_assign_helper,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+
+static int nf_conntrack_helper_init_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = kmemdup(helper_sysctl_table, sizeof(helper_sysctl_table),
+			GFP_KERNEL);
+	if (!table)
+		goto out;
+
+	table[0].data = &net->ct.sysctl_auto_assign_helper;
+
+	net->ct.helper_sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, table);
+	if (!net->ct.helper_sysctl_header) {
+		printk(KERN_ERR "nf_conntrack_helper: can't register to sysctl.\n");
+		goto out_register;
+	}
+	return 0;
+
+out_register:
+	kfree(table);
+out:
+	return -ENOMEM;
+}
+
+static void nf_conntrack_helper_fini_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = net->ct.helper_sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->ct.helper_sysctl_header);
+	kfree(table);
+}
+#else
+static int nf_conntrack_helper_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+static void nf_conntrack_helper_fini_sysctl(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
 
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
@@ -113,11 +173,14 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
+static bool nf_ct_helper_warned;
+
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn_help *help;
+	struct net *net = nf_ct_net(ct);
 	int ret = 0;
 
 	if (tmpl != NULL) {
@@ -127,8 +190,17 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	}
 
 	help = nfct_help(ct);
-	if (helper == NULL)
+
+	if (net->ct.sysctl_auto_assign_helper && helper == NULL) {
 		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+		if (unlikely(helper && !nf_ct_helper_warned)) {
+			printk(KERN_INFO "nf_conntrack: automatic helper "
+				"assignment is deprecated. Please, read "
+				"http://www.netfilter.org/news.html#2012-04-03\n");
+			nf_ct_helper_warned = true;
+		}
+	}
+
 	if (helper == NULL) {
 		if (help)
 			RCU_INIT_POINTER(help->helper, NULL);
@@ -315,28 +387,43 @@ static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.id	= NF_CT_EXT_HELPER,
 };
 
-int nf_conntrack_helper_init(void)
+int nf_conntrack_helper_init(struct net *net)
 {
 	int err;
 
-	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
-	nf_ct_helper_hash = nf_ct_alloc_hashtable(&nf_ct_helper_hsize, 0);
-	if (!nf_ct_helper_hash)
-		return -ENOMEM;
+	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
+
+	if (net_eq(net, &init_net)) {
+		nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
+		nf_ct_helper_hash =
+			nf_ct_alloc_hashtable(&nf_ct_helper_hsize, 0);
+		if (!nf_ct_helper_hash)
+			return -ENOMEM;
 
-	err = nf_ct_extend_register(&helper_extend);
+		err = nf_ct_extend_register(&helper_extend);
+		if (err < 0)
+			goto err1;
+	}
+
+	err = nf_conntrack_helper_init_sysctl(net);
 	if (err < 0)
-		goto err1;
+		goto out_sysctl;
 
 	return 0;
 
+out_sysctl:
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&helper_extend);
 err1:
 	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
 	return err;
 }
 
-void nf_conntrack_helper_fini(void)
+void nf_conntrack_helper_fini(struct net *net)
 {
-	nf_ct_extend_unregister(&helper_extend);
-	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
+	nf_conntrack_helper_fini_sysctl(net);
+	if (net_eq(net, &init_net)) {
+		nf_ct_extend_unregister(&helper_extend);
+		nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
+	}
 }
-- 
1.7.9.5


--u3/rZRmxL6MmkK24--
