Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181565;
	b=bvaPLpJgbe4iCEQjfH2rDZ2HUU5ernxFGks4/TYq3inV/kQLhAAYJVobrm2GHWK5QJiB
	 EPs9Ik8a2NWxgki+7AeVA3e+/47XH+MR9X4A+HyK/7Ch80lqzbNWbgY2kaiJd2BpnQeI6
	 k7Z4EYs5PL1akvRaJ2laSQXTu5glZR2psx6ry7eBstkCiMpYMe13miaBnQ1ryao936s55
	 3NyywHUYvNNL8GWdKSiXAiQqDk/CPsZuD4vAkxchzl/Wb8S6libXaxMYV71Qb8/MJOKyx
	 G13++dCGcU6rNYTgIbgaqTSExbNUiqHf2ondSkDqfovzcpmiBcziWIwllyOLcEi2s6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181565;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gnCz3ES8tm66iHipwmv17CLb12tKgEyO5B4jPSzg7NQ=;
	b=p1uA4FvYuz8UXILGmyhxOZTbEcaEkzshR4LZ6rh81Z903yxkoX7pi2ssOvqzl/9H2L0v
	 6Lscicyi0N1TuDxjZ3DVXiA3JCmEqEhn4E3WYV1ps+prjsVYkWTx+heBWLf6bf9YekrEG
	 DrgVat5AD+Oa3vfrwObQArIUZVqnE/IRM7bSAjnTHz1YVRunZQ1Gqq2IEQKC6QVEPKZXm
	 62yyPecOg8qmvRP8YQaPrgjb81CV2bx/wIHJB7i00wQPE/kD6Ctu2VOkuuioHQTVzt5LG
	 LIpD1JFRKFE/L77q0loGKMwLAsWHVkvj1B7i8IU9OvwG8O5kh98tUgtVjNUkdNjgdXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4345E606A320;
	Fri, 20 Nov 2026 13:32:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4345E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 873D960D35; Fri, 20 Nov 2026 14:32:31 +0100 (CET)
Date: Fri, 20 Nov 2026 14:32:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Junyoung Jang <graypanda.inzag@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Gwanhyun Lee <gwanhyunlee@gmail.com>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: drain cleanup work on
 netns exit
Message-ID: <awBLxqCPTWlGBWFx@strlen.de>
References: <20261120105718.866862-1-graypanda.inzag@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120105718.866862-1-graypanda.inzag@gmail.com>

Junyoung Jang <graypanda.inzag@gmail.com> wrote:
> NETLINK_URELEASE unlinks an NFQUEUE instance and schedules its
> destruction through queue_rcu_work(). The RCU callback queues
> instance_destroy_work() on nfq_cleanup_wq. Queued entries retain
> entry->state.net, but nf_queue_entry_get_refs() pins only their
> sockets and network devices.
>
> A migratable device can return to init_net as the old namespace exits.
> cleanup_net() waits for the RCU callback but not the work it queued.
> It can free the namespace before instance_destroy_work() calls
> nfqnl_reinject(entry, NF_DROP), which dereferences the old state.net
> in nf_hook_entries_head().

A bit too verbose changelog for my taste but unfortunately with AI
it's becoming the new standard.

> A source review assisted by a coding agent identified this race. A
> 65,536-queue reproducer on unmodified mainline with
> KASAN and lockdep enabled reported:

The above is rendundant.

>   BUG: KASAN: slab-use-after-free in nfqnl_reinject
>   Workqueue: nfq_workqueue instance_destroy_work
>
> The free stack included cleanup_net(). The trigger used
> initial-namespace CAP_NET_ADMIN and a migratable virtio-net device;
> it required no kernel modification or fault injection.

This is useful, could also have added the trimmed backtrace
instead of the above.

> Drain NFQUEUE cleanup in the pernet exit batch. rcu_barrier() waits
> for pending RCU callbacks to enqueue their work; flush_workqueue()
> then completes that work before cleanup_net() frees the namespace.
> The batch hook avoids a barrier for each exiting namespace.
> 
> The same mainline revision with this patch built without warnings and
> completed two 90-second reproducer runs in KVM with no KASAN or
> lockdep reports. No netfilter selftests were run.

This is redundant: its obvious from looking at the diff.

Reviewed-by: Florian Westphal <fw@strlen.de>
