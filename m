Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317227485;
	Mon,  2 Jun 2025 08:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748854128; cv=none; b=Sim46KFSHXXK9a3uJjrVgK3Osj+Bs4F1z9DuUEYQUd6PW6uUDjCftnnteEUlSW775a4ArlSMT5mS3YmrJX9XBNHuPknMjv6oWeJyv5i35p6NFhLFONHZGXOZhBM17yvLmr5oY/GPHhFyVEQHUpO0JDMgVpfSPCLflFiiO5yaLew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748854128; c=relaxed/simple;
	bh=5/sevNRgUt6k0r1juPz1NfFjuiEUMfrLGg3QCLM8iHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s88dzHxWOXGeJq+qGcZXfTmv3kenXok6H4T7mwbGYnEX8PpshNQv1X9KQ4MAk1n1U946+vtSvaOq6eWMcDHlx475MZObB2szVicAQD0cwnb1v0naFxP6FK/yrm9WEAABGSjSCHPdKig5MFWlksEPhZ9A3mXIDbuj4WLOKuhzNPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=st4dgS23; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="st4dgS23"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X/XDYHOwQufeL3WOK7DdzyqsaQP2GwX+j+gHD2jSDoU=; b=st4dgS23gYo9uTJ4WSZyD5h1FZ
	iX71+qBxv96XEy06iZm1hcqK8iPrrSPd+HMqpg7qgyuW8mO43CGLlfYGSj7VyKZn+icV81LD9qbMy
	2Cw6EYaw/GB4tEFRF72g3r+29zEVus7wfsy1X9xB4TvzVN7WzhyjxfkW3yanNb4QyhhcYAyvlQkbu
	VmJEM1B6SIuHRPcqIOlSrLH6Esk6FYQVDbSWKSyFisAp/nqYzE7zbXhwa/lwk26bflsbhqmQlSvyL
	4MuOveqsNvgKgRsgggn5QWooR85qOmB/7J5uRoKkb0EW4ADBkKKOhSLN4OzhfWYr/XZe1hKSc4jBE
	jU0/mrQw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35874)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1uM0q6-0004hi-13;
	Mon, 02 Jun 2025 09:48:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1uM0py-0007Ug-1a;
	Mon, 02 Jun 2025 09:48:06 +0100
Date: Mon, 2 Jun 2025 09:48:06 +0100
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
Message-ID: <aD1lRha-enQ9Pw0g@shell.armlinux.org.uk>
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>
 <Z31CJS1YUvPGiEXs@shell.armlinux.org.uk>
 <98234080-946e-4b36-832f-113b185e7bca@gmail.com>
 <Z3-Tz5WdLCat91vm@shell.armlinux.org.uk>
 <9cc913d7-7e5b-4b6c-886c-ca9778c3f970@0upti.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cc913d7-7e5b-4b6c-886c-ca9778c3f970@0upti.me>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Mon, Jun 02, 2025 at 10:19:22AM +0300, Ilya K wrote:
> On 2025-01-09 12:15, Russell King (Oracle) wrote:
> > On Thu, Jan 09, 2025 at 09:56:17AM +0100, Eric Woudstra wrote:
> > I'll look at what we can do for this today.
> Hey folks, don't really want to necrobump this, but the original hack patch is the only way I can get my weirdo Realtek (noticing a pattern here) GPON modem-on-a-stick to probe at 2500base-x on a BPi-R4. I've actually tracked down the issue myself and wrote basically the same patch first :( Is there anything I can do (with my extremely limited phylink understanding) to help move this forward so other people don't have to suffer like I did?

There were two issues that were identified. The first was that when in
2500Base-X mode, the PCS wasn't reporting link-up. That was addressed
by the patch series:

Z4TbR93B-X8A8iHe@shell.armlinux.org.uk

then, the replacement for Eric's patch was:

E1tYhxp-001FHf-Ac@rmk-PC.armlinux.org.uk

So the problem should be solved with these applied, as when the PHY is
attached, "changed" will always be true, which is in effect what Eric's
patch was doing, but in a cleaner way.

Please confirm that you have all six patches applied.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
