Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209269;
	b=eI02Qmgi5z4CxdhKH4uosNNzt3h2FTI3deWSTaQDBiYnY4djvtoHNwOklNOVwOuom4Ed
	 tIjhbIyK/xYEfZOU/zqDBxn60axFNFneR2U9t3PdKuiz0rv3xTMSo3e+u06C1euqGXbwu
	 D/i1U80q8VHHWKF7YS9U6otpfbig1Ux4hsMUKpsjBKTHenREQhe9PMQ3ivMWklkhT4APm
	 iaeMTrvO4MbAFmoOr5LVeGZvsORqF9BGbUhiBLk6XitLxhTwu1xV8tL/ub6u5UV+ZpqpN
	 vQNV8WJDsCRzYDaE+SnlE0z3BKCPe2eGGC+TRQ7MJFBhFqUPclDzTdtTFSZjbZ56EDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209269;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Swcf0DnhAtIl8EvIgkGj2uhJo8mAoXKQQhHzUI9iGIY=;
	b=p8ZoqMEaePGj3StC2AW74mgHZWJhnmrdqCVLKG8iABz0dN4xmpK3W27e8d7XMhVhLIYB
	 cNPg6c0qEyKgMpC8LJjAmf0PBCwXC86nZZwVVgudOc9bnx4B7/vhC/IZAFr6P6Wavdgfk
	 6AEFln341sXGoQ38XIMgDCoGAqStRlf7pt+KLMspsGrlOT6POLtBtvE/wHdN8cLfFaE1L
	 z8mbyRRwNMTWUrV/6vH37HfUEfhF6xTIRK4waWE0U3eUX4+QG6pw59ME/yXEC5WRAJ14D
	 ZYgeFtmsi6N3xgADCxVK7YrYq0ble4eYMgOgBWRdU+suWVM+PFLe25yj0UC0chOKYMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ec6Y0l0a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2ED606A31C;
	Mon,  9 Nov 2026 07:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ec6Y0l0a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1031F0089F;
	Mon,  9 Nov 2026 07:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794209268;
	bh=Swcf0DnhAtIl8EvIgkGj2uhJo8mAoXKQQhHzUI9iGIY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ec6Y0l0a0Pu06bsmUhIrFlg/+tW+dqzq4tBH4x0aAlMf7xVfKs5Pz8uqKjn900s93
	 1Vq0nP08rbhq6kKE0t1NhKQnB8Ail0HlGDHkTYWB9XnbyhVP0HGnbhJdqZk9Aifix6
	 zll237N5XC42JyKzqpEdVc2tkJ7PYBy9219C17Kalc7LXFSOzNIH1VATakb7uvI5ol
	 vzYBlAo2qakZ6QqEo7XsSvYh/PRzAg8E9ttQJsKLDToQ9kNoZwzm6vo1PMmiB4/J3k
	 e63EAos85FQUkR28ZP0xfjQFskinLh3SSmwqyIdZYqZ6D0GQ7vugTUwsUiUkM884un
	 jXxllez+lXZWg==
Subject: Re: [PATCH net] netfilter: nf_flow_table: defer pernet stats release
 to last flowtable teardown
From: netdev-bot+sashiko@kernel.org
To: q.h.hack.winter@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, vladbu@nvidia.com,
 ozsh@nvidia.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kuba@kernel.org
Date: Mon, 09 Nov 2026 07:27:47 +0000
Message-ID: <179420926753.994134.7270811903271795956@kernel.org>
In-Reply-To: <20261105065509.94627-1-q.h.hack.winter@gmail.com>
References: <20261105065509.94627-1-q.h.hack.winter@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 3 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In nf_flow_table_free() (net/netfilter/nf_flow_table_core.c),
  the line `release = net->ft.exiting && !--net->ft.nr_ft;` only…
- [High] The deferred-release scheme keeps its state (ft.lock, ft.nr_ft,
  ft.exiting, ft.stat) inside struct net and expects the last…
- [High] nf_flow_table_fini_net() sets net->ft.exiting = true, but
  nf_flow_table_init_net() never resets exiting or nr_ft.
- [Medium] The commit message gets the failure mechanism wrong and does
  not mention a behaviour change.

--

netfilter: nf_flow_table: defer pernet stats release to last flowtable teardown

This commit counts flowtables per netns and adds an exiting flag, so
that the free_percpu() of net->ft.stat moves from netns exit to the
last nf_flow_table_free() of a dismantled netns. It also adds
nf_flow_table_offload_drain(), which flushes all three offload
workqueues on every nf_flow_table_free().

> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 0d72dc8ae47a1..de0a9f0e4f7b9 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c

[ ... ]

> @@ -781,19 +791,51 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
>  	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>  	nf_flow_table_gc_run(flow_table);
>  	nf_flow_table_offload_flush_cleanup(flow_table);
> +
> +	/* The gc pass above can still queue offload works whose handlers
> +	 * decrement the pernet statistics.  Drain them all.
> +	 */
> +	nf_flow_table_offload_drain();

[Severity: Medium]
Does the commit message describe the failure correctly? It says:

  "The flushes in nf_flow_table_free() only drain those workqueues when
  hardware offload is in use, so after free_percpu() the stray workers
  still this_cpu_inc()/this_cpu_dec() into freed percpu memory."

As far as I can see, offload works are only queued for hardware offload
flowtables. flow_offload_add() calls nf_flow_offload_add() only when
nf_flowtable_hw_offload() is true. nf_flow_offload_gc_step() only queues
del/stats works for flows that have NF_FLOW_HW set:

    if (test_bit(NF_FLOW_HW, &flow->flags)) {

NFT_FLOWTABLE_HW_OFFLOAD also can't be toggled on update. So the flushes
that only run for hw offload don't seem to be the actual gap.

When fini_net runs before the flowtable is freed, the stats access
appears to come from the synchronous gc pass inside nf_flow_table_free()
itself, not only from stray workers:

  nf_flow_table_gc_run()
    flow_offload_queue_work()
      NF_FLOW_TABLE_STAT_INC_ATOMIC

Also, nf_flow_table_offload_drain() is called unconditionally here. That
includes software-only flowtables in live namespaces. It flushes
nf_flow_offload_add_wq, nf_flow_offload_del_wq and
nf_flow_offload_stats_wq. As a result, every flowtable deletion waits for
all pending hardware offload work in the system, driver callbacks
included.

The commit message presents the drain as part of the final release for a
dismantled netns. With Cc: stable, could the message also mention this
latency change?

>  	rhashtable_destroy(&flow_table->rhashtable);
> +
> +	net = read_pnet(&flow_table->net);
> +	if (net) {
> +		bool release;
> +
> +		spin_lock(&net->ft.lock);
> +		release = net->ft.exiting && !--net->ft.nr_ft;

[Severity: High]
Can this leak net->ft.stat for any netns that freed a flowtable before it
exited?

While the netns is alive, net->ft.exiting is false. The && then
short-circuits, so --net->ft.nr_ft never runs.

nf_flow_table_init() still increments nr_ft for every flowtable.
nf_tables_newflowtable() and tcf_ct_flow_table_get() both call
write_pnet() before nf_flow_table_init(), so net is always set there.

Take this sequence:

  create netns
  add an nft flowtable                      nr_ft = 1
  delete it
    nf_tables_flowtable_destroy()
      nf_flow_table_free()                  exiting == false, nr_ft stays 1
  destroy netns
    nf_flow_table_fini_net()
      release = !net->ft.nr_ft;             false

After this, nothing calls free_percpu(net->ft.stat).

Removing a tc ct action through tcf_ct_flow_table_cleanup_work() does the
same. So does the nf_tables_newflowtable() error path after a successful
init.

Should nr_ft be decremented unconditionally, with only the release
decision depending on exiting?

> +		spin_unlock(&net->ft.lock);
> +
> +		/* Released by the last flowtable teardown, see
> +		 * nf_flow_table_fini_net().
> +		 */
> +		if (release)
> +			free_percpu(net->ft.stat);
> +	}

[Severity: High]
Can this block run after struct net has already been freed?

The hand-off state (ft.lock, ft.nr_ft, ft.exiting, ft.stat) lives in
struct net. act_ct doesn't hold a netns reference on its flowtable.
tcf_ct_flow_table_get() does:

    write_pnet(&ct_ft->nf_ft.net, net);

with no get_net() or net_passive_inc(). Teardown then goes:

  tcf_ct_cleanup()
    call_rcu(tcf_ct_params_free_rcu)
      tcf_ct_flow_table_put()
        queue_rcu_work(act_ct_wq, &ct_ft->rwork)
          tcf_ct_flow_table_cleanup_work()
            nf_flow_table_free()

cleanup_net() runs the pernet exits, then rcu_barrier(), then
net_passive_dec(). A later cleanup_net() frees the net through
net_complete_free().

rcu_barrier() waits for the RCU callback that queues the work. It does
not wait for the work to run on act_ct_wq. Nothing in act_ct's pernet
exit flushes act_ct_wq, since ct_exit_net() only calls
tc_action_net_exit().

This is the case the patch targets: fini_net sees nr_ft > 0 and sets
exiting. If the deferred nf_flow_table_free() runs after struct net is
freed, it takes spin_lock(&net->ft.lock) and decrements nr_ft. It may
also call free_percpu() on a pointer read from freed or reused memory.

act_ct_wq is ordered. Each cleanup item now does
cancel_delayed_work_sync() plus three global flush_workqueue() calls, so
a backlog of ct_ft cleanups makes this window wider.

Would act_ct need to pin the netns, or should the stats live outside
struct net?

>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_free);
>  
>  static int nf_flow_table_init_net(struct net *net)
>  {
> +	spin_lock_init(&net->ft.lock);
>  	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
>  	return net->ft.stat ? 0 : -ENOMEM;
>  }
>  
>  static void nf_flow_table_fini_net(struct net *net)
>  {
> -	free_percpu(net->ft.stat);
> +	bool release;
> +
> +	spin_lock(&net->ft.lock);
> +	net->ft.exiting = true;

[Severity: High]
Is net->ft.exiting ever cleared again?

nf_flow_table_init_net() only calls spin_lock_init() and alloc_percpu().
struct netns_ft is embedded in struct net, so exiting and nr_ft survive a
module unload and reload. That holds for every existing netns, including
init_net.

Take this sequence:

  rmmod nf_flow_table
    nf_flow_table_module_exit()
      unregister_pernet_subsys(&nf_flow_table_net_ops)
        nf_flow_table_fini_net()
          exiting = true, stat freed if nr_ft == 0
  modprobe nf_flow_table
    nf_flow_table_init_net()
      stat re-allocated, exiting still true
  create and delete a flowtable
    nf_flow_table_free()
      release = net->ft.exiting && !--net->ft.nr_ft;   true
      free_percpu(net->ft.stat)                        netns still alive

>From then on, flow_offload_queue_work() and the work handlers update
freed percpu memory, and the procfs stats read it. At netns exit,
nf_flow_table_fini_net() sees nr_ft == 0 and frees the same pointer a
second time.

The out_proc error path in nf_flow_table_pernet_init() leaves the same
stale flag. So does the register_pernet_subsys() unwind when module init
fails, on namespaces that stay alive.

Should nf_flow_table_init_net() reset exiting and nr_ft?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105065509.94627-1-q.h.hack.winter%40gmail.com
