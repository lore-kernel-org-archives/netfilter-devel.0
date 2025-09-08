Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522B71DDC3F;
	Mon,  8 Sep 2025 21:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757368631; cv=none; b=AHAkAbyAE//a2M/LzMYW3LFqU5/VeTy7PHpHhVnr5bcm5pnL9GQdyfN8p+nfkj38fUHXtH2iqSCgkPRoQQiNA4qETXIvgCU0tz9M7u91l7hxHNH7IQZz5abpwxXv3aMOKLoHv30eJwHuH6EQoxxqmmbPk96qSOQDY3J6j9izO3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757368631; c=relaxed/simple;
	bh=fW54aRAXirLB0eQdaAbwHD8trBvXi9bedluXmPGVKIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLfxUulbRIWRh/OS0yCl5w51DGePDZ96lc6+9RhYXtG3fvXWyZqWCw58827uFzqh/Hru9Je5vPmKNcExSgxPOvXRdYTQji8NUcMHi/Cp0Lo4laZVupqL1tdFxCBYtmFFcVKVKfNtU1mTm12YwaVWZ3GSB5h/7NOivT+Z2jvoun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DD1AD601EB; Mon,  8 Sep 2025 23:56:54 +0200 (CEST)
Date: Mon, 8 Sep 2025 23:56:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 nf-next 2/3] netfilter: nf_flow_table_core: teardown
 direct xmit when destination changed
Message-ID: <aL9RJtdQJr7t5Z_K@strlen.de>
References: <20250617070007.23812-1-ericwouds@gmail.com>
 <20250617070007.23812-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617070007.23812-3-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> +static int nf_flow_table_switchdev_event(struct notifier_block *unused,
> +					 unsigned long event, void *ptr)
> +{
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +	struct nf_flowtable *flowtable;
> +	struct flow_cleanup_data cud;
> +
> +	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE)
> +		return NOTIFY_DONE;
> +
> +	fdb_info = ptr;
> +	cud.addr = fdb_info->addr;
> +	cud.vid = fdb_info->vid;
> +	cud.ifindex = fdb_info->info.dev->ifindex;
> +
> +	mutex_lock(&flowtable_lock);

Please always test your patches with lockdep enabled,
this doesn't work.  Switchdev notifiers are atomic.

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:575
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1570, name: kworker/u32:8
preempt_count: 201, expected: 0
RCU nest depth: 1, expected: 0
6 locks held by kworker/u32:8/1570:
 #0: ffff88810032b948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x8d7/0x1460
 #1: ffffc900021e7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x912/0x1460
 #2: ffffffff848d1eb0 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf8/0x7b0
 #3: ffffffff848de6e8 (rtnl_mutex){+.+.}-{4:4}, at: ops_undo_list+0x270/0x860
 #4: ffff88811f1f8bd8 (&br->hash_lock){+...}-{3:3}, at: br_fdb_delete_by_port+0x3b/0x290
 #5: ffffffff8457a800 (rcu_read_lock){....}-{1:3}, at: atomic_notifier_call_chain+0x27/0x150
Workqueue: netns cleanup_net
Call Trace:
 __mutex_lock+0xf5/0x14f0
  nf_flow_table_switchdev_event+0x104/0x270
 atomic_notifier_call_chain+0xc5/0x150
 br_switchdev_fdb_notify+0x2b2/0x330
...
