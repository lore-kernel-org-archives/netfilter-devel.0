From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 11/11] netfilter: xtables: print hook name instead of
 mask
Date: Sat, 09 May 2009 14:06:06 +1200
Message-ID: <4A04E50E.60705@treenet.co.nz>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de> <1241774801-2315-12-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:57165
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZEICGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 22:06:11 -0400
In-Reply-To: <1241774801-2315-12-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Users cannot make anything of these numbers. Let's just tell them
> directly.

Yay!
Thank you very, very much.

> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/netfilter/x_tables.c |   42 ++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 150e5cf..46dba5f 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -329,6 +329,32 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
>  }
>  EXPORT_SYMBOL_GPL(xt_find_revision);
>  
> +static char *textify_hooks(char *buf, size_t size, unsigned int mask)
> +{
> +	static const char *const names[] = {
> +		"PREROUTING", "INPUT", "FORWARD",
> +		"OUTPUT", "POSTROUTING", "BROUTING",
> +	};
> +	unsigned int i;
> +	char *p = buf;
> +	bool np = false;
> +	int res;
> +
> +	*p = '\0';
> +	for (i = 0; i < ARRAY_SIZE(names); ++i) {
> +		if (!(mask & (1 << i)))
> +			continue;
> +		res = snprintf(p, size, "%s%s", np ? "/" : "", names[i]);
> +		if (res > 0) {
> +			size -= res;
> +			p += res;
> +		}
> +		np = true;
> +	}
> +
> +	return buf;
> +}
> +
>  int xt_check_match(struct xt_mtchk_param *par,
>  		   unsigned int size, u_int8_t proto, bool inv_proto)
>  {
> @@ -351,9 +377,13 @@ int xt_check_match(struct xt_mtchk_param *par,
>  		return -EINVAL;
>  	}
>  	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
> -		printk("%s_tables: %s match: bad hook_mask %#x/%#x\n",
> +		char used[64], allow[64];
> +
> +		printk("%s_tables: %s match: used from hooks %s, but only "
> +		       "valid from %s\n",
>  		       xt_prefix[par->family], par->match->name,
> -		       par->hook_mask, par->match->hooks);
> +		       textify_hooks(used, sizeof(used), par->hook_mask),
> +		       textify_hooks(allow, sizeof(allow), par->match->hooks));
>  		return -EINVAL;
>  	}
>  	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
> @@ -497,9 +527,13 @@ int xt_check_target(struct xt_tgchk_param *par,
>  		return -EINVAL;
>  	}
>  	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
> -		printk("%s_tables: %s target: bad hook_mask %#x/%#x\n",
> +		char used[64], allow[64];
> +
> +		printk("%s_tables: %s target: used from hooks %s, but only "
> +		       "usable from %s\n",
>  		       xt_prefix[par->family], par->target->name,
> -		       par->hook_mask, par->target->hooks);
> +		       textify_hooks(used, sizeof(used), par->hook_mask),
> +		       textify_hooks(allow, sizeof(allow), par->target->hooks));
>  		return -EINVAL;
>  	}
>  	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
