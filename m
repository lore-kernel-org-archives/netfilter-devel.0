From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: xtables: inclusion of xt_condition
Date: Wed, 21 Apr 2010 15:07:19 +0200
Message-ID: <4BCEF887.2070103@trash.net>
References: <1271845618-28569-1-git-send-email-jengelh@medozas.de> <1271845618-28569-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40572 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0DUNHU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:07:20 -0400
In-Reply-To: <1271845618-28569-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +static bool
> +condition_mt(const struct sk_buff *skb, const struct xt_match_param *par)
> +{
> +	const struct xt_condition_mtinfo *info = par->matchinfo;
> +	const struct condition_variable *var   = info->condvar;
> +	bool x;
> +
> +	rcu_read_lock();
> +	x = rcu_dereference(var->enabled);

At the risk of repeating myself, why is this using rcu_dereference()
for a boolean?

> +	rcu_read_unlock();
> +
> +	return x ^ info->invert;
> +}
> +
> +static int condition_mt_check(const struct xt_mtchk_param *par)
> +{
> +	struct xt_condition_mtinfo *info = par->matchinfo;
> +	struct condition_variable *var;
> +
> +	/* Forbid certain names */
> +	if (*info->name == '\0' || *info->name == '.' ||
> +	    info->name[sizeof(info->name)-1] != '\0' ||
> +	    memchr(info->name, '/', sizeof(info->name)) != NULL) {
> +		pr_info("name not allowed or too long: \"%.*s\"\n",
> +			(unsigned int)sizeof(info->name), info->name);
> +		return -EINVAL;
> +	}
> +	/*
> +	 * Let's acquire the lock, check for the condition and add it
> +	 * or increase the reference counter.
> +	 */
> +	if (mutex_lock_interruptible(&proc_lock) != 0)
> +		return -EINTR;

Also repeating myself - this seems like overkill, the section is
short and the mutex should basically never be contended.

> +	list_for_each_entry(var, &conditions_list, list) {
> +		if (strcmp(info->name, var->status_proc->name) == 0) {
> +			++var->refcount;
> +			mutex_unlock(&proc_lock);
> +			info->condvar = var;
> +			return 0;
> +		}
> +	}
> +
> +	/* At this point, we need to allocate a new condition variable. */
> +	var = kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
> +	if (var == NULL) {
> +		mutex_unlock(&proc_lock);
> +		return -ENOMEM;
> +	}
> +
> +	/* Create the condition variable's proc file entry. */
> +	var->status_proc = create_proc_entry(info->name, condition_list_perms,
> +			   proc_net_condition);
> +	if (var->status_proc == NULL) {
> +		kfree(var);
> +		mutex_unlock(&proc_lock);
> +		return -ENOMEM;
> +	}
> +
> +	var->refcount = 1;
> +	var->enabled  = false;
> +	var->status_proc->data = var;
> +	wmb();

Please always comment the use of memory barriers.

> +	var->status_proc->read_proc  = condition_proc_read;
> +	var->status_proc->write_proc = condition_proc_write;
> +	list_add_rcu(&var->list, &conditions_list);

Still using rcu list variants for no reason.

> +	var->status_proc->uid = condition_uid_perms;
> +	var->status_proc->gid = condition_gid_perms;
> +	mutex_unlock(&proc_lock);
> +	info->condvar = var;
> +	return 0;
> +}
> +
> +static void condition_mt_destroy(const struct xt_mtdtor_param *par)
> +{
> +	const struct xt_condition_mtinfo *info = par->matchinfo;
> +	struct condition_variable *var = info->condvar;
> +
> +	mutex_lock(&proc_lock);
> +	if (--var->refcount == 0) {
> +		list_del_rcu(&var->list);
> +		remove_proc_entry(var->status_proc->name, proc_net_condition);
> +		mutex_unlock(&proc_lock);
> +		/*
> +		 * synchronize_rcu() would be good enough, but
> +		 * synchronize_net() guarantees that no packet
> +		 * will go out with the old rule after
> +		 * succesful removal.
> +		 */
> +		synchronize_net();
> +		kfree(var);
> +		return;
> +	}
> +	mutex_unlock(&proc_lock);
> +}
> +
> +static struct xt_match condition_mt_reg __read_mostly = {
> +	.name       = "condition",
> +	.revision   = 1,
> +	.family     = NFPROTO_UNSPEC,
> +	.matchsize  = sizeof(struct xt_condition_mtinfo),
> +	.match      = condition_mt,
> +	.checkentry = condition_mt_check,
> +	.destroy    = condition_mt_destroy,
> +	.me         = THIS_MODULE,
> +};
> +
> +static const char *const dir_name = "nf_condition";
> +
> +static int __net_init condnet_mt_init(struct net *net)
> +{
> +	int ret;
> +
> +	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
> +	if (proc_net_condition == NULL)
> +		return -EACCES;
> +
> +	ret = xt_register_match(&condition_mt_reg);
> +	if (ret < 0) {
> +		remove_proc_entry(dir_name, net->proc_net);
> +		return ret;

I'm not sure whether you accidentally posted an old version or
why there are none of the changes I asked for during the last
review. matches are not registered per namespace.

> +	}
> +
> +	return 0;
> +}
> +
> +static void __net_exit condnet_mt_exit(struct net *net)
> +{
> +	xt_unregister_match(&condition_mt_reg);
> +	remove_proc_entry(dir_name, net->proc_net);
> +}
> +
> +static struct pernet_operations condition_mt_netops = {
> +	.init = condnet_mt_init,
> +	.exit = condnet_mt_exit,
> +};
> +
> +static int __init condition_mt_init(void)
> +{
> +	mutex_init(&proc_lock);
> +	return register_pernet_subsys(&condition_mt_netops);
> +}
> +
> +static void __exit condition_mt_exit(void)
> +{
> +	unregister_pernet_subsys(&condition_mt_netops);
> +}
> +
> +module_init(condition_mt_init);
> +module_exit(condition_mt_exit);

