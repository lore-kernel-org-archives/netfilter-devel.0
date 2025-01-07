Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B941F433AD;
	Tue,  7 Jan 2025 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736256044; cv=none; b=i1v5Th8i1m2hhubFQra0BT83x3XJgCIbaTc8TU2p2YpEZgacWJuVeeoTpdz5bee7VG1n61ih3v+XLwmzb41BwQ3MOpucZzybAAyDQRXfMPfFNPR0XA66y+Sy7Hvxl/dY4+tyPU55VrETV4KePykfofxFwmP3thDebVPgbMs+Cgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736256044; c=relaxed/simple;
	bh=iXpBH5QQaChXU80mvcrbJK3qgP8gHwhtPEJudkDEDwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueNXlmVgVhntxYA9erMINTXWMujrciXVvYdIBQ8qyaO/bxkVbFrfgLKBxyKcB0RCmqHcdWVzUffVcpPYpImkrK8tEM6bB2UQpj4YYx9wAXCarSV2nuj/Iy4yP00SRuSa1rrXjwZU7C1Moary4vR2epUVRGu7yQV1lZQmg4UrPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=pz4PE7Ki; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="pz4PE7Ki"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=nkTBPMcZKmbWcBpdJkI4VttrnEz5cM46TWHXsBHT878=; b=pz4PE7Ki70rYKiXGmBZZ4+NDWP
	/Sw6LCV5/TgZpJgqhxM6DEoYZwwM1KWDP0MNGITFsM0jmpjK770DuMOWuI1BDxdoUmmGkJVbEWbij
	DxvVGh7ATOPSCbLex2I7X5gzKt8ezmZzLE3WvXX7y/kmLjL5DRSDGiY75k5FO2sT5rXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tV9VX-002Eki-8i; Tue, 07 Jan 2025 14:20:31 +0100
Date: Tue, 7 Jan 2025 14:20:31 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
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
Message-ID: <ed29e632-332b-4af1-bf7f-97498297e731@lunn.ch>
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>

> I think it is because pl->act_link_an_mode stays at MLO_AN_INBAND, but
> it needs to be set to MLO_AN_PHY, so that only the phy determines the
> link state:
> 
> phylink_resolve() {
>     ...
> 	} else if (pl->act_link_an_mode == MLO_AN_PHY) {
> 		link_state = pl->phy_state;
>     ...
> }

phylink tries to determine the whole chain is up. As Russell says, it
could be the PCS has not got sync with the PHY for some reason. So
even if you ignore the PCS state, it might not work. This is actually
a useful pieces of information. Does the link actually work end to end
if you only look at the media state? If it does, that would indicate
the PCS is maybe missing an interrupt, or needs polling for change in
state.

	Andrew
