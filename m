Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0B19CC0E;
	Tue,  7 Jan 2025 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736256405; cv=none; b=Fq2vJHQNvtLHtc/iEqWiaeWXmUdj3CpdSUtO0AQ5Weggkxy9rfeW44pd3OnCCeetZlAb8IJUsIKM2VBvKo+MmQzdm2SY+whbpuFXPsyPowWwc2Ot9aQdFxbEhObZ7XOa9YcMAtTsar0gTBK/CWDhuY5MMpPdZGLoKhUm2i64VgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736256405; c=relaxed/simple;
	bh=/m5ZT/WjZM4M4Tl41pBuRBotgmqPd6yqRyqz6qGuWjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hpgsKSO9ZxQMWI6ae8Y95hDh4CfU3H9Z8zlNJ8szHTwe8DdWwEPZ3+mAa/s2DnDZR/D0NaE6MxMbtS0jUm0WfAOp/ncdR4QC51K9jctzBu5o47J2NDYLizD74FcdVqYuz4jFHNJe0RufiA4iqUgpI59iV0o85vmjlqQJ38ijt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=EDja036Z; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="EDja036Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=I3Vv9Ii4oAyb2xBXKP796hUiYRnbIlEgJVRU6r0oeJ4=; b=EDja036ZoNSxV1Bflk1hEMKrwv
	l0MQhjpbFvH4DGCtNaEnCqBfs6+ja+sdJ1+3MFUfHdGSYEMEM7+COya16k8YkTYHFpea2P28anFtG
	g4Lm82NEcjog3dGCM5Mq1W8AwefLmTkWSOhDaxRexOJgqBfG0zlG2lox8z8tCa4GCMVc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tV9bM-002Est-OJ; Tue, 07 Jan 2025 14:26:32 +0100
Date: Tue, 7 Jan 2025 14:26:32 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Golle <daniel@makrotopia.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Eric Woudstra <ericwouds@gmail.com>,
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
Message-ID: <a5beb529-5769-4310-b6a4-0ddccd85caf1@lunn.ch>
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

> The PCS doesn't support in-band status in 2500Base-X mode, or at least
> the implementation isn't compatible with those RealTek PHYs.

Is one or the other not actually 2500Base-X, but SGMII over clocked?

Overclocked SGMII cannot do in-band signalling. It could well be the
PCS is 2500BaseX, but the PHY is over clocked SGMII, and so the PCS is
not seeing the in-band signalling it expects, so never reports link.

	Andrew
