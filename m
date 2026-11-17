Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958165;
	b=ODNkeLU9vfGXdYQRgYLIbuMe2w8jCQ10aHoq4O/fh5ivwx+ngxHfMIZ5LBEgwpFTbOk3
	 hN28ab49FTvHaCceJ5Z0CdwhyMZcT7l5ehnHRBml0ROOBRWE8MyrZQiVz3zlRzs453Jhn
	 n4dc2DLQaAbGLH1fc5Ny0CAc8DLK5zLLa6C7iEB8paQWdozn+UcCU5SO4vTWV3jRePhK4
	 FPTEgk7uS6S1wIXIteIrXdQUrwuOpv2j5uIflP/CW/0SPA+4UmutxGLYWh20otLUQkgV4
	 8Zexq0uPHIPPj7WVz+ylEQdD2qBU96VmwJXkqM2ymOro59FX6m2iSfDDASM2OvN4CuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958165;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=CnlWQFO2MIWpJhh6iO4DeI6VsCNFONNEsQzLy6AsPmc=;
	b=VyZhiqq08sVdrBHT4+5QMFV5Guq4raS8D5emrT3bFSoNjgVsuswiYIi5H4vhXLFEuceg
	 sCT2lc3zoQQKadOOWMsAQqbKOCQKpxaUFUOslQomw2FxT/O0Ys0dvTnsZqaoOMXqdpuJr
	 WTXiOgJNOOBOAAaAF4y7xWhSeqgQrisPmc3vFTH4JwcgcndiP3Xp2txc0UVuQGNntFNHt
	 arrbW0IS+rBffgEZsPoADpQHndLPaT8v5VMRFb2prrJWBBDdMn8ROoWmjCyZu2A/9NfmV
	 wEsYABq7F8OUFQYskmRAOgbyfrD6e5jOhJtrm673cSK0p9WxflO8Djaj+P8C50YcwxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EKyIRZpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625F8606A32F;
	Tue, 17 Nov 2026 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EKyIRZpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC55F1F000C4;
	Tue, 17 Nov 2026 23:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958165;
	bh=CnlWQFO2MIWpJhh6iO4DeI6VsCNFONNEsQzLy6AsPmc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EKyIRZpIXe0YOhIo3XkGBE+5f/p3MfuLBRFq20JiSKb3jtXirFg+ZGNay9zaDJ7cW
	 MqQBI2sVU4tQWMzfsRiidqTzQ+v0GPGcYhQt6FzUwvCKDePJ2xPW3nAijZrDP2qb5C
	 8g2hm42WTHgQXPslLkDy35zDwvosBAuuJvvS86J5jqyqCU2Rxq/DijyvIQNs5Ndntm
	 sYCdd/mcx7bIbZVdhwHuDf+dtTmH+2AZTW4ldn6xpYS48CoMStgmbU1FfoYq6kFqjD
	 jHuSCTbj5x7UgRQ3+M98eyWgCbkbPnRtpp3efqOIYtKC3pox35w+9MS0/Bl58M7zLb
	 LE/9qZ5fNaHIw==
Subject: Re: [PATCH net-next 5/9] net: dsa: add Broadcom FA metadata and IPv4
 exception paths
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
Date: Tue, 17 Nov 2026 23:29:23 +0000
Message-ID: <179495816343.3136.8938496694323714432@kernel.org>
In-Reply-To: <20261116222519.1416501-6-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-6-florian.fainelli@broadcom.com>
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

Thank you for your contribution! Sashiko AI review found 13 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 7 · Low: 5

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Bridged ports lose every FA exception guard while their CPU-
  bound traffic still passes through the inline FA.
- [Medium] When FA is enabled, b53_setup_port() and b53_br_leave() put
  standalone user ports in EAP_MODE_BASIC instead of EAP_MODE_SIMPLIFIED.
- [Medium] On NETDEV_PRE_CHANGEADDR, b53_fa_netdev_event() writes an all-
  zero TCAM entry over the port's router-MAC allow rule…
- [Medium] If b53_fa_port(dev, port, true) fails in b53_br_leave(), the
  code logs an error and calls b53_disable_port(), which only sets the…
- [Medium] The TCP SYN/FIN/RST trap rules 0-2 in b53_fa_setup() include
  CFP_TCAM6_IP_FRAGMENT in the mask with data 0, so they match only…
- [Medium] The commit says it 'keep[s] ordinary data flooding off the
  auxiliary CPU'.
- [Medium] net: dsa: b53: missing CPU port 5 in non-default VLANs in
  b53_vlan_add()
- [Medium] net: dsa: tag_brcm: brcm_tag_rcv_ll() reads prepended tag as
  MAC DA
- [Low] The B53 CFP action and meter RAM programming differs from the
  reference programming of the same register block.
- [Low] b53_uses_fa_tag() does not follow the DT binding's compatible
  list.
- [Low] The NET_DSA_TAG_BRCM_FA help text says 'Transmit uses the
  ordinary prepended Broadcom tag' and 'Enable this for a B53 switch…
- [Low] Plain bool FA state flags are read and written concurrently
  without a common lock or READ_ONCE/WRITE_ONCE.
- [Low] net: dsa: b53: duplicate CFP rule programming in b53_fa_setup()

--

net: dsa: add Broadcom FA metadata and IPv4 exception paths

This patch adds a brcm-fa DSA tagger for the Northstar flow accelerator
miss descriptor. It also adds B53 CFP rules that send TCP SYN/FIN/RST,
TTL 0/1, packets longer than 1500 bytes and non-router-MAC IPv4 traffic
to port 5/GMAC0, outside the FA. A netdevice notifier and an RCU-protected
backend registry in tag_brcm.c coordinate guard and conduit readiness.

> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index b7aff5e238e85..3e8c9679836d3 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c

[ ... ]

> @@ -678,7 +685,8 @@ int b53_setup_port(struct dsa_switch *ds, int port)
>  	 * dropping frames because it isn't allowed to forward there.
>  	 */
>  	if (dsa_is_user_port(ds, port))
> -		b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
> +		b53_set_eap_mode(dev, port, dev->fa_cfp_enabled ? EAP_MODE_BASIC :
> +			 EAP_MODE_SIMPLIFIED);

[Severity: Medium]
On FA boards, standalone user ports now get EAP_MODE_BASIC. Does that
bring back the problem fixed by commit 4227ea91e2657f ("net: dsa: b53:
prevent standalone from trying to forward to other ports")?

That commit uses EAP_MODE_SIMPLIFIED to send all standalone-port traffic
to the CPU. In BASIC mode, a frame that no CFP trap redirects goes through
normal ARL forwarding. That covers non-IPv4 traffic such as ARP and IPv6.
It also covers IPv4 frames that hit the allow rules, which have no action.

Suppose the DA was learned on a VLAN-unaware bridged port with learning
on (shared PVID 0). The ARL forwards the frame to that port, the PVLAN
mask blocks it, and the frame is dropped instead of reaching Linux.

b53_br_leave() makes the same change, so ports leaving a bridge are hit
too. Two comments no longer match the code: "Force all traffic to go to
the CPU port" above this call, and "Enable redirection of unknown SA to
the CPU port" in b53_br_leave(). The commit message does not mention this
change either.

[ ... ]

> @@ -1326,6 +1336,315 @@ int b53_setup_devlink_resources(struct dsa_switch *ds)

[ ... ]

> +static int b53_fa_rule(struct b53_device *dev, unsigned int index,
> +		       const u32 data[8], const u32 mask[8], bool trap)
> +{

[Severity: Low]
This isn't a bug, but the TCP flag loop open-codes what b53_fa_rule()
does with trap set:

  - the eight DATA/MASK writes
  - both action words and the action commit
  - the meter writes and the meter commit
  - the TCAM commit

Could this loop just build data and mask and then call
b53_fa_rule(dev, rule, data, mask, true)? With two copies, any change
to the action or meter programming has to be made twice, and one copy
is easy to miss.

[ ... ]

> +	err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(0),
> +			  trap ? CFP_ACT0_FWD_MAP_REPLACE | CFP_ACT0_DST_PORT5 |
> +				CFP_ACT0_REASON_TERMINATION : 0);
> +	if (!err)
> +		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(1),
> +				  trap ? CFP_ACT1_CLASS_ID(1) | CFP_ACT1_FWD_MAP_REPLACE |
> +				  CFP_ACT1_DST_PORT5 : 0);
> +	if (!err)
> +		err = b53_fa_cfp_write(dev, index, CFP_ACC_ACTION);
> +	if (!err)
> +		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER, 0);
> +	if (!err)
> +		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER + 4, 0);
> +	if (!err)
> +		err = b53_fa_cfp_write(dev, index, CFP_ACC_METER);
> +	return err ?: b53_fa_cfp_write(dev, index, CFP_ACC_TCAM);
> +}

[Severity: Medium]
With vlan_filtering enabled, can these redirects to port 5 still reach
GMAC0 for VLAN-tagged traffic?

The trap actions do not set VLAN bypass. The comment in b53_fa_setup()
says VLAN filtering is preserved on purpose.

Port 5 is only a member of VID 0, which it gets from the
b53_for_each_port() loop in b53_setup(). For any other VID,
b53_vlan_add() is called for the user port and for its cpu_dp.
b53_preferred_cpu_port() makes cpu_dp port 8 for every user port, so
BIT(5) never ends up in dev->vlans[vid].members.

b53 sets ds->vlan_filtering_is_global. Enabling vlan_filtering on any
bridge on the switch therefore also turns on VLAN table enforcement for
the standalone ports, and those are the only ports with CFP
classification enabled.

Take a standalone port with an 802.1Q upper. Its tagged SYN/FIN/RST,
TTL 0/1 and oversized IPv4 frames are redirected to a port that is not
a member of their VLAN. So is everything caught by
B53_FA_DEFAULT_RULE. Wouldn't the switch drop these frames instead of
delivering them to Linux?

Should port 5 be kept in step with port 8 in b53_vlan_add() and
b53_vlan_del() when fa_cfp_enabled is set? Or should the trap action
bypass the VLAN check for port 5 after all?

[Severity: Low]
Is the policer meant to stay enabled here? The register layout matches
bcm_sf2: ACT_POL_DATA0/1/2 sit at 0x50/0x54/0x58 and RATE_METER0/1 at
0x60/0x64. In that layout, writing 0 to RATE_METER0 selects
POLICER_MODE_RFC2698. bcm_sf2 does this instead:

drivers/net/dsa/bcm_sf2_cfp.c:bcm_sf2_cfp_act_pol_set() {
    ...
	core_writel(priv, 0, CORE_ACT_POL_DATA2);
    ...
	/* Disable the policer */
	core_writel(priv, POLICER_MODE_DISABLE, CORE_RATE_METER0);
    ...
}

Here B53_CFP_ACTION(2) is never written before the action RAM commit,
and RATE_METER2..6 are never written at all.

Would every rule, including the allow rules, then get a zero-rate trTCM?
Would the third action word (MAC limit bypass, TC change, PCP/DEI remark)
come from whatever the staging register happens to hold? The TCP flag
loop in b53_fa_setup() open-codes the same sequence.

[ ... ]

> +static int b53_fa_setup(struct b53_device *dev)
> +{

[ ... ]

> +	for (rule = 0; rule < 3; rule++) {
> +		memset(data, 0, sizeof(data));
> +		memset(mask, 0, sizeof(mask));
> +		data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1 | CFP_TCAM0_UDF0_FLAG(rule);
> +		/* Slice 1; FIN, SYN or RST. */
> +		mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK | CFP_TCAM0_UDF0_FLAG(rule);
> +		data[5] = CFP_TCAM5_UDF_VALID(0); /* UDF A0 valid. */
> +		mask[5] = CFP_TCAM5_UDF_VALID(0);
> +		data[6] = FIELD_PREP(CFP_TCAM6_IP_PROTOCOL, IPPROTO_TCP);
> +		mask[6] = CFP_TCAM6_L3_FRAMING | CFP_TCAM6_IP_PROTOCOL | CFP_TCAM6_IP_FRAGMENT;

[Severity: Medium]
CFP_TCAM6_IP_FRAGMENT is in the mask with data 0, so these SYN/FIN/RST
traps match only unfragmented packets. b53_fa_guards() has no rule that
sends IPv4 fragments to port 5 either.

Take a first fragment (MF set, offset 0) with SYN, FIN or RST, TTL above
1, at most 1500 bytes, addressed to the port's router MAC. It would match
the allow rule and take the FA inline path instead of GMAC0.

If the original FA looks up first fragments, can TCP control segments
for a live tuple skip the exception path and Linux conntrack?

Two later pieces of the series seem to assume fragments are trapped:

  - The documentation says "IP options and fragments retire pairs by
    their L3 identity before Linux can process a reused tuple".
  - fa_control_receive() in the backend handles fragments.

[ ... ]

> +	/* Ordinary flooding must reach only the data CPU, not both MACs. */
> +	b53_port_set_ucast_flood(dev, 5, false);
> +	b53_port_set_mcast_flood(dev, 5, false);
> +	err = b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(5), PORT_CTRL_RX_UCST_EN);

[Severity: Medium]
Do the RX_*CST_EN bits do anything on port 5? b53_regs.h documents them
as port 8 only:

#define   PORT_CTRL_RX_BCST_EN		BIT(2) /* Broadcast RX (P8 only) */

At the same time, b53_enable_port() and b53_br_leave() add BIT(5) to the
PVLAN egress mask of every user port:

	if (dev->fa_cfp_enabled && (dev->fa_cfp_ports & BIT(port)))
		pvlan |= BIT(5);

b53_br_join() keeps that bit through its read-modify-write. b53 has no
broadcast flood mask, so broadcast frames would seem to egress both port
5 and port 8.

brcm_fa_tag_rcv() passes port 5 frames without BRCM_EG_RC_PROT_TERM up
the stack. Would Linux then receive ARP, DHCP and other broadcasts twice
on the user netdev, and forward them twice when the port is bridged?
That would not match "keep ordinary data flooding off the auxiliary CPU"
in the commit message.

[ ... ]

> +static int b53_fa_port(struct b53_device *dev, int port, bool standalone)
> +{
> +	struct dsa_port *control = dsa_to_port(dev->ds, 5);
> +	bool ready;
> +	u16 ports;
> +	int err;
> +
> +	if (!dev->fa_cfp_enabled)
> +		return 0;
> +	ports = dev->fa_cfp_ports & ~BIT(port);
> +	if (standalone)
> +		ports |= BIT(port);
> +	ready = b53_fa_ready(dev, dsa_port_conduit_is_operational(control));
> +	err = b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL,
> +			  ready ? ports : 0);
> +	if (!err)
> +		dev->fa_cfp_ports = ports;
> +	return err;
> +}

[Severity: High]
What protects a bridged port after b53_br_join() calls
b53_fa_port(dev, port, false)?

Clearing the port's bit in B53_CFP_CTRL turns off all of its guard rules
for as long as it stays bridged: SYN/FIN/RST, TTL 0/1, length, the
router-MAC allow rule and the default IPv4 trap.

b53_fa_conduit_state_change() and b53_fa_netdev_event() both call
brcm_fa_control_set_ready(data->conduit, false) before writing CFP_CTRL.
This function does not. FA readiness therefore stays true, and live
entries are not retired before this port's exception path goes away.

Port 8 is still the preferred CPU port. It still has unicast and
multicast flooding on from b53_setup_port(), and it is still in every
PVLAN mask.

A host on the bridged port could send a frame to a standalone port's
router MAC, carrying the tuple of a flow offloaded for that port. The FA
key has no input port, so would the frame be forwarded and NATed in
hardware without Linux seeing it? TTL 0/1, FIN/RST and oversized packets
on that tuple would get through the same way.

This looks like the "live tuple from bypassing Linux ingress policy on
another switch port" case that the commit message says is prevented. It
also breaks "Disable admission and retire entries before removing any
exception path". The later patches in the series leave this code as is,
and the documentation patch only says that CFP classification is disabled
on bridge members.

[ ... ]

> +static int b53_fa_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
> +{

[ ... ]

> +	control = dsa_to_port(dev->ds, 5);
> +	data_cpu = dsa_to_port(dev->ds, 8);
> +	brcm_fa_control_set_ready(data_cpu->conduit, false);
> +	if (event != NETDEV_PRE_CHANGEADDR) {

[ ... ]

> +	}
> +	err = b53_fa_rule(dev, B53_FA_ALLOW_BASE + dp->index, data, mask, false);

[Severity: Medium]
What brings back the allow rule and FA readiness if the address change
fails after NETDEV_PRE_CHANGEADDR?

On that event, this code writes an all-zero entry over the port's allow
rule and drops readiness for the whole data conduit. Only a later
NETDEV_CHANGEADDR undoes this.

netif_set_mac_address() can return early without sending
NETDEV_CHANGEADDR:

net/core/dev.c:netif_set_mac_address() {
    ...
	err = netif_pre_changeaddr_notify(dev, ss->__data, extack);
	if (err)
		return err;
	if (memcmp(dev->dev_addr, ss->__data, dev->addr_len)) {
		err = ops->ndo_set_mac_address(dev, ss);
		if (err)
			return err;
    ...
}

dsa_user_set_mac_address() returns -EADDRNOTAVAIL for an invalid address,
so "ip link set lanX address 01:00:00:00:00:00" is enough to trigger
this. A later notifier vetoing PRE_CHANGEADDR has the same effect.

Would all hardware flows then stay retired until an unrelated NETDEV_UP
or NETDEV_CHANGEADDR event, or a control conduit state change?

[ ... ]

> @@ -2439,6 +2775,10 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
>  		vl->members |= BIT(port);
>  		b53_set_vlan_entry(dev, pvid, vl);
>  	}
> +	if (b53_fa_port(dev, port, true)) {
> +		dev_err(ds->dev, "failed to restore FA classification on port %d\n", port);
> +		b53_disable_port(ds, port);
> +	}
>  }
>  EXPORT_SYMBOL(b53_br_leave);

[Severity: Medium]
Is b53_disable_port() enough on this failure path? It only sets the RX/TX
disable bits in PORT_CTRL. It does not set fa_guards_failed or drop FA
readiness, and fa_cfp_ports still lacks this port's bit.

The next ndo_open runs b53_enable_port(), which clears those bits:

	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);

The port is then standalone with no CFP classification. Its traffic goes
through port 8 and the FA while readiness is still true.

The notifier failure path sets fa_guards_failed for this kind of case.
Should this path set it too?

[ ... ]

> @@ -2564,6 +2905,46 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,

[ ... ]

> +static bool b53_uses_fa_tag(struct dsa_switch *ds, int port)
> +{

[ ... ]

> +		ethernet = of_parse_phandle(node, "ethernet", 0);
> +		fa = of_parse_phandle(ethernet, "brcm,flow-accelerator", 0);
> +		enabled = IS_ENABLED(CONFIG_BCM_NS_FA) && of_device_is_available(fa) &&
> +			  (dev->chip_id == BCM53011_DEVICE_ID ||
> +			   dev->chip_id == BCM53012_DEVICE_ID ||
> +			   (is5301x(dev) && of_device_is_compatible(fa, "brcm,bcm4708-fa")));

[Severity: Low]
Should this check use the compatibles listed in the binding?
brcm,bcm4708-fa.yaml allows brcm,bcm4708-fa, brcm,bcm53011-fa and
brcm,bcm53012-fa, and its example uses brcm,bcm53011-fa. bcm_ns_fa_init()
later in the series accepts all three.

As written, BCM53011/BCM53012 accept any available node without looking
at its compatible. BCM53010/53018/53019 accept only brcm,bcm4708-fa.

That leads to two mismatched setups:

  - A 5301x board whose DT uses brcm,bcm53011-fa or brcm,bcm53012-fa gets
    the FA backend set up on GMAC2, while b53 uses the ordinary brcm tag
    and installs no CFP guards.
  - A 53011/53012 board with an unrelated compatible gets FA tagging, and
    then bgmac probe fails.

[ ... ]

> @@ -3385,7 +3773,32 @@ int b53_switch_register(struct b53_device *dev)
>  	dev_info(dev->dev, "found switch: %s, rev %i\n",
>  		 dev->name, dev->core_rev);
>  
> -	return dsa_register_switch(dev->ds);
> +	ret = dsa_register_switch(dev->ds);
> +	if (ret || !dev->fa_cfp_enabled)
> +		return ret;

[ ... ]

> +	ret = register_netdevice_notifier(&dev->fa_netdev_nb);
> +	if (ret)
> +		goto unregister_switch;
> +	ret = devm_add_action_or_reset(dev->dev, b53_fa_unregister_notifier, dev);
> +	if (ret)
> +		goto unregister_switch;
> +	dev->fa_guards_ready = true;
> +	if (!dev->fa_guards_failed) {

[Severity: Low]
These plain bool flags are accessed concurrently with no common lock and
no READ_ONCE()/WRITE_ONCE():

  - Here, fa_guards_ready is written and fa_guards_failed is read outside
    rtnl, after b53_fa_netdev_event() is already live.
  - The notifier reads both flags under rtnl and may write
    fa_guards_failed.
  - b53_teardown() writes dev->fa_stopping without rtnl, while
    b53_fa_netdev_event() reads it for every netdevice event in the
    system.

The final readiness looks correct, because b53_fa_ready() is evaluated
again under rtnl_lock() below. Won't KCSAN still report these accesses as
data races?

[ ... ]

> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 4f44bf3ede238..2dffff2f6c343 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -69,6 +69,15 @@ config NET_DSA_TAG_BRCM_PREPEND
>  	  Broadcom switches which places the tag before the Ethernet header
>  	  (prepended).
>  
> +config NET_DSA_TAG_BRCM_FA
> +	tristate "Tag driver for the Broadcom Northstar flow accelerator"
> +	select NET_DSA_TAG_BRCM_COMMON
> +	help
> +	  Support the prepended four-byte FA metadata tag on Northstar GMAC2.
> +	  The receive format includes a hash, bucket, parser status, and input
> +	  switch port. Transmit uses the ordinary prepended Broadcom tag.
> +	  Enable this for a B53 switch explicitly connected to an accelerator.

[Severity: Low]
This isn't a bug, but the help text does not match the code.
brcm_fa_tag_xmit() puts the tag inside the frame for user ports behind
CPU port 5:

	return brcm_tag_xmit_ll(skb, dev, dp->cpu_dp->index == 5 ? 2 * ETH_ALEN : 0);

drivers/net/dsa/b53/Kconfig also selects NET_DSA_TAG_BRCM_FA
unconditionally, so the user has nothing to enable. Could the help text
be updated to match?

[ ... ]

> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -407,7 +416,100 @@ DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_PREPEND, BRCM_PREPEND_NAME);
>  #endif
>  
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
> +static LIST_HEAD(brcm_fa_controls);
> +static DEFINE_MUTEX(brcm_fa_control_lock);
> +
> +void brcm_fa_control_register(struct brcm_fa_control *control)
> +{
> +	mutex_lock(&brcm_fa_control_lock);
> +	list_add_rcu(&control->list, &brcm_fa_controls);
> +	mutex_unlock(&brcm_fa_control_lock);
> +}
> +EXPORT_SYMBOL_GPL(brcm_fa_control_register);
> +
> +void brcm_fa_control_unregister(struct brcm_fa_control *control)
> +{
> +	mutex_lock(&brcm_fa_control_lock);
> +	list_del_rcu(&control->list);
> +	mutex_unlock(&brcm_fa_control_lock);
> +	synchronize_net();
> +}
> +EXPORT_SYMBOL_GPL(brcm_fa_control_unregister);
> +
> +void brcm_fa_control_set_ready(struct net_device *conduit, bool ready)
> +{
> +	struct brcm_fa_control *control;
> +
> +	/* State callbacks can sleep while retiring hardware entries. */
> +	mutex_lock(&brcm_fa_control_lock);
> +	list_for_each_entry(control, &brcm_fa_controls, list)
> +		if (control->conduit == conduit && control->state_change)
> +			control->state_change(control->priv, ready);
> +	mutex_unlock(&brcm_fa_control_lock);
> +}
> +EXPORT_SYMBOL_GPL(brcm_fa_control_set_ready);
> +
> +static struct sk_buff *brcm_fa_tag_xmit(struct sk_buff *skb,
> +					struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_user_to_port(dev);
> +
> +	return brcm_tag_xmit_ll(skb, dev, dp->cpu_dp->index == 5 ? 2 * ETH_ALEN : 0);
> +}
> +
> +static struct sk_buff *brcm_fa_tag_rcv(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct dsa_port *cpu = dev->dsa_ptr;
> +	struct brcm_fa_control *control;
> +	struct dsa_port *data_cpu;
> +	unsigned int port;
> +	u8 reason;
> +
> +	if (cpu->index != 5)
> +		return brcm_tag_rcv_ll(skb, dev, ETH_HLEN, true);
> +	if (!pskb_may_pull(skb, BRCM_TAG_LEN))
> +		goto drop;
> +	reason = skb->data[0]; /* Embedded tag byte 2 after eth_type_trans(). */
> +	port = skb->data[1] & BRCM_EG_PID_MASK;
> +	skb = brcm_tag_rcv_ll(skb, dev, 2, false);
> +	if (!skb)
> +		return NULL;
> +	dsa_strip_etype_header(skb, BRCM_TAG_LEN);
> +	skb_set_mac_header(skb, -ETH_HLEN);
> +	if (!(reason & BRCM_EG_RC_PROT_TERM))
> +		return skb;
> +	data_cpu = dsa_to_port(cpu->ds, 8);
> +	if (!data_cpu || !dsa_port_is_cpu(data_cpu))
> +		return skb;
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(control, &brcm_fa_controls, list)
> +		if (control->conduit == data_cpu->conduit)
> +			control->receive(control->priv, skb, port);
> +	rcu_read_unlock();
> +	return skb;
> +drop:
> +	kfree_skb(skb);
> +	return NULL;
> +}
> +
> +static const struct dsa_device_ops brcm_fa_netdev_ops = {
> +	.name = BRCM_FA_NAME,
> +	.proto = DSA_TAG_PROTO_BRCM_FA,
> +	.xmit = brcm_fa_tag_xmit,
> +	.rcv = brcm_fa_tag_rcv,
> +	.needed_headroom = BRCM_TAG_LEN,
> +	.promisc_on_conduit = true,
> +};
> +
> +DSA_TAG_DRIVER(brcm_fa_netdev_ops);
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_FA, BRCM_FA_NAME);
> +#endif
> +
>  static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
> +	&DSA_TAG_DRIVER_NAME(brcm_fa_netdev_ops),
> +#endif
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
>  	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
>  #endif

[Severity: Medium]
Does the link-local check at the end of brcm_tag_rcv_ll() look at the
right bytes for this call?

With offset == ETH_HLEN the tag is prepended. eth_type_trans() on the
conduit therefore left skb->mac_header pointing at the four-byte tag,
not at the destination MAC. skb_pull_rcsum() only moves skb->data.
After the pull, eth_hdr(skb)->h_dest covers the tag plus the first two
bytes of the real DA. is_link_local_ether_addr() then does not
recognise 01:80:c2:00:00:xx frames.

Port 8 is the CPU port for all user ports on these boards. STP BPDUs,
LLDP, LACP and EAPOL received on bridged ports would all get
offload_fwd_mark set.

The switch only trapped these frames and did not forward them. With
the mark set, the bridge also won't forward them in software to other
ports on the same switch. That matters with STP disabled or with a
group_fwd_mask configured.

The port 5 branch in brcm_fa_tag_rcv() fixes up the MAC header with
skb_set_mac_header(), but this branch does not.

brcm_tag_rcv_prepend() seems to have the same problem already, so this
may need its own fix in brcm_tag_rcv_ll(). After the pull, it could
read the DA from skb->data - ETH_HLEN, or reset the MAC header first.
Which would you prefer?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
