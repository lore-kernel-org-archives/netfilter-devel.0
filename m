Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486471DDC2D;
	Tue,  7 Jan 2025 12:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736254054; cv=none; b=Qv1WWON8RnPHz7zjzCTuyxFnW481yFFgAgSX2SgOjxxURmQBp1E9YyRrlq4hAmWfQQ08w4L7xGVMhtBe5PjpfvZ2SOcX4frsc+iL1pCI2HBh6j4F0CPmSaHKfmGmYBfmTBYzSlsw4qg/5KMcyGmW9WYzMOAOU4/PkV5qMeHyH9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736254054; c=relaxed/simple;
	bh=1pqP5ae7PqeCdyvvJ4zyVU/qFLNksYeX7V4k2CRci/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qglEv7fenlnehh3QS3+3apDzzqrDYwef/UVJrz0Vwxl3HdxnBrAQkIlhGJPs5ySofPOBmQTf3llfoJ9x4DDKje+s9MZ4DrYg0lI9+y5UlD2fjMI0/4RlsmFeGaD7BziD6u28YhJrgxRZYPR0fqNSznqqMnNeUyBLzad1jp5708k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=zpkwdtRy; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="zpkwdtRy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=A1m6zoNK2OCrKmol3JpBlHNW7G1jM6bWvlDWkULF/m8=; b=zpkwdtRyHJ33oc0FoDYdcNRdXJ
	DGpoktI0tR5csqLEQk8ZcvABHSPAw9SYV3PGYd7QrvqVkFxAlxUihbo6DVQ64w7LCMFTTFlRPtcWr
	dvgfZr4gMA3idan/VnKEUjMm7UzJm8uRLTH1xE+QVcoz1zDYJcg6SbYzUHXYfk1F7+fo+orC361jn
	M0J+wwDvMXrSQC8RSkKe/v3IgHtnve7ybXTnAJ14XiIYudD4NvH/xvIEnGQYa+WzZwZzjbHjy6q4A
	N6a3VMxRzzTpHor8kMCN1J7uONVPsOZmstLUTtURL77aWoiJpDgAnLV22+XQ7bffuN/cL5i4ipxpz
	RVeZgwFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45594)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1tV8zP-0007QG-0w;
	Tue, 07 Jan 2025 12:47:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1tV8zL-0005IN-0Q;
	Tue, 07 Jan 2025 12:47:15 +0000
Date: Tue, 7 Jan 2025 12:47:14 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next] net: phylink: always config mac for
 (delayed) phy
Message-ID: <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
References: <20250107123615.161095-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107123615.161095-1-ericwouds@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

Going through the log...

On Tue, Jan 07, 2025 at 01:36:15PM +0100, Eric Woudstra wrote:
> Log before this patch is applied:
> [root@bpir3 ~]# dmesg | grep eth1
> [    2.515179] mtk_soc_eth 15100000.ethernet eth1: mediatek frame engine at 0xffff800082380000, irq 123
> [   38.271431] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
> [   38.279828] mtk_soc_eth 15100000.ethernet eth1: major config, requested inband/2500base-x
> [   38.288009] mtk_soc_eth 15100000.ethernet eth1: interface 2500base-x inband modes: pcs=01 phy=00
> [   38.296800] mtk_soc_eth 15100000.ethernet eth1: major config, active inband/inband,an-disabled/2500base-x

This is indeed without the PHY. We're using inband, although the PCS
mode is PHYLINK_PCS_NEG_INBAND_DISABLED, meaning inband won't be
used. As there is no PHY, we can't switch to MLO_AN_PHY.

> [   38.306362] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/none adv=00,00000000,00008000,0000e240 pause=04
> [   39.220149] mtk_soc_eth 15100000.ethernet eth1:  interface 2 (mii) rate match none supports 0-3,6-7,13-14
> [   39.229758] mtk_soc_eth 15100000.ethernet eth1:  interface 3 (gmii) rate match none supports 0-3,5-7,13-14
> [   39.239420] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
> [   39.249173] mtk_soc_eth 15100000.ethernet eth1:  interface 22 (1000base-x) rate match none supports 5-7,13-14
> [   39.259080] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
> [   39.594676] mtk_soc_eth 15100000.ethernet eth1: PHY i2c:sfp-1:11 uses interfaces 4,23, validating 4,23

The PHY comes along...

> [   39.603992] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
> [   39.650080] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
> [   39.660266] mtk_soc_eth 15100000.ethernet eth1: PHY [i2c:sfp-1:11] driver [RTL8221B-VB-CG 2.5Gbps PHY (C45)] (irq=POLL)
> [   39.671037] mtk_soc_eth 15100000.ethernet eth1: phy: 2500base-x setting supported 00,00000000,00008000,000060ef advertising 00,00000000,00008000,000060ef
> [   39.684761] mtk_soc_eth 15100000.ethernet eth1: requesting link mode inband/2500base-x with support 00,00000000,00008000,000060ef

We decide to use MLO_AN_INBAND and 2500base-X, which we're already using.

> [   40.380076] mtk_soc_eth 15100000.ethernet eth1: phy link down 2500base-x/Unknown/Unknown/none/off
> [   40.397090] brlan: port 5(eth1) entered blocking state
> [   40.402223] brlan: port 5(eth1) entered disabled state
> [   40.407437] mtk_soc_eth 15100000.ethernet eth1: entered allmulticast mode
> [   40.414400] mtk_soc_eth 15100000.ethernet eth1: entered promiscuous mode
> [   44.500077] mtk_soc_eth 15100000.ethernet eth1: phy link up 2500base-x/2.5Gbps/Full/none/off
> [   44.508528] mtk_soc_eth 15100000.ethernet eth1: No phy led trigger registered for speed(2500)

... but we don't see link-up reported by the PCS after the PHY comes
up. Why is that - I think that needs investigation before we proceed
to patch the issue, because that suggests the PCS isn't seeing
valid 2500base-X from the PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
