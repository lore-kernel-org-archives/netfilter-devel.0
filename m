From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: idletimers - add send_nl_msg field
Date: Fri, 26 Apr 2013 03:22:31 +0200
Message-ID: <20130426012231.GA4472@localhost>
References: <1366537994-19511-1-git-send-email-dmitry.pervushin@linaro.org>
 <1366537994-19511-3-git-send-email-dmitry.pervushin@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, JP Abgrall <jpa@google.com>,
	Ashish Sharma <ashishsharma@google.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	John Stultz <john.stultz@linaro.org>
To: dmitry pervushin <dmitry.pervushin@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33280 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598Ab3DZBWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:22:41 -0400
Content-Disposition: inline
In-Reply-To: <1366537994-19511-3-git-send-email-dmitry.pervushin@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dmitry,

You got some feedback for this patch:

https://patchwork.kernel.org/patch/2333851/

This patch still seem not to address some spots I already mention.

Please, have a look at my previous email and let me know if you have
any question.

Thanks.

On Sun, Apr 21, 2013 at 11:53:14AM +0200, dmitry pervushin wrote:
> Send notifications when the label becomes active after an idle period.
> Send netlink message notifications in addition to sysfs notifications.
> Using a uevent with
>       subsystem=xt_idletimer
>       INTERFACE=...
>       STATE={active,inactive}
> 
> This is backport from common android-3.0
> commit: beb914e987cbbd368988d2b94a6661cb907c4d5a
> with uevent support instead of a new netlink message type.
> 
> Cc: JP Abgrall <jpa@google.com>
> Cc: Ashish Sharma <ashishsharma@google.com>
> Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: Ashish Sharma <ashishsharma@google.com>
> Signed-off-by: JP Abgrall <jpa@google.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: dmitry pervushin <dmitry.pervushin@linaro.org>
> ---
>  include/uapi/linux/netfilter/xt_IDLETIMER.h |   16 +-
>  net/netfilter/xt_IDLETIMER.c                |  234 +++++++++++++++++++--------
>  2 files changed, 180 insertions(+), 70 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> index 208ae93..e50bc3d 100644
> --- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
> +++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> @@ -39,7 +39,21 @@ struct idletimer_tg_info {
>  	char label[MAX_IDLETIMER_LABEL_SIZE];
>  
>  	/* for kernel module internal use only */
> -	struct idletimer_tg *timer __attribute__((aligned(8)));
> +	struct idletimer_tg *timer __aligned(8);
>  };
>  
> +#define NL_EVENT_TYPE_INACTIVE 0
> +#define NL_EVENT_TYPE_ACTIVE 1
> +
> +struct idletimer_tg_info_v1 {
> +	__u32 timeout;
> +
> +	char label[MAX_IDLETIMER_LABEL_SIZE];
> +
> +	/* Use netlink messages for notification in addition to sysfs */
> +	__u8 send_nl_msg;
> +
> +	/* for kernel module internal use only */
> +	struct idletimer_tg *timer __aligned(8);
> +};
>  #endif
> diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
> index 3540c04..6eb25ab 100644
> --- a/net/netfilter/xt_IDLETIMER.c
> +++ b/net/netfilter/xt_IDLETIMER.c
> @@ -41,6 +41,8 @@
>  #include <linux/workqueue.h>
>  #include <linux/sysfs.h>
>  
> +#define NLMSG_MAX_SIZE 64
> +
>  struct idletimer_tg_attr {
>  	struct attribute attr;
>  	ssize_t	(*show)(struct kobject *kobj,
> @@ -56,6 +58,8 @@ struct idletimer_tg {
>  	struct idletimer_tg_attr attr;
>  
>  	unsigned int refcnt;
> +	bool send_nl_msg;
> +	bool active;
>  };
>  
>  static LIST_HEAD(idletimer_tg_list);
> @@ -63,6 +67,30 @@ static DEFINE_MUTEX(list_mutex);
>  
>  static struct kobject *idletimer_tg_kobj;
>  
> +static void notify_netlink_uevent(const char *iface, struct idletimer_tg *timer)
> +{
> +	char iface_msg[NLMSG_MAX_SIZE];
> +	char state_msg[NLMSG_MAX_SIZE];
> +	char *envp[] = { iface_msg, state_msg, NULL };
> +	int res;
> +
> +	res = snprintf(iface_msg, NLMSG_MAX_SIZE, "INTERFACE=%s",
> +		       iface);
> +	if (NLMSG_MAX_SIZE <= res) {
> +		pr_err("message too long (%d)", res);
> +		return;
> +	}
> +	res = snprintf(state_msg, NLMSG_MAX_SIZE, "STATE=%s",
> +		       timer->active ? "active" : "inactive");
> +	if (NLMSG_MAX_SIZE <= res) {
> +		pr_err("message too long (%d)", res);
> +		return;
> +	}
> +	pr_debug("putting nlmsg: <%s> <%s>\n", iface_msg, state_msg);
> +	kobject_uevent_env(idletimer_tg_kobj, KOBJ_CHANGE, envp);
> +	return;
> +}
> +
>  static
>  struct idletimer_tg *__idletimer_tg_find_by_label(const char *label)
>  {
> @@ -83,6 +111,7 @@ static ssize_t idletimer_tg_show(struct kobject *kobj, struct attribute *attr,
>  {
>  	struct idletimer_tg *timer;
>  	unsigned long expires = 0;
> +	unsigned long now = jiffies;
>  
>  	mutex_lock(&list_mutex);
>  
> @@ -92,11 +121,15 @@ static ssize_t idletimer_tg_show(struct kobject *kobj, struct attribute *attr,
>  
>  	mutex_unlock(&list_mutex);
>  
> -	if (time_after(expires, jiffies))
> +	if (time_after(expires, now))
>  		return sprintf(buf, "%u\n",
> -			       jiffies_to_msecs(expires - jiffies) / 1000);
> +			       jiffies_to_msecs(expires - now) / 1000);
>  
> -	return sprintf(buf, "0\n");
> +	if (timer->send_nl_msg)
> +		return sprintf(buf, "0 %d\n",
> +			jiffies_to_msecs(now - expires) / 1000);
> +	else
> +		return sprintf(buf, "0\n");
>  }
>  
>  static void idletimer_tg_work(struct work_struct *work)
> @@ -105,6 +138,9 @@ static void idletimer_tg_work(struct work_struct *work)
>  						  work);
>  
>  	sysfs_notify(idletimer_tg_kobj, NULL, timer->attr.attr.name);
> +
> +	if (timer->send_nl_msg)
> +		notify_netlink_uevent(timer->attr.attr.name, timer);
>  }
>  
>  static void idletimer_tg_expired(unsigned long data)
> @@ -113,50 +149,46 @@ static void idletimer_tg_expired(unsigned long data)
>  
>  	pr_debug("timer %s expired\n", timer->attr.attr.name);
>  
> +	timer->active = false;
>  	schedule_work(&timer->work);
>  }
>  
> -static int idletimer_tg_create(struct idletimer_tg_info *info)
> +static int idletimer_tg_create(struct idletimer_tg *timer, const char *label,
> +		unsigned long timeout, bool send_nl_msg)
>  {
>  	int ret;
>  
> -	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
> -	if (!info->timer) {
> +	timer->attr.attr.name = kstrdup(label, GFP_KERNEL);
> +	if (!timer->attr.attr.name) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> +	timer->attr.attr.mode = S_IRUGO;
> +	timer->attr.show = idletimer_tg_show;
>  
> -	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
> -	if (!info->timer->attr.attr.name) {
> -		ret = -ENOMEM;
> -		goto out_free_timer;
> -	}
> -	info->timer->attr.attr.mode = S_IRUGO;
> -	info->timer->attr.show = idletimer_tg_show;
> -
> -	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
> +	ret = sysfs_create_file(idletimer_tg_kobj, &timer->attr.attr);
>  	if (ret < 0) {
>  		pr_debug("couldn't add file to sysfs");
>  		goto out_free_attr;
>  	}
>  
> -	list_add(&info->timer->entry, &idletimer_tg_list);
> +	list_add(&timer->entry, &idletimer_tg_list);
>  
> -	setup_timer(&info->timer->timer, idletimer_tg_expired,
> -		    (unsigned long) info->timer);
> -	info->timer->refcnt = 1;
> +	setup_timer(&timer->timer, idletimer_tg_expired,
> +		    (unsigned long)timer);
> +	timer->active = true;
> +	timer->refcnt = 1;
> +	timer->send_nl_msg = send_nl_msg;
>  
> -	mod_timer(&info->timer->timer,
> -		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
> +	mod_timer(&timer->timer,
> +		  msecs_to_jiffies(timeout * 1000) + jiffies);
>  
> -	INIT_WORK(&info->timer->work, idletimer_tg_work);
> +	INIT_WORK(&timer->work, idletimer_tg_work);
>  
>  	return 0;
>  
>  out_free_attr:
> -	kfree(info->timer->attr.attr.name);
> -out_free_timer:
> -	kfree(info->timer);
> +	kfree(timer->attr.attr.name);
>  out:
>  	return ret;
>  }
> @@ -164,45 +196,60 @@ out:
>  /*
>   * The actual xt_tables plugin.
>   */
> -static unsigned int idletimer_tg_target(struct sk_buff *skb,
> -					 const struct xt_action_param *par)
> +static unsigned int idletimer_tg_target_do(struct idletimer_tg *timer,
> +		const char *label, u32 timeout)
>  {
> -	const struct idletimer_tg_info *info = par->targinfo;
>  	unsigned long now = jiffies;
>  
>  	pr_debug("resetting timer %s, timeout period %u\n",
> -		 info->label, info->timeout);
> +		 label, timeout);
>  
> -	BUG_ON(!info->timer);
> +	BUG_ON(!timer);
> +	timer->active = true;
>  
> -	if (time_before(info->timer->timer.expires, now)) {
> -		schedule_work(&info->timer->work);
> +	if (time_before(timer->timer.expires, now)) {
> +		schedule_work(&timer->work);
>  		pr_debug("Starting timer %s (Expired, Jiffies): %lu, %lu\n",
> -			 info->label, info->timer->timer.expires, now);
> +			 label, timer->timer.expires, now);
>  	}
>  
>  	/* TODO: Avoid modifying timers on each packet */
> -	mod_timer(&info->timer->timer,
> -		  msecs_to_jiffies(info->timeout * 1000) + now);
> +	mod_timer(&timer->timer,
> +		  msecs_to_jiffies(timeout * 1000) + now);
>  
>  	return XT_CONTINUE;
>  }
>  
> -static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
> +static unsigned int idletimer_tg_target(struct sk_buff *skb,
> +					 const struct xt_action_param *par)
> +{
> +	const struct idletimer_tg_info *info = par->targinfo;
> +	return idletimer_tg_target_do(info->timer, info->label, info->timeout);
> +}
> +
> +static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
> +					 const struct xt_action_param *par)
> +{
> +	const struct idletimer_tg_info_v1 *info = par->targinfo;
> +	return idletimer_tg_target_do(info->timer, info->label, info->timeout);
> +}
> +
> +static int idletimer_tg_checkentry_do(struct idletimer_tg **timer_ret,
> +		const char *label, u32 timeout, bool send_nl_msg)
>  {
> -	struct idletimer_tg_info *info = par->targinfo;
>  	int ret;
>  	unsigned long now = jiffies;
> +	struct idletimer_tg *timer;
>  
> -	pr_debug("checkentry targinfo%s\n", info->label);
> +	pr_debug("checkentry targinfo %s\n", label);
>  
> -	if (info->timeout == 0) {
> +	if (timeout == 0) {
>  		pr_debug("timeout value is zero\n");
>  		return -EINVAL;
>  	}
>  
> -	if (info->label[0] == '\0' ||
> -	    strnlen(info->label,
> +	if (label[0] == '\0' ||
> +	    strnlen(label,
>  		    MAX_IDLETIMER_LABEL_SIZE) == MAX_IDLETIMER_LABEL_SIZE) {
>  		pr_debug("label is empty or not nul-terminated\n");
>  		return -EINVAL;
> @@ -210,22 +257,31 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
>  
>  	mutex_lock(&list_mutex);
>  
> -	info->timer = __idletimer_tg_find_by_label(info->label);
> -	if (info->timer) {
> -		info->timer->refcnt++;
> -		if (time_before(info->timer->timer.expires, now)) {
> -			schedule_work(&info->timer->work);
> +	timer = __idletimer_tg_find_by_label(label);
> +	if (timer) {
> +		timer->refcnt++;
> +		timer->active = true;
> +
> +		if (time_before(timer->timer.expires, now)) {
> +			schedule_work(&timer->work);
>  			pr_debug("Starting Checkentry timer (Expired, Jiffies): %lu, %lu\n",
> -				info->timer->timer.expires, now);
> +				timer->timer.expires, now);
>  		}
> -		mod_timer(&info->timer->timer,
> -			  msecs_to_jiffies(info->timeout * 1000) + now);
> +		mod_timer(&timer->timer,
> +			  msecs_to_jiffies(timeout * 1000) + now);
>  
>  		pr_debug("increased refcnt of timer %s to %u\n",
> -			 info->label, info->timer->refcnt);
> +			 label, timer->refcnt);
>  	} else {
> -		ret = idletimer_tg_create(info);
> +		timer = kmalloc(sizeof(*timer), GFP_KERNEL);
> +		if (!timer) {
> +			ret = -ENOMEM;
> +			mutex_unlock(&list_mutex);
> +			return ret;
> +		}
> +		ret = idletimer_tg_create(timer, label, timeout, send_nl_msg);
>  		if (ret < 0) {
> +			kfree(timer);
>  			pr_debug("failed to create timer\n");
>  			mutex_unlock(&list_mutex);
>  			return ret;
> @@ -233,41 +289,80 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
>  	}
>  
>  	mutex_unlock(&list_mutex);
> +	*timer_ret = timer;
>  	return 0;
>  }
>  
> -static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
> +static void idletimer_tg_destroy_do(struct idletimer_tg *timer,
> +				    const char *label)
>  {
> -	const struct idletimer_tg_info *info = par->targinfo;
> -
> -	pr_debug("destroy targinfo %s\n", info->label);
> +	pr_debug("destroy targinfo %s\n", label);
>  
>  	mutex_lock(&list_mutex);
> -
> -	if (--info->timer->refcnt == 0) {
> -		pr_debug("deleting timer %s\n", info->label);
> -
> -		list_del(&info->timer->entry);
> -		del_timer_sync(&info->timer->timer);
> -		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
> -		kfree(info->timer->attr.attr.name);
> -		kfree(info->timer);
> +	if (--timer->refcnt == 0) {
> +		pr_debug("deleting timer %s\n", label);
> +
> +		list_del(&timer->entry);
> +		del_timer_sync(&timer->timer);
> +		sysfs_remove_file(idletimer_tg_kobj, &timer->attr.attr);
> +		kfree(timer->attr.attr.name);
> +		kfree(timer);
>  	} else {
>  		pr_debug("decreased refcnt of timer %s to %u\n",
> -			 info->label, info->timer->refcnt);
> +			 label, timer->refcnt);
>  	}
> -
>  	mutex_unlock(&list_mutex);
>  }
>  
> -static struct xt_target idletimer_tg __read_mostly = {
> +static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
> +{
> +	struct idletimer_tg_info *info = par->targinfo;
> +
> +	return idletimer_tg_checkentry_do(&info->timer, info->label,
> +		info->timeout, false);
> +}
> +
> +static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
> +{
> +	struct idletimer_tg_info_v1 *info = par->targinfo;
> +
> +	return idletimer_tg_checkentry_do(&info->timer, info->label,
> +		info->timeout, info->send_nl_msg);
> +}
> +
> +static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
> +{
> +	const struct idletimer_tg_info *info = par->targinfo;
> +	idletimer_tg_destroy_do(info->timer, info->label);
> +}
> +
> +static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
> +{
> +	const struct idletimer_tg_info_v1 *info = par->targinfo;
> +	idletimer_tg_destroy_do(info->timer, info->label);
> +}
> +
> +static struct xt_target idletimer_tg[] __read_mostly = {
> +{
>  	.name		= "IDLETIMER",
> +	.revision	= 0,
>  	.family		= NFPROTO_UNSPEC,
>  	.target		= idletimer_tg_target,
>  	.targetsize     = sizeof(struct idletimer_tg_info),
>  	.checkentry	= idletimer_tg_checkentry,
>  	.destroy        = idletimer_tg_destroy,
>  	.me		= THIS_MODULE,
> +},
> +{
> +	.name		= "IDLETIMER",
> +	.revision	= 1,
> +	.family		= NFPROTO_UNSPEC,
> +	.target		= idletimer_tg_target_v1,
> +	.targetsize     = sizeof(struct idletimer_tg_info_v1),
> +	.checkentry	= idletimer_tg_checkentry_v1,
> +	.destroy        = idletimer_tg_destroy_v1,
> +	.me		= THIS_MODULE,
> +},
>  };
>  
>  static struct class *idletimer_tg_class;
> @@ -295,7 +390,7 @@ static int __init idletimer_tg_init(void)
>  
>  	idletimer_tg_kobj = &idletimer_tg_device->kobj;
>  
> -	err =  xt_register_target(&idletimer_tg);
> +	err = xt_register_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
>  	if (err < 0) {
>  		pr_debug("couldn't register xt target\n");
>  		goto out_dev;
> @@ -312,7 +407,7 @@ out:
>  
>  static void __exit idletimer_tg_exit(void)
>  {
> -	xt_unregister_target(&idletimer_tg);
> +	xt_unregister_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
>  
>  	device_destroy(idletimer_tg_class, MKDEV(0, 0));
>  	class_destroy(idletimer_tg_class);
> @@ -327,3 +422,4 @@ MODULE_DESCRIPTION("Xtables: idle time monitor");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("ipt_IDLETIMER");
>  MODULE_ALIAS("ip6t_IDLETIMER");
> +MODULE_ALIAS("arpt_IDLETIMER");
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
