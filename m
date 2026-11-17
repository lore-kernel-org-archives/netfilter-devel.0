Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958171;
	b=sOC9opC4UUuyv9uTUEpK6AjqqOk6JNidQr8H1o5QXClsejptH+MSh4d0Nh9RLE7towx9
	 EwIT/wYvNZYW8rlYQRbj3euRSmemym/vlgedM6vKKxb+ZsQlVkFhCtxJ0Uea/OPbb1Nap
	 Ls0uaRh0++Llr02X1DSN5e0KASV3y3NZmkDsydawVIbEVqj9D/rquXuZezUnQ1MhtiCxs
	 vJOo+wS1cGzlFebXTVzfRkRx97Ut1LdX9ChesJmEapE0S/Sc+bPTzECBUoUAYBen40pZm
	 c5qjxcFtjKXPBRT9RcuD2LusvkvGlZgA2pMLncjH7lJvU1NolyA/hQDRo/akjIpyaaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958171;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=SiKjWi4HdkLtjDIa+/3IxjZLkdAt0mQqyaNPPLzI5A4=;
	b=HHhNpYlvFA9A+nT7QFHNmVF+Z+CYbs6YLcBdA2ASQQ/+Vdi4JMWHAM8qZ7Fk8FEjRjUu
	 NrOg6yoWvc8T1ldvCXyienmkEzAKbUOgXknMuf7ojCGN/U/XAvuhOfm7buKAXTVhtpUIP
	 xEPG+ch/Am7whZWJdvClCS6noK1S6MA6SLyqcY/wOWlyvhdXbxtX/WkZ8EA7Qb8rJwORJ
	 xd0mjlLOeAlEY4rOp6/ZY55HFIbFw//GPrWUo/ReLalDN5IQD0K0O20WHqjrQQi1EvOKv
	 dW2BYHCRUV9e/PKnzJs5dTzznMyFsjl5kVbWS98ezvOjWze4SE+uZrse1tgBdRdKBrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gLrK+w6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E525D606A33F;
	Tue, 17 Nov 2026 23:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gLrK+w6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EE11F000CA;
	Tue, 17 Nov 2026 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958170;
	bh=SiKjWi4HdkLtjDIa+/3IxjZLkdAt0mQqyaNPPLzI5A4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gLrK+w6u2gxHOE1HyU3+0K0qsVAs0VaGtccQRflIQoaB3bR0GMVCI7vwmiZcNianv
	 NuVoXyxk45tZ0W2XWIfT+C3MA24YamH57qjNSy9nJIoq0GseW8qKUUJpn+ZO7PqoHH
	 BjqwrD28FcrZkhtou+4dGSnjwQpMwbyMoVE7q9H4FpSFE6dhsUHAOAKjPmeGkKIWxh
	 KDoqsu144VD5UPW9gghv4JlWeAdPq88MvFbs4QZifWNFgHZR0BE2fVwRnFihMDyq/n
	 o1/ioe0X1HlCWjLYik0qLDQyWsMiWzc53BpXeuCLzm01z1Z1LqEgtwfBSp5rsmKj+g
	 fWRRHSX8vjrOg==
Subject: Re: [PATCH net-next 8/9] net: add KUnit coverage for FA and flowtable
 path validation
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, horms@kernel.org,
 corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 17 Nov 2026 23:29:29 +0000
Message-ID: <179495816919.3136.9689954625386670626@kernel.org>
In-Reply-To: <20261116222519.1416501-9-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-9-florian.fainelli@broadcom.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Three bcm-ns-fa KUnit cases use plain slab memory as if it
  were an MMIO register window: fa_test_tcp_control_readiness,…
- [Medium] nf_flow_test_gc_routes() sets NF_FLOW_HW and NF_FLOW_HW_DYING
  on every flow, under the comment "Avoid queuing real DELETE/STATS work…
- [Low] In fa_test_rx_learning() (drivers/net/ethernet/broadcom/bcm-ns-
  fa-test.c), the TCP sub-case sets `ip->protocol = IPPROTO_TCP;` (line…
- [Low] fa_test_nat_actions() has three negative assertions that do not
  test what their comments say.
- [Low] fa_test_upper_device_rcu() registers two real Ethernet devices in
  init_net with alloc_etherdev() and register_netdev().

--

net: add KUnit coverage for FA and flowtable path validation

This commit adds KUnit suites for the Northstar flow accelerator, the B53
FA exception guards and the Broadcom FA tagger. It also adds flowtable
tests for cached-route owner validation, plus a GC test that covers seven
route and xmit scenarios. The tests are compiled into their parent
translation units, and a combined .kunitconfig sits beside the FA backend.

> diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c b/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
> new file mode 100644
> index 0000000000000..59406f84809e7
> --- /dev/null
> +++ b/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
> @@ -0,0 +1,661 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Included in bcm-ns-fa.c to exercise private table formats and validation. */
> +#include <kunit/test.h>
> +#include <net/lwtunnel.h>
> +#include <net/nexthop.h>
> +#include <linux/rtnetlink.h>
> +
> +static const struct net_device_ops fa_test_netdev_ops;

[ ... ]

> +	lower->netdev_ops = &fa_test_netdev_ops;
> +	upper->netdev_ops = &fa_test_netdev_ops;
> +	eth_hw_addr_random(lower);
> +	eth_hw_addr_random(upper);
> +	KUNIT_ASSERT_EQ(test, register_netdev(lower), 0);
> +	KUNIT_ASSERT_EQ(test, register_netdev(upper), 0);

[Severity: Low]
This isn't a bug, but could these test devices get a minimal
ndo_start_xmit that just drops the skb?

fa_test_netdev_ops is an empty static struct, so its ndo_start_xmit is
NULL. In fa_test_upper_device_rcu(), both devices are registered in
init_net and show up as eth%d with carrier on while the test runs.

If something outside the test brings one of them up and transmits on it,
dev_hard_start_xmit() would call the NULL ndo_start_xmit. That could be a
network manager reacting to RTM_NEWLINK, or an AF_PACKET sender.

The window is short, and re-running the suite after boot needs root
through the KUnit debugfs run file. net/core/dev_addr_lists_test.c
already uses the same pattern, so this is only a hardening suggestion.

[ ... ]

> +static void fa_test_nat_actions(struct kunit *test)
> +{
> +	struct fa_rule rule = { .direction = FA_DIR_UNSET, .l4proto = IPPROTO_UDP };

[ ... ]

> +	KUNIT_ASSERT_EQ(test, fa_mangle(&rule, &act), 0);
> +	KUNIT_EXPECT_EQ(test, rule.remap_port, (u16)0xabcd);
> +	KUNIT_EXPECT_EQ(test, rule.action, (u8)3);
> +	/* Opposite-side rewrites cannot share a hardware entry. */
> +	act.mangle.mask = (__force u32)cpu_to_be32(0xffff0000);
> +	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
> +	/* Partial IPv4 masks and arbitrary offsets must not be accepted. */
> +	act.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
> +	act.mangle.offset = offsetof(struct iphdr, daddr);
> +	act.mangle.mask = 1;
> +	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
> +	act.mangle.mask = 0;
> +	act.mangle.offset = offsetof(struct iphdr, ttl);
> +	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
> +}

[Severity: Low]
Do these three negative checks test what their comments describe?

By this point rule.action already has FA_ACT_REMAP_IP | FA_ACT_REMAP_PORT
set and the direction is SNAT. fa_mangle() rejects with:

    if (fa_direction(rule, dir) || (rule->action & FA_ACT_REMAP_IP))
        return -EOPNOTSUPP;
    ...
    if (fa_direction(rule, dir) || (rule->action & FA_ACT_REMAP_PORT))
        return -EOPNOTSUPP;

The REMAP_PORT bit alone rejects the opposite-side UDP rewrite, so the
fa_direction() conflict check is never exercised. If the mask and offset
checks were removed from fa_mangle(), the REMAP_IP bit would still reject
both the partial-mask daddr case and the ttl offset case, and this test
would still pass.

Would running each negative case against a fresh rule exercise each of
those checks in fa_mangle() on its own?

[ ... ]

> +	tag[2] = 1;
> +	bcm_ns_fa_rx(fa, skb);
> +	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
> +	tag[2] = 0;
> +	ip->protocol = IPPROTO_TCP;
> +	bcm_ns_fa_rx(fa, skb);
> +	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);

[Severity: Low]
Should ip->check be recomputed here?

The other sub-cases in fa_test_rx_learning() refresh the checksum with
ip_fast_csum() after editing the header. The IPv4 header checksum covers
the protocol byte, so bcm_ns_fa_rx() drops this frame on the checksum
before it reaches the TCP branch:

    total < ihl || total > skb->len - offset || skb_headlen(skb) < offset + ihl ||
    ip_compute_csum(ip, ihl))
        return;
    if (ip->protocol == IPPROTO_TCP &&
        fa_receive_tcp_control(fa, ip, total, skb_headlen(skb) - offset, tag[3] & 0x1f))

The learn_next == 1 expectation therefore passes because of the checksum
guard. fa_receive_tcp_control() and the TCP learning path never run in
this sub-case.

[ ... ]

> +static void fa_test_tcp_control_readiness(struct kunit *test)
> +{
> +	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
> +
> +	KUNIT_ASSERT_NOT_NULL(test, fa);
> +	fa->regs = (void __iomem *)kunit_kzalloc(test, 0xc0, GFP_KERNEL);

[Severity: Medium]
Can these fake register windows work on the default KUnit architecture?

fa_test_tcp_control_readiness(), fa_test_lookup_gate_preserves_tags() and
fa_test_invalidation() all point fa->regs at kunit_kzalloc() memory. They
then call writel()/readl() on it, either directly or through
fa_lookup_update():

    writel(enabled ? ETH_P_IP | ETH_P_IPV6 << 16 : 0, fa->regs + FA_L2_ETHERTYPE);
    readl(fa->regs + FA_L2_ETHERTYPE);

kunit.py defaults to ARCH=um and merges arch_uml.config, which sets
CONFIG_KUNIT_UML_PCI=y. That selects UML_PCI, then UML_IOMEM_EMULATION,
then INDIRECT_IOMEM, and INDIRECT_IOMEM_FALLBACK stays off. The raw
accessors then go through lib/logic_iomem.c, where get_area() does:

    if (WARN_ON((a & IOREMAP_MASK) != IOREMAP_BIAS))
        return NULL;

The fallback read then WARNs again and returns ~0. Writes WARN and are
dropped.

On UML, this would have these effects:

- fa_test_lookup_gate_preserves_tags() reads 0xffffffff for
  FA_L2_ETHERTYPE, FA_CTL and FA_BRCM_HDR, so its expectations fail.
- In fa_test_invalidation(), lookup_stopped = !readl(...) evaluates to
  false, so that check fails.
- fa_test_tcp_control_readiness() emits WARN splats that taint the
  kernel.

The new drivers/net/ethernet/broadcom/.kunitconfig enables COMPILE_TEST
and does not restrict the architecture. So running kunit.py with
--kunitconfig drivers/net/ethernet/broadcom seems to build exactly this
configuration.

Should the MMIO-dependent cases be limited to architectures with direct
MMIO, or should the lookup gate be observed some other way? Also, the
BCM_NS_FA_KUNIT_TEST help text says the tests "do not simulate table
I/O", which doesn't quite match these cases.

[ ... ]

> diff --git a/net/netfilter/nf_flow_table_core_test.c b/net/netfilter/nf_flow_table_core_test.c
> index 378a1c60b50b9..5c7645239d2e4 100644
> --- a/net/netfilter/nf_flow_table_core_test.c
> +++ b/net/netfilter/nf_flow_table_core_test.c
> @@ -72,9 +72,94 @@ static void nf_flow_test_hardware_retirement(struct kunit *test)

[ ... ]

> +	for (i = 0; i < ARRAY_SIZE(cases); i++) {
> +		struct nf_flowtable table = { .type = &type };

[ ... ]

> +		flow->ct = ct;
> +		flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
> +		/* Avoid queuing real DELETE/STATS work from this private GC test. */
> +		set_bit(NF_FLOW_HW, &flow->flags);
> +		set_bit(NF_FLOW_HW_DYING, &flow->flags);
> +		set_bit(IPS_OFFLOAD_BIT, &ct->status);

[ ... ]

> +		nf_flow_offload_gc_step(&table, flow, NULL);
> +		KUNIT_EXPECT_EQ_MSG(test, test_bit(NF_FLOW_TEARDOWN, &flow->flags),
> +				    cases[i].check, "GC path: %s", cases[i].name);
> +		flow_offload_route_release(flow);

[Severity: Medium]
Do these flags actually prevent STATS work from being queued?

In the "software direct" and "validation only" cases (check == false),
nf_flow_offload_gc_step() skips the teardown block and reaches:

    } else if (test_bit(NF_FLOW_HW, &flow->flags)) {
        nf_flow_offload_stats(flow_table, flow);
    }

That branch does not look at NF_FLOW_HW_DYING. Inside
nf_flow_offload_stats(), only this timing check stops a work item from
being queued:

    delta = nf_flow_timeout_delta(flow->timeout);
    if ((delta >= (9 * flow_offload_get_timeout(flow)) / 10))
        return;

For this ICMP ct the timeout is NF_FLOW_TIMEOUT (30 * HZ). If the test
thread stalls for more than about 3 seconds between setting flow->timeout
and the GC call, nf_flow_offload_work_alloc() will record:

- offload->flowtable = &table, which is the stack variable above
- offload->flow = flow, which is kunit-managed memory

This could happen on a loaded QEMU or UML host, or with KASAN enabled.
flow_offload_queue_work() then reads table.net, which is NULL here, and
queues the work on nf_flow_offload_stats_wq.

Nothing flushes or cancels that work. Could flow_offload_work_handler()
later run against a dead stack frame and freed kunit memory?

Any of these would avoid it:

- pre-set NF_FLOW_PENDING so nf_flow_offload_work_alloc() bails out
- leave NF_FLOW_HW clear for the non-hardware cases
- flush nf_flow_offload_stats_wq before the objects go out of scope

Separately, NF_FLOW_HW is set for every scenario, so the GC step handles
the "software direct" case as a hardware flow. Does this still cover the
"ordinary direct software forwarding" scenario that the commit message
describes?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
