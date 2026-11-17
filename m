Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958173;
	b=rs6abj4e63g1RlDn3GwwiAJis9c5a6BmSRkbyZa6aqhik7VdJyLIJgeKE0yDZxRLUZNG
	 yun9Dny3VTs1E0DXc/pSHS/nHsB3rPUqzHA3Cn4OagTrn3aEjxQOPjS1L3NKNi9PT29pC
	 arOa+hCdsV7rr5ls4wUAaA22OWQELawdJDEb7YV6ptoEzvd5+LkNWkaq5D4Zf5GcObhXH
	 D8vP6oQKngOq/Z/XNub+x0pSsoc5F3eP1q56RBjOrk7hSh44JDYXMJ+zfOQrVLgy4hNn3
	 +QSiEDKFBD+1XWTNR57QGlwltaz6KQMtt8KzTor5WYgt5d/b0Ap8Jqr+MecLmnI0k6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958173;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ts5GPqQ6xGaBjtsKfDcUxAKOTvGkSGHKKV3RkO2sGHU=;
	b=RWYpkVwdA+M/XqlTrUzvZHGirBORsmF8WD5yxXyHs9MrStNt2vaYd/X3G+9tgXAbzmzE
	 YHupv3wipCINZAH0Ds6nDm5zp+e/Ijtr1O+1VeX9r0P7LN64S0UNQyPPPv1Z7SK2MQzqz
	 K4rs6weRYHarWTG0ZvGjMSwbCmgPDXt3FADfnx1QWkBhwN+Uoir97aQY4rl+aArIh7eeP
	 hl/cOJay+6jTsIYo9BugFP0x5F1Xe0wHHiCBahU8GPPM865DBMw+qc5n7XkaFpE1wFd9X
	 4Y5l1VaSyD7gZ6ZikN4KmTib7Yhbk0+Xis1y81fND2gehaRb+oEYLENEzMYkSrS5kVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=au1lRR7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACA606A33A;
	Tue, 17 Nov 2026 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=au1lRR7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647BE1F000CC;
	Tue, 17 Nov 2026 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958172;
	bh=Ts5GPqQ6xGaBjtsKfDcUxAKOTvGkSGHKKV3RkO2sGHU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=au1lRR7+ORCvdGRMgCVs0MnYSH94kViCU8jjRbdpyM6wmL8FHYN3C/RYcaJ/dDd0Y
	 EORwMpP2fUiXJD4v8k6a9TLfe6aDKnDGO6C7dKdx3zNjARoRI8OIfyJypkQ8O+lG2q
	 hQDskKDvF6uDzPX0fl2uaYng3L86pgOnQIsbHocqsCZS14XWXKL2kUIroFed3oyobI
	 4Rj16gxL9GPTw3ahZ6KrP19BBWPKywoj7N8LW6Hqyb4J3A89UeSvz6FFqyRAyNAmWR
	 /RH2SBetAbqzok2mgtxbQTwRhMP+7R+bTPEjTjwVG3AnkvCxlwbdNKt7P29yBKiQRQ
	 fIYbK9VeYCikg==
Subject: Re: [PATCH net-next 9/9] docs: net: document Northstar FA setup and
 NAT qualification
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
Date: Tue, 17 Nov 2026 23:29:30 +0000
Message-ID: <179495817095.3136.15574702882079067890@kernel.org>
In-Reply-To: <20261116222519.1416501-10-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-10-florian.fainelli@broadcom.com>
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 4 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The reference nftables ruleset in
  Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-…
- [Medium] bcm-ns-fa.rst (lines 130-131) says "Every IPv4 FIB route, rule
  and nexthop change flushes all FA-owned flows".
- [Medium] B53 and the FA backend decide independently whether FA
  metadata mode is active, and they use different tests.
- [Medium] The FA block is at 0x18027c00 (reg <0x18027c00 0xc0>), which
  is offset 0xc00 inside the GMAC3 BCMA core aperture (gmac3:…
- [Low] The 'Automated validation' section runs kunit.py with the suite
  filter `'*fa*'` against drivers/net/ethernet/broadcom/.kunitconfig.
- [Low] The commit message for "docs: net: document Northstar FA setup
  and NAT qualification" ends with "Keep campaign history and review…

--

docs: net: document Northstar FA setup and NAT qualification

This adds documentation for the Broadcom Northstar flow accelerator. It
covers the supported GMAC2/GMAC0 topology, the device tree and kernel
configuration, and how route and neighbour invalidation works. It also
describes a three-host NAT qualification procedure, fault injection tests
and KUnit validation, and adds the new file to the index and MAINTAINERS.

> validation from the driver's incomplete FIB eligibility probe. Keep
> campaign history and review status in the accompanying package.

[Severity: Low]
This isn't a bug, but what does "the accompanying package" refer to? The
patch only adds bcm-ns-fa.rst, an index entry and a MAINTAINERS line.
Nothing in the tree matches that description.

Could this sentence go in the cover letter or below the --- line instead
of the permanent changelog?

> diff --git a/Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst b/Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst
> new file mode 100644
> index 0000000000000..2bc6cc5d94cea
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst
> @@ -0,0 +1,507 @@

[ ... ]

> +Netdevice shutdown, address/MTU changes, new active switch ports, and upper
> +interface changes flush entries. Every IPv4 FIB route, rule and nexthop change
> +flushes all FA-owned flows, including unrelated prefixes and local-table
> +entries. This is intentional: the rule does not carry enough routing-policy
> +context to prove that an event cannot affect an installed path. Work is
> +coalesced, but even unrelated routing churn can reduce offload residency.

[Severity: Medium]
Can the IPv4 FIB notifier actually provide this guarantee? fa_fib_event()
in drivers/net/ethernet/broadcom/bcm-ns-fa.c is the only route
invalidation path. The same promise appears in its comment. However,
fib_table_insert() only notifies when the new alias is the first one for
that prefix and table:

net/ipv4/fib_trie.c:fib_table_insert() {
    ...
	if (fib_find_alias(&l->leaf, new_fa->fa_slen, 0, 0, tb->tb_id, true) ==
	    new_fa) {
		enum fib_event_type fib_event;
    ...
}

The NLM_F_REPLACE branch and the delete path work the same way:

net/ipv4/fib_trie.c:fib_notify_alias_delete() {
    ...
	/* Do not notify if we do not care about the route. */
	if (fib_find_alias(fah, slen, 0, 0, tb_id, true) != fa_to_delete)
		return;
    ...
}

Aliases are sorted by descending DSCP. If a prefix also has a
DSCP-specific alias (ip route ... tos X), the DSCP-0 alias that ordinary
traffic uses is not first. Adding, replacing or deleting that alias raises
no notifier event. As a result, neither fa_invalidate_locked() nor
fa_mtu_route_update() runs.

Flowtable GC doesn't catch this for hardware flows either, because
validation-only references are skipped:

include/net/netfilter/nf_flow_table.h:nf_flow_dst_check() {
	/* A driver-only reference must not change direct-path/GC semantics. */
	if (!tuple->dst_cache || tuple->dst_validation_only)
		return true;
    ...
}

nf_flow_offload_validate() only runs at admission.

Suppose the DSCP-0 route is replaced with a blackhole, moved to another
next hop, or given an MTU below 1500 as a non-first alias. Would the
hardware rows keep forwarding on the old path while counter activity keeps
refreshing them? The same gap applies to the later claim that flows stay
in software while any route has an MTU below 1500. The blackhole and MTU
1200 qualification steps only use first-alias routes, so they would pass
anyway.

A minor point: fa_fib_event() also handles FIB_EVENT_ENTRY_ADD and
FIB_EVENT_ENTRY_APPEND, which IPv4 never emits.

[ ... ]

> +For a BCM53012 board, add the following node under the root address space
> +(adjust the compatible to ``brcm,bcm53011-fa`` for BCM53011)::
> +
> +  / {
> +      fa: flow-accelerator@18027c00 {
> +          compatible = "brcm,bcm53012-fa";
> +          reg = <0x18027c00 0xc0>;
> +      };
> +  };

[ ... ]

> +Remove any other conflicting CPU assignments for this test. B53 selects ``brcm-fa``
> +when it finds the enabled accelerator through this phandle. Do not set
> +``dsa-tag-protocol``: B53 does not implement the runtime protocol-change
> +operation. No existing board is enabled automatically by this series.

[Severity: Medium]
Is this the whole condition? B53 and the FA backend each decide on their
own whether FA metadata mode is active, and they use different tests:

drivers/net/dsa/b53/b53_common.c:b53_uses_fa_tag() {
    ...
		enabled = IS_ENABLED(CONFIG_BCM_NS_FA) && of_device_is_available(fa) &&
			  (dev->chip_id == BCM53011_DEVICE_ID ||
			   dev->chip_id == BCM53012_DEVICE_ID ||
			   (is5301x(dev) && of_device_is_compatible(fa, "brcm,bcm4708-fa")));
    ...
}

drivers/net/ethernet/broadcom/bcm-ns-fa.c:bcm_ns_fa_init() {
    ...
	if (!of_device_is_compatible(np, "brcm,bcm4708-fa") &&
	    !of_device_is_compatible(np, "brcm,bcm53011-fa") &&
	    !of_device_is_compatible(np, "brcm,bcm53012-fa")) {
		of_node_put(np);
		return ERR_PTR(-ENODEV);
	}
    ...
}

bcm_ns_fa_init() ignores the chip. It then always enables FA_BRCM_HDR
processing and clears FA_CTL_BYPASS.

Take the brcm,bcm53012-fa node from the example above on a 5301x switch
whose runtime chip_id is BCM53010, BCM53018 or BCM53019. The backend would
switch GMAC2 RX to the FA descriptor format. B53 would keep the ordinary
brcm tagger on port 8 and skip the CFP exception guards. Would conduit RX
on port 8 then be misparsed or dropped?

An available FA node with any other compatible makes bcm_ns_fa_init()
return -ENODEV. That fails the whole GMAC2 probe:

drivers/net/ethernet/broadcom/bgmac.c:bgmac_enet_probe() {
    ...
	bgmac->fa = bcm_ns_fa_init(net_dev);
	if (IS_ERR(bgmac->fa)) {
		err = PTR_ERR(bgmac->fa);
		bgmac->fa = NULL;
    ...
}

Also, "brcm,bcm4708-fa" turns on FA mode for any 5301x chip. That includes
parts the binding, the Kconfig help and this document do not list as
supported.

Could B53 and the backend share one predicate, and could the document
state the actual conditions?

> +
> +The FA resource is outside the GMAC3 DMA register window. It is managed by
> +the GMAC2 consumer; it does not need a separate platform driver or character
> +device. Leave the accelerator disabled or omit the GMAC2 phandle to retain
> +the existing board configuration.

[Severity: Medium]
What state does the GMAC3 core need to be in? The FA block at 0x18027c00
is at offset 0xc00 inside the GMAC3 BCMA core aperture (gmac3:
ethernet@27000 in bcm-ns.dtsi). bcm_ns_fa_init() maps and programs it from
GMAC2 without checking or enabling the core that hosts it.

If the FA shares GMAC3's reset or clock domain, two cases look like
problems.

First, when GMAC3 is disabled in DT, nothing releases the core's reset:

drivers/bcma/main.c:bcma_register_devices() {
    ...
		np = core->dev.of_node;
		if (np && !of_device_is_available(np))
			continue;
    ...
}

Could FA register accesses then abort, or hit the FA_INIT_DONE poll
timeout, depending on what the bootloader left behind?

Second, when GMAC3 is enabled, bgmac_probe() in bgmac-bcma.c only rejects
the phandle on a core other than unit 2. GMAC3 therefore still probes, and
bgmac_enet_probe() unconditionally calls:

	bgmac_clk_enable(bgmac, 0);

This reaches bcma_core_enable(), which pulses the GMAC3 core reset. If
that happens after GMAC2 has initialized the FA, does it wipe FA_CTL and
the table state? The GMAC2 side would still believe its flows[] and
next-hop bookkeeping match the hardware. BGMAC_FEAT_NO_RESET suppresses
the reset in open/close, but not this probe-time enable.

The setup steps only cover GMAC0 and GMAC2. Should they say whether GMAC3
must be enabled, disabled or left alone?

[ ... ]

> +  table inet fa_test {
> +      flowtable ft {
> +          hook ingress priority 0;
> +          devices = { lan1, wan };
> +          flags offload;
> +          counter;
> +      }
> +      chain forward {
> +          type filter hook forward priority 0; policy drop;
> +          meta l4proto udp ct state established flow add @ft
> +          ct state established,related counter accept
> +          iifname "lan1" oifname "wan" udp dport 5001 counter accept
> +          iifname "wan" oifname "lan1" udp dport 5001 ct status dnat counter accept
> +      }
> +      chain prerouting {
> +          type nat hook prerouting priority dstnat; policy accept;
> +          iifname "wan" udp dport 15001 dnat ip to 192.0.2.2:5001
> +      }
> +      chain postrouting {
> +          type nat hook postrouting priority srcnat; policy accept;
> +          iifname "lan1" oifname "wan" ip saddr 192.0.2.2 snat ip to 198.51.100.1:45000
> +      }
> +  }

[Severity: Medium]
Will this table load with nft -f? The snat rule in the postrouting chain
asks for a port mapping. However, iifname, oifname and ip saddr don't set
a transport protocol. nft rejects such a rule with "transport protocol
mapping is only valid after transport protocol match". nft -f loads the
file as one transaction, so the whole fa_test table would be rejected.

The dnat rule is fine because udp dport 15001 comes first. Would a meta
l4proto (or tcp/udp) match before the snat statement fix this? The
in-tree nft_flowtable.sh and nft_nat.sh selftests do that.

Separately, the forward chain only handles UDP:

          meta l4proto udp ct state established flow add @ft
          iifname "lan1" oifname "wan" udp dport 5001 counter accept

With policy drop, wouldn't a new TCP SYN match no accept rule and be
dropped? The text below says "run a UDP or TCP echo server". Later
sections ask for the SNAT, DNAT, pressure, fallback and aging tests to be
repeated with TCP, but no TCP ruleset is given.

[ ... ]

> +  ./tools/testing/kunit/kunit.py run --arch=x86_64 \
> +      --kunitconfig=drivers/net/ethernet/broadcom/.kunitconfig \
> +      --build_dir=/tmp/bcm-ns-fa-kunit '*fa*'

[Severity: Low]
Does the '*fa*' filter skip suites that this kunitconfig builds?
drivers/net/ethernet/broadcom/.kunitconfig also sets
CONFIG_NF_FLOW_TABLE_KUNIT_TEST=y. That builds the nf-flow-lifetime suite
(net/netfilter/nf_flow_table_core_test.c) and the nf-flow-path suite
(net/netfilter/nf_flow_table_offload_test.c). Neither name contains "fa",
so the documented command builds them but never runs them.

nf-flow-path covers the cached route and neighbour validation in
nf_flow_offload_validate() that the commit message relies on.

Should the filter include these suites? Should the text below also
mention CONFIG_NF_FLOW_TABLE_KUNIT_TEST next to the three suites it lists?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
