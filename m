From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 5/7] netfilter: ebtables: add CONFIG_COMPAT support
Date: Sun, 7 Feb 2010 23:43:45 +0100
Message-ID: <20100207224345.GB27427@Chamillionaire.breakpoint.cc>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
 <1265334195-28120-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60228 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab0BGWnr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:43:47 -0500
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1NeFqz-0001rV-Ty
	for netfilter-devel@vger.kernel.org; Sun, 07 Feb 2010 23:43:45 +0100
Content-Disposition: inline
In-Reply-To: <1265334195-28120-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> From: Florian Westphal <fwestphal@astaro.com>
> 
> Main code for 32 bit userland ebtables binary with 64 bit kernels
> support.

[..]

> +static int compat_copy_everything_to_user(struct ebt_table *t, void __user *user,
> +   int *len, int cmd)
[..]

> +	if (tmp.num_counters) {
> +		if (tmp.num_counters != tinfo.nentries) {
> +			BUGPRINT("Num_counters wrong\n");
> +			return -EINVAL;
> +		}
> +		counterstmp = vmalloc(tinfo.nentries * sizeof(*counterstmp));
> +		if (!counterstmp)
> +			return -ENOMEM;
> +
> +		write_lock_bh(&t->lock);
> +		get_counters(oldcounters, counterstmp, tinfo.nentries);
> +		write_unlock_bh(&t->lock);
> +
> +		buf = compat_ptr(tmp.counters);
> +		if (copy_to_user(buf, counterstmp, tinfo.nentries * sizeof(*counterstmp))) {
> +			vfree(counterstmp);
> +			return -EFAULT;
> +		}
> +		vfree(counterstmp);
> +	}

This almost identical to the non-compat case; I'll move this to a common
helper in the next iteration.

Also, compat_do_ebt_get_ctl() does not have the required *len check.
Will fix in next revision.
