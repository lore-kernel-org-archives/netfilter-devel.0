Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7DF21A444;
	Mon,  2 Jun 2025 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877973; cv=none; b=nzjirnvz0YJh7cZUsl8P5MOVJJJ3bzoymEX4X5sK4gZm7zvhqv5Q5287uQFapwFMPVh/6vr78yGpvobh6QDippk0V7XkIXYDtNRe+G21kb3KNmgpkfT189iFKJBHSLtrTK2YvxBTyrQqAkqsLa4zSVsBwHkuNWX9S6LUzabzvRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877973; c=relaxed/simple;
	bh=B/rTeYDT4bu9TqlcVS+AMRm0LLhf4oIY9pXCk0xIYWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhSOcSaIrtBpDY2s1NsDD74LVRrsFAq7P0K4zS1kEMSnRaoetiWwaBxxv4nr5FghCE51VTiPHKjzvxDDN5555B0IUg18pcoTLIibhdfzNI+Wi0TBC5/fr+GA3dznAaanQz5+LpJ8etl4DS1RQQ8RjgxdZ7N8MM1rmJvyEVqHz7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=nocTW5lJ; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="nocTW5lJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VsmBZUh+vyXv4ku+fzDdFGhVlt45TaS4taDV3PYjBJs=; b=nocTW5lJMQ/TMaA8qaPK4x9xGY
	YHoLB6m1pNtMbB+bEbBT3ru7jVtGgwGZvuPuGgBT253G23p3UJ5WHYUwS26S9UmPa9E+uG8S65Lxp
	GFCvWfH4t88+KK4RUBPL48KvgCAUHuXHoI6rfN4XYyHIAu63tdKU7phtVc8bOvBOsWMkJGxoRXWCs
	jbqQ2DqHn9IRa8f2y8hTgjiqY3qQrA03xW/9y1g8BT5x+suXlKEihGY1Wec0H4D5q2afAdyT+XUuv
	AYUOV3yQbBY+yxWNOC9lbQ8zTiB40WZ5nP2ReoIqYXljqYIhBiID+mpg1B3ma/Pe1QEpaghq6GeNh
	ql3M45uA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55524)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1uM72q-00051K-2g;
	Mon, 02 Jun 2025 16:25:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1uM72h-0007i6-0r;
	Mon, 02 Jun 2025 16:25:39 +0100
Date: Mon, 2 Jun 2025 16:25:39 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Ilya K <me@0upti.me>
Cc: Eric Woudstra <ericwouds@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <aD3Cc7gmB2Tev_ul@shell.armlinux.org.uk>
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>
 <Z31CJS1YUvPGiEXs@shell.armlinux.org.uk>
 <98234080-946e-4b36-832f-113b185e7bca@gmail.com>
 <Z3-Tz5WdLCat91vm@shell.armlinux.org.uk>
 <9cc913d7-7e5b-4b6c-886c-ca9778c3f970@0upti.me>
 <aD1lRha-enQ9Pw0g@shell.armlinux.org.uk>
 <2894a781-4d4b-4e3c-9f4e-7c1f04122f8a@0upti.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2894a781-4d4b-4e3c-9f4e-7c1f04122f8a@0upti.me>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Mon, Jun 02, 2025 at 04:00:14PM +0300, Ilya K wrote:
> That's weird, because I do have all the patches applied. I think this may have been broken by the pcs_inband_caps changes, because without the patch I'm just getting "autoneg setting not compatible with PCS", after which it bails, when it should really reconfigure the MAC instead.

Please enable phylink and sfp debug (adding #define DEBUG to the top of
phylink.c and sfp.c, and then send the kernel messages after reproducing
the issue.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
