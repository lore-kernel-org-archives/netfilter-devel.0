Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76978259499;
	Tue,  7 Jan 2025 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736261980; cv=none; b=OnuK1w8+NNqnUCCo5eT9Z4c2bYhBoWKYRD0rN2n7DiAipBEoYguGpsQWK/DyQr8KKqdMLPvhZoaW8WIgFmCH98yEQXhh62fAJWdnQ/mnV+5CpZrH1Zyi8Xbd0V0MbxAFh1D1BKAzntZkS9HEm5SO0Hzij9H4zZM6kAg+2FHgR44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736261980; c=relaxed/simple;
	bh=6AfXFF1Cv3J/f7dW7sRs1gXrCasbCYC2JdzcosUF/xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SxO2UwxqZjJ5AIeG0U+PPxK0VcDhjc0PySGmK3n5IzaHXOGNYRRcuaJhSW6aHjal1P9fjJU0B3gkJsOf1Xjrlj/5USmpf93+SDu0KFK7eEsT25vHhEQQ8v5ZMcIZ4fWtt5iykAcVr7kz58MNYJdbRJtvFxhAkrh6SQI+dtIc/Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=kALKCcA3; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="kALKCcA3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4ZoD+gvKfB/ed9HjsLTaCjOZ9SwK5xZrjHcan7418rw=; b=kALKCcA3IFaOOLmMdjti7LK+bD
	RcS7EGoLurmty1XbnbAoumDhcat2e6Xkd5KfAYFAnroHw/sNowJQJKckvkepCZqMCwBtWDyNyNQ+2
	DOAfVtc1YqsdZq3jHxs/3e4lXv3UpHFsTzgSTQmyd1EFuAf1+D0+MYI0gkKWOSWEdoPUTdJs+qzlk
	jqC82QEDE6jYDOSQR0AspwlRUwRAbU9GBlynBp9V+CL7/6U+2sRXRk1SfyUlKfalpHN82Udk4FisO
	ZNxX2Ak6PrBeh7xEXQUfbTYTm3mA7d4Hm5aBUfhxzfqEU3Bld+KRinkR7pYoBO8Pud7AV6v7YQzlJ
	lwznVA3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58096)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1tVB3B-0007ct-0c;
	Tue, 07 Jan 2025 14:59:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1tVB36-0005Mv-25;
	Tue, 07 Jan 2025 14:59:16 +0000
Date: Tue, 7 Jan 2025 14:59:16 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Eric Woudstra <ericwouds@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next] net: phylink: always config mac for
 (delayed) phy
Message-ID: <Z31BRMay2QgcjX2R@shell.armlinux.org.uk>
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <Z30pMSxDn-R3Cy5S@makrotopia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z30pMSxDn-R3Cy5S@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Tue, Jan 07, 2025 at 01:16:33PM +0000, Daniel Golle wrote:
> On Tue, Jan 07, 2025 at 12:47:14PM +0000, Russell King (Oracle) wrote:
> > ... but we don't see link-up reported by the PCS after the PHY comes
> > up. Why is that - I think that needs investigation before we proceed
> > to patch the issue, because that suggests the PCS isn't seeing
> > valid 2500base-X from the PHY.
> 
> The PCS doesn't support in-band status in 2500Base-X mode, or at least
> the implementation isn't compatible with those RealTek PHYs.

There is in-band for base-X, which involves 16-bit control words to
report the capabilities of either end (basically half/full duplex,
pause modes). Unlike SGMII, it doesn't contain any status bits for
link up, because that is irrelevant.

Link-up state in base-X modes comes from the PCS itself, whether the
PCS is in sync with the media, and whether it has valid format. This
has *nothing* to do with in-band.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
