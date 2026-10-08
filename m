Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FD5439328;
	Thu,  8 Oct 2026 23:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503694; cv=none; b=WaRqWsAsf6hqP2My6u3moHWQJumdCBMGUAY6M6JWbIj2jCA7q+UvSvONp0Dac8eyC3TzWcT8g6+ictpce2YTYyqGCONoPtyRkpDSt7BIDY91R4666N8UE6p9zfx0MS747TQv9Q1ahOvk4TpGUrLO1C/XxprJxUeY/+jtnGnl1ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503694; c=relaxed/simple;
	bh=lT6bMuGvxr4wfX9g+/OQ3uunV7ILTbo6DP36Hjm0S1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOga562cMCSCv5gSmnlxzONhc0ntBiwkvn9xFdCtOGF0x4ydcX6s4fZqmd0PNtU/AD93Ka84fq6sZhhlETgKP4HxThB8tVwwBryGVkzdDlJQKhZ98Hc+2swTfbjhuazS3el48JCu+mLwuYQcyNT3JUxd4HNmeUTTN6OdhC7C3y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MsBtIYl5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MsBtIYl5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791503687;
	bh=carbm3A9gqEiXfQkb8bfwX3rDProLXxaEC/Nl6yWI64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MsBtIYl5vpSb5tMKW2ph0rzsk9YdcnrUjU3SAWxF6VTVJ5M6JFoRZ8pP9wuIV4hYs
	 c3yJmPtparqVOuAwg91TVeoAnM0N2JiBnP/5is3NQQEkHhcTSbgxTZNXM7H7CUTeTb
	 LWUYXobxHY6yfk7o5atq5YwLCXIXy04GuWe5vxaLIqQ/h+iLSL1Yy52NDEPSpMFFlu
	 22qHOBLtPgjIRiS191C0vhxzzjUPYQp+8/YdFJt52IriCDidvljQhaN2GUbWlSFPUA
	 XebFPpFFJKIFvJFxy2abELIZ5g15SGdVG215vk0T7s+mhfcFK0WmWHjdKCThIHPMC+
	 p2z+2e+F3ZR6g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 005ED6005E;
	Fri,  9 Oct 2026 01:54:46 +0200 (CEST)
Date: Fri, 9 Oct 2026 01:54:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org
Subject: Re: [PATCH nf v3 1/1] netfilter: x_tables: avoid holding mutex over
 faultable user copies
Message-ID: <asgtQ3E2LVWqfV8D@chamomile>
References: <cover.1789885804.git.zihanx@nebusec.ai>
 <f88fc502b17b4022105a99eea407525807ee573e.1789885804.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f88fc502b17b4022105a99eea407525807ee573e.1789885804.git.zihanx@nebusec.ai>

On Sun, Sep 20, 2026 at 11:58:22AM +0000, Zihan Xi wrote:
> The legacy IPv4, IPv6 and ARP table GET_INFO and GET_ENTRIES paths hold
> the per-family xtables mutexes while copying table data to userspace. A
> faultable destination may sleep indefinitely while the mutex is held,
> blocking unrelated table and registry operations.
> 
> Disable page faults while each locked user copy runs. For GET_ENTRIES,
> validate the table and requested size while holding the table mutex, then
> release it before faulting in the output range. Reacquire the mutex and
> revalidate the table and size before the nofault copy. If a nofault copy
> fails, fault the range outside the lock and retry the operation up to three
> times after the initial attempt. A failed fault-in returns -EFAULT;
> repeated nofault failures are limited to four attempts in total and then
> return -EFAULT. This avoids discarding a locked counter snapshot on the
> common first fault. Move GET_INFO's fixed-size copy outside the table locks
> and apply the same fault-safe handling to the IPv4/IPv6 compat GET_ENTRIES
> paths.
> 
> The ebtables GET paths use a separate ebt_mutex and are outside this
> IPv4/IPv6/ARP series.

I keep spinning on this, and I am not sure this fix is the right thing
to do. There is no single caller of this pagefault_disable/enable() mm
subsystem function in the net folder.

Would it be feasible to turn this global family mutex into a per-netns
family mutex? xt_find_table_lock() could be revamped to make it?

The iteration over xt_templates[] still needs to hold the global
family lock, but only to create the table in that netns.

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Co-developed-by: Luxing Yin <root@tr0jan.top>
> Signed-off-by: Luxing Yin <root@tr0jan.top>
> Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
> ---
> changes in v3:
>   - Validate table and requested size before fault-in, then revalidate the
>     table and size after lock reacquisition in native and IPv4/IPv6 compat
>     GET_ENTRIES paths.
>   - Make retry semantics explicit: one initial nofault attempt followed by
>     at most three retries. Keep fault-in and retry decisions outside family
>     mutexes; failed fault-in and exhausted retries return -EFAULT.
>   - Keep the fixed-size GET_INFO copy outside table locks and brace compat
>     lookup error arms.
>   - Clarify ARP-only runtime coverage, privilege scope, helper build,
>     holder/waiter evidence, QEMU configuration, and the NOT RUN
>     crash-log status.
>   - Regenerate the numbered patch and cover with LF line endings; use the
>     standard 0001-*.patch filename.
>   - v2 Link:
>     https://lore.kernel.org/all/cover.1788961415.git.zihanx@nebusec.ai/
> changes in v2:
>   - Rebase onto current nf.git after 0bd7ed1a3263c
>     ("netfilter: arp_tables: remove the 32bit compat interface").
>     ARP GET_INFO and GET_ENTRIES use native paths only; IPv4 and IPv6
>     retain compat handling.
>   - Drop hung_task_panic and the 10-second hung_task timeout from the
>     reproducer, as pointed out by Pablo Neira Ayuso; observe holder/waiter
>     wchan instead.
>   - v1 Link:
>     https://lore.kernel.org/all/cover.1788244146.git.zihanx@nebusec.ai/
> 
>  net/ipv4/netfilter/arp_tables.c | 49 ++++++++++++++++---
>  net/ipv4/netfilter/ip_tables.c  | 87 +++++++++++++++++++++++++++++----
>  net/ipv6/netfilter/ip6_tables.c | 87 +++++++++++++++++++++++++++++----
>  3 files changed, 197 insertions(+), 26 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index db307fa..a857e67 100644
> --- a/net/ipv4/netfilter/arp_tables.c
7> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/mutex.h>
>  #include <linux/err.h>
> +#include <linux/pagemap.h>
>  #include <net/sock.h>
>  #include <linux/uaccess.h>
>  
> @@ -695,6 +696,7 @@ static int copy_entries_to_user(unsigned int total_size,
>  
>  	loc_cpu_entry = private->entries;
>  
> +	pagefault_disable();
>  	/* FIXME: use iterator macros --RR */
>  	/* ... then go back and fix counters and names */
>  	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
> @@ -719,12 +721,14 @@ static int copy_entries_to_user(unsigned int total_size,
>  	}
>  
>   free_counters:
> +	pagefault_enable();
>  	vfree(counters);
>  	return ret;
>  }
>  
>  static int get_info(struct net *net, void __user *user, const int *len)
>  {
> +	struct arpt_getinfo info;
>  	char name[XT_TABLE_MAXNAMELEN];
>  	struct xt_table *t;
>  	int ret;
> @@ -738,7 +742,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  	name[XT_TABLE_MAXNAMELEN-1] = '\0';
>  	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
>  	if (!IS_ERR(t)) {
> -		struct arpt_getinfo info;
>  		const struct xt_table_info *private = t->private;
>  
>  		memset(&info, 0, sizeof(info));
> @@ -751,15 +754,14 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  		info.size = private->size;
>  		strscpy(info.name, name);
>  
> -		if (copy_to_user(user, &info, *len) != 0)
> -			ret = -EFAULT;
> -		else
> -			ret = 0;
> +		ret = 0;
>  		xt_table_unlock(t);
>  		module_put(t->me);
>  	} else
>  		ret = PTR_ERR(t);
>  
> +	if (!ret && copy_to_user(user, &info, *len) != 0)
> +		ret = -EFAULT;
>  	return ret;
>  }
>  
> @@ -769,6 +771,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
>  	int ret;
>  	struct arpt_get_entries get;
>  	struct xt_table *t;
> +	unsigned int retries = 0;
>  
>  	if (*len < sizeof(get))
>  		return -EINVAL;
> @@ -779,21 +782,51 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
>  
>  	get.name[sizeof(get.name) - 1] = '\0';
>  
> +retry:
> +	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
> +	if (IS_ERR(t)) {
> +		ret = PTR_ERR(t);
> +		goto out;
> +	}
> +
> +	if (get.size != t->private->size) {
> +		ret = -EAGAIN;
> +		module_put(t->me);
> +		xt_table_unlock(t);
> +		goto out;
> +	}
> +
> +	module_put(t->me);
> +	xt_table_unlock(t);
> +
> +	/* Fault in only after validating the table and requested size. */
> +	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
> +				    get.size))
> +		return -EFAULT;
> +
>  	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
>  	if (!IS_ERR(t)) {
>  		const struct xt_table_info *private = t->private;
>  
> -		if (get.size == private->size)
> +		if (get.size != private->size) {
> +			ret = -EAGAIN;
> +		} else {
>  			ret = copy_entries_to_user(private->size,
>  						   t, uptr->entrytable);
> -		else
> -			ret = -EAGAIN;
> +		}
>  
>  		module_put(t->me);
>  		xt_table_unlock(t);
>  	} else
>  		ret = PTR_ERR(t);
>  
> +out:
> +	/* Allow three retries after the initial nofault copy. */
> +	if (ret == -EFAULT && retries < 3) {
> +		retries++;
> +		goto retry;
> +	}
> +
>  	return ret;
>  }
>  
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 809441c..90f4a26 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -21,6 +21,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/err.h>
>  #include <linux/cpumask.h>
> +#include <linux/pagemap.h>
>  
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter_ipv4/ip_tables.h>
> @@ -824,6 +825,7 @@ copy_entries_to_user(unsigned int total_size,
>  
>  	loc_cpu_entry = private->entries;
>  
> +	pagefault_disable();
>  	/* FIXME: use iterator macros --RR */
>  	/* ... then go back and fix counters and names */
>  	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
> @@ -861,6 +863,7 @@ copy_entries_to_user(unsigned int total_size,
>  	}
>  
>   free_counters:
> +	pagefault_enable();
>  	vfree(counters);
>  	return ret;
>  }
> @@ -943,6 +946,7 @@ static int compat_table_info(const struct xt_table_info *info,
>  
>  static int get_info(struct net *net, void __user *user, const int *len)
>  {
> +	struct ipt_getinfo info;
>  	char name[XT_TABLE_MAXNAMELEN];
>  	struct xt_table *t;
>  	int ret;
> @@ -960,7 +964,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  #endif
>  	t = xt_request_find_table_lock(net, AF_INET, name);
>  	if (!IS_ERR(t)) {
> -		struct ipt_getinfo info;
>  		const struct xt_table_info *private = t->private;
>  #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
>  		struct xt_table_info tmp;
> @@ -981,10 +984,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  		info.size = private->size;
>  		strscpy(info.name, name);
>  
> -		if (copy_to_user(user, &info, *len) != 0)
> -			ret = -EFAULT;
> -		else
> -			ret = 0;
> +		ret = 0;
>  
>  		xt_table_unlock(t);
>  		module_put(t->me);
> @@ -994,6 +994,8 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  	if (in_compat_syscall())
>  		xt_compat_unlock(AF_INET);
>  #endif
> +	if (!ret && copy_to_user(user, &info, *len) != 0)
> +		ret = -EFAULT;
>  	return ret;
>  }
>  
> @@ -1004,6 +1006,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
>  	int ret;
>  	struct ipt_get_entries get;
>  	struct xt_table *t;
> +	unsigned int retries = 0;
>  
>  	if (*len < sizeof(get))
>  		return -EINVAL;
> @@ -1013,20 +1016,50 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
>  		return -EINVAL;
>  	get.name[sizeof(get.name) - 1] = '\0';
>  
> +retry:
> +	t = xt_find_table_lock(net, AF_INET, get.name);
> +	if (IS_ERR(t)) {
> +		ret = PTR_ERR(t);
> +		goto out;
> +	}
> +
> +	if (get.size != t->private->size) {
> +		ret = -EAGAIN;
> +		module_put(t->me);
> +		xt_table_unlock(t);
> +		goto out;
> +	}
> +
> +	module_put(t->me);
> +	xt_table_unlock(t);
> +
> +	/* Fault in only after validating the table and requested size. */
> +	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
> +				    get.size))
> +		return -EFAULT;
> +
>  	t = xt_find_table_lock(net, AF_INET, get.name);
>  	if (!IS_ERR(t)) {
>  		const struct xt_table_info *private = t->private;
> -		if (get.size == private->size)
> +		if (get.size != private->size) {
> +			ret = -EAGAIN;
> +		} else {
>  			ret = copy_entries_to_user(private->size,
>  						   t, uptr->entrytable);
> -		else
> -			ret = -EAGAIN;
> +		}
>  
>  		module_put(t->me);
>  		xt_table_unlock(t);
>  	} else
>  		ret = PTR_ERR(t);
>  
> +out:
> +	/* Allow three retries after the initial nofault copy. */
> +	if (ret == -EFAULT && retries < 3) {
> +		retries++;
> +		goto retry;
> +	}
> +
>  	return ret;
>  }
>  
> @@ -1561,12 +1594,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
>  
>  	pos = userptr;
>  	size = total_size;
> +	pagefault_disable();
>  	xt_entry_foreach(iter, private->entries, total_size) {
>  		ret = compat_copy_entry_to_user(iter, &pos,
>  						&size, counters, i++);
>  		if (ret != 0)
>  			break;
>  	}
> +	pagefault_enable();
>  
>  	vfree(counters);
>  	return ret;
> @@ -1579,6 +1614,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
>  	int ret;
>  	struct compat_ipt_get_entries get;
>  	struct xt_table *t;
> +	unsigned int retries = 0;
>  
>  	if (*len < sizeof(get))
>  		return -EINVAL;
> @@ -1591,6 +1627,32 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
>  
>  	get.name[sizeof(get.name) - 1] = '\0';
>  
> +retry:
> +	xt_compat_lock(AF_INET);
> +	t = xt_find_table_lock(net, AF_INET, get.name);
> +	if (!IS_ERR(t)) {
> +		const struct xt_table_info *private = t->private;
> +		struct xt_table_info info;
> +
> +		ret = compat_table_info(private, &info);
> +		if (!ret && get.size != info.size)
> +			ret = -EAGAIN;
> +
> +		xt_compat_flush_offsets(AF_INET);
> +		module_put(t->me);
> +		xt_table_unlock(t);
> +	} else {
> +		ret = PTR_ERR(t);
> +	}
> +	xt_compat_unlock(AF_INET);
> +	if (ret)
> +		goto out;
> +
> +	/* Fault in only after validating the table and requested size. */
> +	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
> +				    get.size))
> +		return -EFAULT;
> +
>  	xt_compat_lock(AF_INET);
>  	t = xt_find_table_lock(net, AF_INET, get.name);
>  	if (!IS_ERR(t)) {
> @@ -1606,10 +1668,17 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
>  		xt_compat_flush_offsets(AF_INET);
>  		module_put(t->me);
>  		xt_table_unlock(t);
> -	} else
> +	} else {
>  		ret = PTR_ERR(t);
> +	}
>  
>  	xt_compat_unlock(AF_INET);
> +out:
> +	/* Allow three retries after the initial nofault copy. */
> +	if (ret == -EFAULT && retries < 3) {
> +		retries++;
> +		goto retry;
> +	}
>  	return ret;
>  }
>  #endif
> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> index f42fb96..4952bfd 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -25,6 +25,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/err.h>
>  #include <linux/cpumask.h>
> +#include <linux/pagemap.h>
>  
>  #include <linux/netfilter_ipv6/ip6_tables.h>
>  #include <linux/netfilter/x_tables.h>
> @@ -840,6 +841,7 @@ copy_entries_to_user(unsigned int total_size,
>  
>  	loc_cpu_entry = private->entries;
>  
> +	pagefault_disable();
>  	/* FIXME: use iterator macros --RR */
>  	/* ... then go back and fix counters and names */
>  	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
> @@ -877,6 +879,7 @@ copy_entries_to_user(unsigned int total_size,
>  	}
>  
>   free_counters:
> +	pagefault_enable();
>  	vfree(counters);
>  	return ret;
>  }
> @@ -959,6 +962,7 @@ static int compat_table_info(const struct xt_table_info *info,
>  
>  static int get_info(struct net *net, void __user *user, const int *len)
>  {
> +	struct ip6t_getinfo info;
>  	char name[XT_TABLE_MAXNAMELEN];
>  	struct xt_table *t;
>  	int ret;
> @@ -976,7 +980,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  #endif
>  	t = xt_request_find_table_lock(net, AF_INET6, name);
>  	if (!IS_ERR(t)) {
> -		struct ip6t_getinfo info;
>  		const struct xt_table_info *private = t->private;
>  #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
>  		struct xt_table_info tmp;
> @@ -997,10 +1000,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  		info.size = private->size;
>  		strcpy(info.name, name);
>  
> -		if (copy_to_user(user, &info, *len) != 0)
> -			ret = -EFAULT;
> -		else
> -			ret = 0;
> +		ret = 0;
>  
>  		xt_table_unlock(t);
>  		module_put(t->me);
> @@ -1010,6 +1010,8 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  	if (in_compat_syscall())
>  		xt_compat_unlock(AF_INET6);
>  #endif
> +	if (!ret && copy_to_user(user, &info, *len) != 0)
> +		ret = -EFAULT;
>  	return ret;
>  }
>  
> @@ -1020,6 +1022,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
>  	int ret;
>  	struct ip6t_get_entries get;
>  	struct xt_table *t;
> +	unsigned int retries = 0;
>  
>  	if (*len < sizeof(get))
>  		return -EINVAL;
> @@ -1030,20 +1033,50 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
>  
>  	get.name[sizeof(get.name) - 1] = '\0';
>  
> +retry:
> +	t = xt_find_table_lock(net, AF_INET6, get.name);
> +	if (IS_ERR(t)) {
> +		ret = PTR_ERR(t);
> +		goto out;
> +	}
> +
> +	if (get.size != t->private->size) {
> +		ret = -EAGAIN;
> +		module_put(t->me);
> +		xt_table_unlock(t);
> +		goto out;
> +	}
> +
> +	module_put(t->me);
> +	xt_table_unlock(t);
> +
> +	/* Fault in only after validating the table and requested size. */
> +	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
> +				    get.size))
> +		return -EFAULT;
> +
>  	t = xt_find_table_lock(net, AF_INET6, get.name);
>  	if (!IS_ERR(t)) {
>  		struct xt_table_info *private = t->private;
> -		if (get.size == private->size)
> +		if (get.size != private->size) {
> +			ret = -EAGAIN;
> +		} else {
>  			ret = copy_entries_to_user(private->size,
>  						   t, uptr->entrytable);
> -		else
> -			ret = -EAGAIN;
> +		}
>  
>  		module_put(t->me);
>  		xt_table_unlock(t);
>  	} else
>  		ret = PTR_ERR(t);
>  
> +out:
> +	/* Allow three retries after the initial nofault copy. */
> +	if (ret == -EFAULT && retries < 3) {
> +		retries++;
> +		goto retry;
> +	}
> +
>  	return ret;
>  }
>  
> @@ -1570,12 +1603,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
>  
>  	pos = userptr;
>  	size = total_size;
> +	pagefault_disable();
>  	xt_entry_foreach(iter, private->entries, total_size) {
>  		ret = compat_copy_entry_to_user(iter, &pos,
>  						&size, counters, i++);
>  		if (ret != 0)
>  			break;
>  	}
> +	pagefault_enable();
>  
>  	vfree(counters);
>  	return ret;
> @@ -1588,6 +1623,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
>  	int ret;
>  	struct compat_ip6t_get_entries get;
>  	struct xt_table *t;
> +	unsigned int retries = 0;
>  
>  	if (*len < sizeof(get))
>  		return -EINVAL;
> @@ -1600,6 +1636,32 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
>  
>  	get.name[sizeof(get.name) - 1] = '\0';
>  
> +retry:
> +	xt_compat_lock(AF_INET6);
> +	t = xt_find_table_lock(net, AF_INET6, get.name);
> +	if (!IS_ERR(t)) {
> +		const struct xt_table_info *private = t->private;
> +		struct xt_table_info info;
> +
> +		ret = compat_table_info(private, &info);
> +		if (!ret && get.size != info.size)
> +			ret = -EAGAIN;
> +
> +		xt_compat_flush_offsets(AF_INET6);
> +		module_put(t->me);
> +		xt_table_unlock(t);
> +	} else {
> +		ret = PTR_ERR(t);
> +	}
> +	xt_compat_unlock(AF_INET6);
> +	if (ret)
> +		goto out;
> +
> +	/* Fault in only after validating the table and requested size. */
> +	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
> +				    get.size))
> +		return -EFAULT;
> +
>  	xt_compat_lock(AF_INET6);
>  	t = xt_find_table_lock(net, AF_INET6, get.name);
>  	if (!IS_ERR(t)) {
> @@ -1615,10 +1677,17 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
>  		xt_compat_flush_offsets(AF_INET6);
>  		module_put(t->me);
>  		xt_table_unlock(t);
> -	} else
> +	} else {
>  		ret = PTR_ERR(t);
> +	}
>  
>  	xt_compat_unlock(AF_INET6);
> +out:
> +	/* Allow three retries after the initial nofault copy. */
> +	if (ret == -EFAULT && retries < 3) {
> +		retries++;
> +		goto retry;
> +	}
>  	return ret;
>  }
>  #endif
> -- 
> 2.55.0.windows.3
> 
> 
