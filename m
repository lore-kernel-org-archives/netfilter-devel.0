Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958163;
	b=GaDos1lruJgX1m6bb45rWKC7FKJSQzN/4x/ZZMmoZv+IZMi0vuNTELT7Ea0NBSbCRlwy
	 +vY5VSxx8Hnvtq06xj5A5jjsUATKMWMwUJ91GmgUWNIlUHqhrICO/XkneY9xyJIk/kwpI
	 TxHjlyNgNVwDSayn3q2/Ta5lqZsh+QkgkSPteAgQidjGj+nhDVyTf/NJiI/kwgItvXO1w
	 ZaxQ8Ds/l4bVPXFT2ABqXn42bBlgAiOXgqlUYyU27Kc38i2ZvTFTBeXA9lETqCzUcxczY
	 s9vlG8zn24VA1pcspz8s3xz7EYXhyljoVBM8HOH54PF3gRHK15dhI9XDw9xhUnajtZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958163;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7czCLb61MQ7e2lVrfFvuytX7334qaL/vl9LcdBlRFs4=;
	b=XDzfqnNE9dcNkd4+iTb/rELtMjCSiN/kAAXgcxtnh9T8G+sy1QN5jumGqWqQtgSTNRkU
	 f6PL7xdw1H/NF6d8IBIwpXxT/dK8PtAee/aTZhX1es8CkbbkVg7ym4mxkheuTys/RECPA
	 0/dhLyYzPGRLcjrVu3v3aQUbZbkEY7Q6G4ppOqaJ2yc+ZU4zXKrRkUM4homyKsu5ZfFZv
	 G83IU9+wBF+BQopgIDRTol48ZNPqKb0kNpfSKcxaQaa/xQOQDRsIauEdkKGiiYzGgnllq
	 jhgSBVIYhmhISIDtKsEqeAdTIj8JFRRh4uDlBsWJX5PYVpg1b62H59yVIQquRm0oZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HY7fticU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD0606A33F;
	Tue, 17 Nov 2026 23:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HY7fticU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4811F000C4;
	Tue, 17 Nov 2026 23:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958163;
	bh=7czCLb61MQ7e2lVrfFvuytX7334qaL/vl9LcdBlRFs4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HY7fticU0ncnVtnMX8BdBAlFhAwzYEMRXLhpGcJ75TxgcuftNn0RVTD3YF/TlwVQW
	 M1uFQddpe6EM4kh9ZAp381qbW2Jc16telpftmXHXrHfFfTqgYpX0ybNdEqNs8zYmTn
	 hP/yYKveNH/sEmMfLukd0yV6A9LQ3xD3wV2FliPa3LfPeQNUC2Zf//xlJeBNE7vXuw
	 2dp/5SjfsQDjijd7yVUZhZS3ZrF1VnEGl9IawXgaxJiBBg4Xa+OCLw/RLbrog0Kuw/
	 /O5rAg7TkAm9ZTGAvrR/Gf+yjOBl6AjNAHV51kRNo+hnt7AdzHddF+IGKeMc6G4t4c
	 Dzc3d+W0gkU9w==
Subject: Re: [PATCH net-next 4/9] dt-bindings: net: describe the Northstar
 flow accelerator
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
Date: Tue, 17 Nov 2026 23:29:21 +0000
Message-ID: <179495816151.3136.14110323389854628043@kernel.org>
In-Reply-To: <20261116222519.1416501-5-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-5-florian.fainelli@broadcom.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The flow-accelerator register resource in brcm,bcm4708-fa.yaml
  is modelled as a standalone MMIO block with only `compatible` and…
- [Low] The new brcm,bcm5301x-gmac.yaml schema is selected only when the
  `brcm,flow-accelerator` property is present (`select: required:…
- [Low] The FA binding description calls switch port 5 'IMP5' ('Switch
  port 5 (IMP5), connected to GMAC0, ...').

--

dt-bindings: net: describe the Northstar flow accelerator

This commit adds a binding for the register block of the
BCM4708/BCM53011/BCM53012 flow accelerator. It also adds a schema for the
brcm,flow-accelerator phandle on the GMAC2 BCMA Ethernet node. The
description covers the second CPU path, port 5 to GMAC0, for exceptions
that bypass the accelerator.

> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
> new file mode 100644
> index 0000000000000..f744b23433c46
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
> @@ -0,0 +1,45 @@

[ ... ]

> +description: |
> +  The flow accelerator is inline between GMAC2 and switch port 8 (IMP0).
> +  GMAC0 and GMAC1 bypass it. The GMAC2 BCMA Ethernet node references this
> +  register block through a brcm,flow-accelerator phandle. Miss packets carry
> +  a prepended accelerator descriptor in place of the embedded switch tag.
> +
> +  Switch port 5 (IMP5), connected to GMAC0, provides a second CPU path for

[Severity: Low]
Should this say IMP1 instead of IMP5? The b53 SRAB code calls the two IMP
ports IMP0 (port 8) and IMP1 (port 5):

drivers/net/dsa/b53/b53_srab.c:
#define  B53_SRAB_IMP1_SLEEP_TIMER	BIT(10)
#define  B53_SRAB_P7_SLEEP_TIMER	BIT(11)
#define  B53_SRAB_IMP0_SLEEP_TIMER	BIT(12)

This description already uses IMP0 for port 8.

> +  exceptions that must bypass the accelerator, including TCP control,
> +  low-TTL and oversized packets. Describe that CPU port with an ethernet
> +  phandle to GMAC0 and an internal, 1 Gbps full-duplex fixed link in the
> +  switch's ports node. Port 8 remains the data connection to GMAC2.

[ ... ]

> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    flow-accelerator@18027c00 {
> +        compatible = "brcm,bcm53011-fa";
> +        reg = <0x18027c00 0xc0>;
> +    };

[Severity: Medium]
Can the flow accelerator be treated as a standalone MMIO block? The example
address 0x18027c00 falls inside the 4 KiB BCMA window of GMAC core unit 3.
bcm-ns.dtsi already describes that core under the 0x18000000 axi bus:

arch/arm/boot/dts/broadcom/bcm-ns.dtsi:
		gmac3: ethernet@27000 {
			reg = <0x27000 0x800>;
		};

The binding allows only compatible and reg. It has no clocks or resets
and no link to the GMAC3 core. It also does not say that the hosting core
must be out of reset and clocked.

Later in the series, bcm_ns_fa_init() in
drivers/net/ethernet/broadcom/bcm-ns-fa.c maps this node and writes to it
straight away:

	np = of_parse_phandle(parent->of_node, "brcm,flow-accelerator", 0);
	...
	fa->regs = devm_ioremap_resource(parent, &res);
	...
	writel(0, fa->regs + FA_STATUS_MASK);

Nothing in bgmac or bcm-ns-fa calls bcma_core_enable() on core unit 3.
bgmac_probe() also rejects core_unit 3 when that core has no MAC address,
so it never gets enabled there.

Suppose the bootloader leaves the GMAC3 wrapper in reset or clock-gated.
Could bgmac_probe() for GMAC2 -> bcm_ns_fa_init() -> writel() then take
an imprecise external abort or hang the bus? And if something later resets
the GMAC3 wrapper, would that wipe the programmed FA state?

This is inferred from how AI wrappers usually behave. I have not checked
it against the Northstar register map, so I can't confirm that GMAC3
hosts the FA. On BCM53012 boards where CFE leaves core 3 enabled, it may
work as is.

Should the binding describe how the FA relates to its hosting core, or
the clocks and resets it depends on?

> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml b/Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
> new file mode 100644
> index 0000000000000..76fbe2abf5152
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
> @@ -0,0 +1,27 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,bcm5301x-gmac.yaml#

[ ... ]

> +select:
> +  required:
> +    - brcm,flow-accelerator
> +
> +properties:
> +  brcm,flow-accelerator:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: |
> +      Phandle to the BCM4708, BCM53011 or BCM53012 inline flow accelerator.
> +      Only GMAC2 (BCMA Ethernet core unit 2) has this connection.
> +
> +additionalProperties: true

[Severity: Low]
The "Only GMAC2" restriction exists only in the description text. The
schema is selected purely by the presence of the property, and it sets
additionalProperties: true. Wouldn't a DT that puts brcm,flow-accelerator
on gmac0 (ethernet@24000), gmac1 or gmac3 still pass dt_binding_check and
dtbs_check?

Nothing checks that the phandle points to a brcm,*-fa node either.

Later in the series, bgmac_probe() in bgmac-bcma.c enforces the rule at
runtime:

	if (of_property_present(core->dev.of_node, "brcm,flow-accelerator") &&
	    core->core_unit != 2)
		return -EINVAL;

So a misplaced phandle makes that GMAC fail to probe, and dtbs_check gives
no warning beforehand.

Separately, the file name and $id suggest a brcm,bcm5301x-gmac compatible,
but the BCMA GMAC nodes have no compatible. Is that naming intended?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
