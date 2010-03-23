From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/9] netfilter: xtables: slightly better error reporting
 (2/2)
Date: Tue, 23 Mar 2010 15:44:33 +0100
Message-ID: <4BA8D3D1.7000409@trash.net>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-8-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59349 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab0CWOof (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:44:35 -0400
In-Reply-To: <1269285486-22653-8-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
> index c9ee5c4..33213d6 100644
> --- a/net/ipv4/netfilter/ipt_LOG.c
> +++ b/net/ipv4/netfilter/ipt_LOG.c
> @@ -445,7 +445,7 @@ static int log_tg_check(const struct xt_tgchk_param *par)
>  
>  	if (loginfo->level >= 8) {
>  		pr_debug("level %u >= 8\n", loginfo->level);
> -		return false;
> +		return -EDOM;
>   

Mhh is that really a "Math argument out of domain of func"? ERANGE seems
slightly
better fitting to me.

>  	}
>  	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
>  		pr_debug("prefix is not null-terminated\n");
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 4e84d8a..6ead6e0 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -363,6 +363,8 @@ static char *textify_hooks(char *buf, size_t size, unsigned int mask)
>  int xt_check_match(struct xt_mtchk_param *par,
>  		   unsigned int size, u_int8_t proto, bool inv_proto)
>  {
> +	int ret;
> +
>  	if (XT_ALIGN(par->match->matchsize) != size &&
>  	    par->match->matchsize != -1) {
>  		/*
> @@ -399,8 +401,13 @@ int xt_check_match(struct xt_mtchk_param *par,
>  		       par->match->proto);
>  		return -EINVAL;
>  	}
> -	if (par->match->checkentry != NULL && !par->match->checkentry(par))
> -		return -EINVAL;
> +	if (par->match->checkentry != NULL) {
> +		ret = par->match->checkentry(par);
> +		if (ret < 0)
> +			return ret;
> +		else if (ret == 0)
> +			return -EINVAL;
>   
I'd suggest to do the true/false conversion before this patch. Currently I
don't understand the split of these patches, this one keeps lots of boolean
return values and initializations, but changes some.

> --- a/net/netfilter/xt_CONNSECMARK.c
> +++ b/net/netfilter/xt_CONNSECMARK.c
> @@ -87,6 +87,7 @@ connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
>  static int connsecmark_tg_check(const struct xt_tgchk_param *par)
>  {
>  	const struct xt_connsecmark_target_info *info = par->targinfo;
> +	int ret;
>  
>  	if (strcmp(par->table, "mangle") != 0 &&
>  	    strcmp(par->table, "security") != 0) {
> @@ -102,13 +103,14 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
>  
>  	default:
>  		pr_info("invalid mode: %hu\n", info->mode);
> -		return false;
> +		return -EDOM;
>   

Actually EINVAL does seem like the best fit here.
>
> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
> index 1a3e3dd..899da12 100644
> --- a/net/netfilter/xt_LED.c
> +++ b/net/netfilter/xt_LED.c
> @@ -93,7 +93,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
>  
>  	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
>  	if (!ledinternal)
> -		return false;
> +		return -ENOMEM;
>  
>  	ledinternal->netfilter_led_trigger.name = ledinfo->id;
>  
> @@ -102,7 +102,8 @@ static int led_tg_check(const struct xt_tgchk_param *par)
>  		pr_warning("led_trigger_register() failed\n");
>  		if (err == -EEXIST)
>  			pr_warning("Trigger name is already in use.\n");
> -		goto exit_alloc;
> +		kfree(ledinternal);
> +		return err;
>  	}
>  
>  	/* See if we need to set up a timer */
> @@ -111,13 +112,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
>  			    (unsigned long)ledinfo);
>  
>  	ledinfo->internal_data = ledinternal;
> -
>  	return true;
>   
^^ return true? I'd also prefer to keep the goto-based error handling.
> -
> -exit_alloc:
> -	kfree(ledinternal);
> -
> -	return false;
>  }
>  
> diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
> index 48f8e4f..6525eee 100644
> --- a/net/netfilter/xt_SECMARK.c
> +++ b/net/netfilter/xt_SECMARK.c
> @@ -50,7 +50,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
>  	return XT_CONTINUE;
>  }
>  
> -static bool checkentry_selinux(struct xt_secmark_target_info *info)
> +static int checkentry_selinux(struct xt_secmark_target_info *info)
>  {
>  	int err;
>  	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
> @@ -62,18 +62,18 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
>  		if (err == -EINVAL)
>  			pr_info("invalid SELinux context \'%s\'\n",
>  				sel->selctx);
> -		return false;
> +		return err;
>  	}
>  
>  	if (!sel->selsid) {
>  		pr_info("unable to map SELinux context \'%s\'\n", sel->selctx);
> -		return false;
> +		return -ENOENT;
>  	}
>  
>  	err = selinux_secmark_relabel_packet_permission(sel->selsid);
>  	if (err) {
>  		pr_info("unable to obtain relabeling permission\n");
> -		return false;
> +		return err;
>  	}
>  
>  	selinux_secmark_refcount_inc();
>   
Missing conversion of "return true" at the end?

> @@ -83,6 +83,7 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
>  static int secmark_tg_check(const struct xt_tgchk_param *par)
>  {
>  	struct xt_secmark_target_info *info = par->targinfo;
> +	int err;
>  
>  	if (strcmp(par->table, "mangle") != 0 &&
>  	    strcmp(par->table, "security") != 0) {
> @@ -99,13 +100,14 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
>  
>  	switch (info->mode) {
>  	case SECMARK_MODE_SEL:
> -		if (!checkentry_selinux(info))
> -			return false;
> +		err = checkentry_selinux(info);
> +		if (err <= 0)
>   
<= ?

> +			return err;
>  		break;
>  
>  	default:
>  		pr_info("invalid mode: %hu\n", info->mode);
> -		return false;
> +		return -EDOM;
>  	}
>  
>  	if (!mode)
>   
I stopped here since I don't understand the logic this partial conversion
follows.
