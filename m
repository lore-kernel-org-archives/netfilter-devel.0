Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B9359B680;
	Tue,  8 Sep 2026 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890645; cv=none; b=lC+F2L20gETRaC91jFmjz+qDo0QfmHQ/6UaYZxVNlcijsqvlFRATnkVXwe7ZOS8vNG1LIw77oGIffo21mSoCyXgusTWN+JOhVhmXhD/82uG5HIMSjeeC3YIWU1fqYGQtaZwZxppShFIP4545Qzqia9F/0UTlqsvWTqgmiaZP/Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890645; c=relaxed/simple;
	bh=Ctd1KS+4jf7JMt3sCdm3ZYVsTiwXj1II+3wdUH/wZpA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q1WfvOfL/tp8w+Go0B9AMudCbVg7BGQCKjaHJ7+tR01Hldy9IXxsqr1WpmCpBXuuya67kitUXNQ5iPNvdEtgVcm2y4LVpfNJ1HR77YqQTGcOjRcDxPZ0qz62BfDQ7HLF07uAcbCjjfLd/v98TwWprgJZP+90UKq8Trpb7aoqKXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzzWEl04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzzWEl04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5288B1F00A3D;
	Tue,  8 Sep 2026 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788890643;
	bh=buhByO91OPmUw3TQNbYRrcJuDVj7u7MVKgqm1Neb8Pw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gzzWEl04lr2hm75tAH8xRjdei7lSGGPC2tLhYrmF8FeqWgdyYgeOLzcyIlZcNeTOQ
	 WhPXDbLm+VArnPBCCnDW8BS5AY2YupzxRKSz4314Ly4LNKZcYhrwSjoEWZ+MUvY8yQ
	 H+YXNxJhqvD3VUrCzpchYIoDtfNl6kUxF2GtpTXXlEd1I5F2nrz5GdeblNCK9Ko7Zj
	 GCv3K2lkgUVHmJEwenF9FziFYYgkMKco1F7GqrkuYYnSFpl8bVY3a/vlGQNnPPA7NB
	 bOBoYFCXH86hC33+HyvJYH2NFVb90CoRC1ExII/uMGVEM8xg3mbF8N8EaZPwiL3Yns
	 Et+usJ7e06uDw==
Subject:
 Re: [PATCH net 7/9] netfilter: arp_tables: remove the 32bit compat interface
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 08 Sep 2026 18:04:02 +0000
Message-ID: <178889064289.219967.7333044974025476861@kernel.org>
In-Reply-To: <20260907171732.1407739-8-pablo@netfilter.org>
References: <20260907171732.1407739-8-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] The arptables 32-bit compat interface is only partially removed.

--

netfilter: arp_tables: remove the 32bit compat interface

This removes all arptables-specific 32-bit compat translation code from
net/ipv4/netfilter/arp_tables.c, drops struct compat_arpt_entry and its
accessor from include/linux/netfilter_arp/arp_tables.h, and updates the
NETFILTER_XTABLES_COMPAT help text to no longer mention arp.

> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index a87e07e80d0de..db307fa49f3f6 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c

[ ... ]

> @@ -811,23 +736,11 @@ static int get_info(struct net *net, void __user *user, const int *len)
>  		return -EFAULT;
>  
>  	name[XT_TABLE_MAXNAMELEN-1] = '\0';
> -#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> -	if (in_compat_syscall())
> -		xt_compat_lock(NFPROTO_ARP);
> -#endif
>  	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
>  	if (!IS_ERR(t)) {
>  		struct arpt_getinfo info;
>  		const struct xt_table_info *private = t->private;
> -#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> -		struct xt_table_info tmp;
>  
> -		if (in_compat_syscall()) {
> -			ret = compat_table_info(private, &tmp);
> -			xt_compat_flush_offsets(NFPROTO_ARP);
> -			private = &tmp;
> -		}
> -#endif
>  		memset(&info, 0, sizeof(info));
>  		info.valid_hooks = t->valid_hooks;
>  		memcpy(info.hook_entry, private->hook_entry,

[ ... ]

> @@ -1432,12 +981,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
>  
>  	switch (cmd) {
>  	case ARPT_SO_SET_REPLACE:
> -#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> -		if (in_compat_syscall())
> -			ret = compat_do_replace(sock_net(sk), arg, len);
> -		else
> -#endif
> -			ret = do_replace(sock_net(sk), arg, len);
> +		ret = do_replace(sock_net(sk), arg, len);
>  		break;
>  
>  	case ARPT_SO_SET_ADD_COUNTERS:

[Severity: Low]

Should the two arptables ctl handlers also stop accepting compat callers?
Both do_arpt_set_ctl() and do_arpt_get_ctl() still start with:

	if (!xt_compat_check())
		return -EPERM;

and that helper intentionally lets 32-bit callers continue when
CONFIG_NETFILTER_XTABLES_COMPAT is set:

include/linux/netfilter/x_tables.h:xt_compat_check() {
	if (!in_compat_syscall())
		return true;

	pr_warn_once("%s %s\n",
		     "xtables 32bit compat interface no longer supported",
		     "in namespaces and will be removed soon.");

	if (!capable(CAP_NET_ADMIN))
		return false;
#endif
	return true;
}

So a 32-bit task with CAP_NET_ADMIN now falls straight into the native
handlers, which gives three different behaviours:

ARPT_SO_GET_INFO succeeds and copies out the native xt_table_info values,
since the compat_table_info() rescaling above is gone:

		memcpy(info.hook_entry, private->hook_entry,
		       sizeof(info.hook_entry));
		memcpy(info.underflow, private->underflow,
		       sizeof(info.underflow));
		info.num_entries = private->number;
		info.size = private->size;

Are those offsets and size still meaningful to a caller that will walk them
using the 32-bit struct arpt_entry layout?

ARPT_SO_SET_REPLACE and ARPT_SO_GET_ENTRIES end up failing with -EINVAL
purely as a side effect of header size arithmetic in do_replace() and
get_entries() (76 vs 80 bytes for the replace header, 36 + size vs
40 + size for the get_entries header) rather than a defined unsupported
error.  Would an explicit rejection be clearer here, for example:

	if (in_compat_syscall())
		return -EOPNOTSUPP;

ARPT_SO_SET_ADD_COUNTERS keeps a working 32-bit ABI, because
do_add_counters() -> xt_copy_counters() still carries its own compat branch
that converts compat_xt_counters_info for every family, NFPROTO_ARP
included:

net/netfilter/x_tables.c:xt_copy_counters() {
#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
	if (in_compat_syscall()) {
		/* structures only differ in size due to alignment */
		struct compat_xt_counters_info compat_tmp;
	...
}

Does "remove the 32bit compat interface" then hold for that sockopt?  If
leaving the shared counter path compat-capable until the other three
flavors are converted is intended, could the commit message say so?

One more asymmetry: the ip_tables, ip6_tables and ebtables ctl handlers
still branch on in_compat_syscall() after the same xt_compat_check() call,
so the shared helper now means "translate" for those flavors and "warn,
then run the native path" for arptables.  Along the same lines, a 32-bit
task without CAP_NET_ADMIN now gets -EPERM plus a warning about a compat
interface that no longer exists for this flavor.

> @@ -1466,12 +1010,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
>  		break;
>  
>  	case ARPT_SO_GET_ENTRIES:
> -#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> -		if (in_compat_syscall())
> -			ret = compat_get_entries(sock_net(sk), user, len);
> -		else
> -#endif
> -			ret = get_entries(sock_net(sk), user, len);
> +		ret = get_entries(sock_net(sk), user, len);
>  		break;
>  
>  	case ARPT_SO_GET_REVISION_TARGET: {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260907171732.1407739-2-pablo%40netfilter.org
