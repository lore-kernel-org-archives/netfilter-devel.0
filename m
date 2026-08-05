Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C290431985D;
	Wed,  5 Aug 2026 00:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888933; cv=none; b=jZlGGic3h9VCtCx7EZEtqZ5AodWw/VNFtE7XH3TQiGBaiuS0a8J1Ksh3PqsgOaeJOwO9jRXocz1q2Ww9pCIDu+AKY5DX7GAbyCf8p03ssRzETL8ExT2eW4IWKPBZwGqSiAMszyQ2MqzRgwCBUWhJZ/UJgV1erAbVazdbyNZfyfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888933; c=relaxed/simple;
	bh=I6hYB4l9xUONdHwwGt1RRvzZc+lDqH2mSH4mr4iDlI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK/zuQqGhdrRMBDZgkbV10H7g5DZvW2fl81h+U7WsR9GICns5f/wG9V3yqljPfKBnfmTbWNE4QvRTWeQTAFNLlfgEgY31QD1i99Zi4z2GC/2cVYLvyo2c7EhTpBEiFfzOXpxME1WAkNGMkMfY9yAjao8DvW+qzH5Xs/oQsxjHcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2qi/CQc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2qi/CQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE521F00A3A;
	Wed,  5 Aug 2026 00:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785888931;
	bh=zewP3f5UlA6W8t2+qpRTkscmoogw9bxWmIIQuKCiU3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2qi/CQcBvcVomQSbQsT4+spJiNhPFNxOQ5iUcvim6Sb6FpQMC/l6rnv4ZYu1OlUZ
	 Xl5GfiuJYqoiXAn64BPAlwc3QWnNbL7lDQRVAg8bOcCy4UYTTkEjuk7vSu+QFBkHkz
	 Cc6DgJgmFut9csQ2Myq7tevyv2I55ydziNHYKqDNF7a04d/gujQDfXgNq+qpOt5MzQ
	 U5/kmxuER0oREYKND+MFg6B2Jd2YqGq2EEc0STgUeZzhv0al4ehlVS/H/5R5k5NxFw
	 +mlUDpdNKpD4qjSKaeaHZCXGB6tx4Ox0RZjoT7LZoh56Ug4aWn8TP9ASt8ylqbRpZm
	 m95XhPMTvC+Fw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 02/10] netfilter: ebt_nflog: pin the NFLOG backend
Date: Tue,  4 Aug 2026 17:15:29 -0700
Message-ID: <20260805001529.3978646-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731151806.849724-3-pablo@netfilter.org>
References: <20260731151806.849724-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: ebt_nflog: pin the NFLOG backend

This adds a module reference on the ULOG logger when an ebtables nflog
rule is validated, and drops it from a new .destroy callback, so that
nfnetlink_log cannot be unloaded while such a rule is installed.  It also
requests the nfnetlink_log module for legacy (non nft_compat) callers.

A few questions about the change and the commit message.

> nf_log_unregister() runs after the per-net teardown so its final RCU
> grace period also drains readers that obtained the logger from a per-net
> binding.

[Severity: High]
Is this description accurate?  This isn't a bug introduced by this patch,
but the ordering seems to be the other way around.

nfnetlink_log_fini() frees the per-net state first:

net/netfilter/nfnetlink_log.c:nfnetlink_log_fini() {
	...
	unregister_pernet_subsys(&nfnl_log_net_ops);
	nf_log_unregister(&nfulnl_logger);
	...
}

unregister_pernet_subsys() reaches ops_undo_list(), where the only
synchronize_rcu() happens before the exit callbacks run, and the kfree
follows immediately after them:

net/core/net_namespace.c:ops_undo_list() {
	...
	list_for_each_entry_continue_reverse(ops, ops_list, list)
		ops_exit_list(ops, net_exit_list);

	ops = saved_ops;
	list_for_each_entry_continue_reverse(ops, ops_list, list)
		ops_free_list(ops, net_exit_list);
	...
}

So the grace period inside nf_log_unregister() runs after struct
nfnl_log_net has already been freed, which would mean it protects the
module text rather than the per-net data.

Does the per-net binding path stay exposed after this patch?  A logger
bound per-net (sysctl /proc/sys/net/netfilter/nf_log/<pf>, or
nf_log_bind_pf()) is only cleared in the pernet exit hook:

net/netfilter/nfnetlink_log.c:nfnl_log_net_exit() {
	nf_log_unset(net, &nfulnl_logger);
	...
}

and nf_log_unset() does not wait for readers, since the grace period was
removed by the commit named in the Fixes: tag:

net/netfilter/nf_log.c:nf_log_unset() {
	...
			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
	...
}

A reader that resolved the logger through the per-net branch of
nf_log_packet():

	if (loginfo != NULL)
		logger = rcu_dereference(loggers[pf][loginfo->type]);
	else
		logger = rcu_dereference(net->nf.nf_loggers[pf]);

can still be inside nfulnl_log_packet() -> nfnl_log_pernet(net) ->
instance_lookup_get_rcu() -> __instance_lookup() when ops_free_list()
frees the blob, which is the same KASAN signature quoted above with no
ebtables rule involved.  Reachable loginfo == NULL callers today include
nf_log_trace(), the conntrack helper log in net/netfilter/nf_conntrack_helper.c
and net/netfilter/nfnetlink_osf.c.

Would reordering nfnetlink_log_fini() so that nf_log_unregister() runs
before unregister_pernet_subsys() close all of the frontends at once?

> diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
> index 61bf8f4465ab7..426f8adc912c7 100644
> --- a/net/bridge/netfilter/ebt_nflog.c
> +++ b/net/bridge/netfilter/ebt_nflog.c
> @@ -41,11 +41,25 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  static int ebt_nflog_tg_check(const struct xt_tgchk_param *par)
>  {
>  	struct ebt_nflog_info *info = par->targinfo;
> +	int ret;
>  
>  	if (info->flags & ~EBT_NFLOG_MASK)
>  		return -EINVAL;
>  	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
> -	return 0;
> +
> +	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);

[Severity: Medium]
Should the commit message mention that this can reject rulesets that used
to load?  ebt_nflog_tg_check() previously returned 0 unconditionally, so an
ebtables nflog rule installed fine and simply logged nothing when
loggers[pf][NF_LOG_TYPE_ULOG] was NULL.  Now the raw -ENOENT from
nf_logger_find_get() is propagated out through xt_check_target(), so
ebtables -A ... --nflog and ebtables-restore fail.  This seems worth
spelling out given the Cc: stable.

Also, is the stated parity with xt_NFLOG complete?  NETFILTER_XT_TARGET_NFLOG
carries select NETFILTER_NETLINK_LOG in net/netfilter/Kconfig, while
BRIDGE_EBT_NFLOG has no select or depends:

net/bridge/netfilter/Kconfig:
config BRIDGE_EBT_NFLOG
	tristate "ebt: nflog support"
	help
	  This option enables the nflog watcher, which allows to LOG
	  messages through the netfilter logging API, which can use
	  either the old LOG target, the old ULOG target or nfnetlink_log
	  as backend.

On a kernel with CONFIG_BRIDGE_EBT_NFLOG set and
CONFIG_NETFILTER_NETLINK_LOG=n, the request_module() fallback below can
never succeed, so the target becomes unusable.  Should a
select NETFILTER_NETLINK_LOG be added here?  The help text claiming the
watcher can use the old LOG or ULOG targets as backend also no longer
matches the code.

> +	if (ret != 0 && !par->nft_compat) {
> +		request_module("%s", "nfnetlink_log");
> +
> +		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
> +	}
> +
> +	return ret;

[Severity: Medium]
Who loads nfnetlink_log for the nft_compat case?  The !par->nft_compat
skip is copied from xt_NFLOG, but xt_NFLOG also declares
MODULE_SOFTDEP("pre: nfnetlink_log"), and ebt_nflog.c has no
MODULE_SOFTDEP at all, so demand-loading ebt_nflog through
xt_request_find_target(NFPROTO_BRIDGE, "nflog", rev) does not bring in the
backend.

The -ENOENT recovery in nft_compat only matches the uppercase names:

net/netfilter/nft_compat.c:nft_target_init() {
	...
		if (ret == -ENOENT) {
			const char *modname = NULL;

			if (strcmp(target->name, "LOG") == 0)
				modname = "nf_log_syslog";
			else if (strcmp(target->name, "NFLOG") == 0)
				modname = "nfnetlink_log";

			if (modname &&
			    nft_request_module(ctx->net, "%s", modname) == -EAGAIN)
				return -EAGAIN;
		}
	...
}

The target registered here is .name = "nflog", so modname stays NULL, no
module is requested and there is no -EAGAIN retry.  Does an nftables
bridge-family compat rule using nflog now fail with -ENOENT unless
nfnetlink_log is already resident, where it succeeded before?  Adding
MODULE_SOFTDEP("pre: nfnetlink_log") to ebt_nflog.c, or extending the name
mapping in nft_target_init(), would seem to cover it.

> +}
> +
> +static void ebt_nflog_tg_destroy(const struct xt_tgdtor_param *par)
> +{
> +	nf_logger_put(par->family, NF_LOG_TYPE_ULOG);
>  }
>  
>  static struct xt_target ebt_nflog_tg_reg __read_mostly = {
> @@ -54,6 +68,7 @@ static struct xt_target ebt_nflog_tg_reg __read_mostly = {
>  	.family     = NFPROTO_BRIDGE,
>  	.target     = ebt_nflog_tg,
>  	.checkentry = ebt_nflog_tg_check,
> +	.destroy    = ebt_nflog_tg_destroy,
>  	.targetsize = sizeof(struct ebt_nflog_info),
>  	.me         = THIS_MODULE,
>  };
