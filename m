From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: xtables: inclusion of xt_condition
Date: Tue, 06 Apr 2010 16:12:04 +0200
Message-ID: <4BBB4134.2020007@trash.net>
References: <1270214599-22734-1-git-send-email-jengelh@medozas.de> <1270214599-22734-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58664 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0DFOMF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:12:05 -0400
In-Reply-To: <1270214599-22734-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +/* Defaults, these can be overridden on the module command-line. */
> +static unsigned int condition_list_perms = S_IRUSR | S_IWUSR;
> +static unsigned int condition_uid_perms;
> +static unsigned int condition_gid_perms;

I think it might be useful to make them overridable on a per-rule base
if it doesn't cause inconsistent behaviour when sharing a condition
variable.

> +struct condition_variable {
> +	struct list_head list;
> +	struct proc_dir_entry *status_proc;
> +	unsigned int refcount;
> +	bool enabled;
> +};
> +
> +/* proc_lock is a user context only semaphore used for write access */
> +/*           to the conditions' list.                               */
> +static struct mutex proc_lock;

DEFINE_MUTEX() ?

> +static bool
> +condition_mt(const struct sk_buff *skb, const struct xt_match_param *par)
> +{
> +	const struct xt_condition_mtinfo *info = par->matchinfo;
> +	const struct condition_variable *var   = info->condvar;
> +	bool x;
> +
> +	rcu_read_lock();
> +	x = rcu_dereference(var->enabled);
> +	rcu_read_unlock();

That looks unnecessary. What exactly is that rcu lock trying to protect?
Where is the corresponding rcu assignment?

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

No need for interruptible locking, the section is very short and
usually there's only a single iptables process running at a time.

> +
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
> +	var->status_proc->read_proc  = condition_proc_read;
> +	var->status_proc->write_proc = condition_proc_write;
> +	list_add_rcu(&var->list, &conditions_list);

Why are you using the RCU variant? The list is only walked while
holding the mutex, without using the _rcu list functions. Removal
also happens while holding the mutex.

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

Also looks unnecessary.

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

Matches are registered globally, not once per namespace.

> +	if (ret < 0) {
> +		remove_proc_entry(dir_name, net->proc_net);
> +		return ret;
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

