From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC] netfilter: WIP: Xtables idletimer target implementation
Date: Fri, 28 May 2010 01:17:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005280057190.14077@obet.zrqbmnf.qr>
References: <1274993689-23928-1-git-send-email-luciano.coelho@nokia.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.or,
	kaber@trash.net, Timo Teras <timo.teras@iki.fi>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47397 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab0E0XRR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 19:17:17 -0400
In-Reply-To: <1274993689-23928-1-git-send-email-luciano.coelho@nokia.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-05-27 22:54, Luciano Coelho wrote:

>This patch implements an idletimer Xtables target that can be used to
>identify when interfaces have been idle for a certain period of time.
>
>It adds a file to the sysfs for each interface that is brought up.  The file
>contains the time remaining before the event is triggered.
>
>The timeout should be set when the Xtable rule is defined with the --timeout
>parameter set.
>
>There are still some issues to be resolved:
>
>How to treat several rules for the same interface?
>
>We need a key for the timer list.  I'm using the targinfo pointer for that,
>but this looks shaky, because there is no assurance that this pointer will
>live for the entire lifetime of the rule.

Well xt_quota for example has its targinfo around at all times,
as have other modules.

>This is now an x_tables target, so other protocols need to be implemented.

Huh? You're not looking at packets, so why does it need proto-specific
stuff?

>+static
>+struct utimer_t *__utimer_find_by_name(const char *name, const struct net *net)
>+{
>+	struct utimer_t *entry;
>+
>+	list_for_each_entry(entry, &active_utimer_head, entry) {
>+		if (!strcmp(name, entry->name) &&
>+		    (net == entry->net)) {
>+			return entry;
>+		}
>+	}
>+
>+	return NULL;
>+}
>+
>+static
>+struct utimer_t *__utimer_find_by_info(const struct xt_idletimer_info *info)
>+{
>+	struct utimer_t *entry;
>+
>+	list_for_each_entry(entry, &active_utimer_head, entry) {
>+		if (info == entry->info) {
>+			return entry;
>+		}
>+	}
>+
>+	return NULL;
>+}

Can do with less braces.

>+static void utimer_expired(unsigned long data)
>+{
>+	struct utimer_t *timer = (struct utimer_t *) data;
>+
>+	pr_debug("xt_idletimer: timer '%s' ns %p expired\n",
>+		 timer->name, timer->net);
>+
>+	schedule_work(&timer->work);
>+}

You don't need xt_idletimer, because pr_debug already prints
that (with #define pr_fmt(fmt) KBUILD_MODNAME ": " as many
other modules do)

>+
>+static struct utimer_t *utimer_create(const char *name,
>+				      struct net *net,
>+				      const struct xt_idletimer_info *info)
>+{
>+	struct utimer_t *timer;
>+
>+	timer = kmalloc(sizeof(struct utimer_t), GFP_ATOMIC);
>+	if (timer == NULL)
>+		return NULL;

This is called from user context, so GFP_KERNEL will perfectly suffice.

>+static int xt_idletimer_checkentry(const struct xt_tgchk_param *par)
>+{
>+	const struct xt_idletimer_info *info = par->targinfo;
>+	const struct ipt_entry *entryinfo = par->entryinfo;
>+	const struct ipt_ip *ip = &entryinfo->ip;

I'm not sure spying on ipt_ip is a long-term viable solution.

>+	pr_debug("xt_idletimer: checkentry targinfo %p\n", par->targinfo);
>+
>+	if (info->timeout == 0) {
>+		pr_debug("xt_idletimer: timeout value is zero\n");
>+		return -EINVAL;
>+	}
>+
>+	/* FIXME: implement support for other protocol families */
>+	switch (par->family) {
>+	case NFPROTO_IPV4   :
>+		pr_debug("xt_idletimer: NFPROTO_IPV4\n");
>+		break;
>+
>+	default:
>+		pr_debug("xt_idletimer: Unsupported protocol family family!\n");
>+		return -EINVAL;
>+	}
>+
>+	if (strlen(ip->iniface) == 0 && strlen(ip->outiface) == 0) {
>+		pr_debug("xt_idletimer: in or out interface must "
>+			 "be specified\n");
>+		return -EINVAL;
>+	}
>+
>+	if (utimer_create(ip->iniface, par->net, info) == NULL) {
>+		pr_debug("xt_idletimer: failed to create timer\n");
>+		return -ENOMEM;
>+	}

What about outiface?
What blows up when iniface is empty?

>+	return 0;
>+}
>+
>+static void xt_idletimer_destroy(const struct xt_tgdtor_param *par)
>+{
>+	const struct xt_idletimer_info *info = par->targinfo;
>+
>+	pr_debug("xt_idletimer: destroy targinfo %p\n", par->targinfo);
>+
>+	utimer_delete(info);
>+}
>+
>+static int __init init(void)
>+{
>+	int ret;
>+
>+	ret = utimer_init();
>+	if (ret)
>+		return ret;
>+
>+	ret =  xt_register_target(&xt_idletimer);
>+	if (ret < 0) {
>+		utimer_fini();
>+		return ret;
>+	}
>+
>+	return 0;
>+}
>+
>+static void __exit fini(void)
>+{
>+	xt_unregister_target(&xt_idletimer);
>+	utimer_fini();
>+}
>+
>+module_init(init);
>+module_exit(fini);

Call it just exit?
Also give the functions better names (see other modules), that is going
to be unrecognizable in stacktraces otherwise.
