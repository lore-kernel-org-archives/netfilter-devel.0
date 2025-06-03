Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [178.154.239.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312D65FB95;
	Tue,  3 Jun 2025 18:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748975124; cv=none; b=mKB/BxUpa6iwco3WenfygI0JJHqMQ2upFfUJuuy3oHr09hCBVtat2VwLMvDvbYgu3e59iuAqLt0dHXJ3sVf50xa4fhH8EyJL9ZNcRxSKl6n9f4FEPBLv7gm3Ym7LYt5xFSJLdZbrKd0UKoZAIIaREJG67RYlAeDb0xtcSCz+RVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748975124; c=relaxed/simple;
	bh=tBzj3CA4+7TehMQW8dgTuM4sRw0JZHsMeayjCn7V8XI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDXibchTcUWvkN0bvvGGis7yvu2kt1UeniZzkETqITdejQHoUmKFgrdb49UUkQ+IYFwAGILJKntdyah+VP9E0HXPtc8F2HqLoYKIYBoKkEO4h47rIxJCeqBprP503zl6gf+5iQAkvfQjYmoSXe5vD2YF3keVfLqw6Hus2+UNYX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=lfjC88AQ; arc=none smtp.client-ip=178.154.239.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="lfjC88AQ"
Received: from mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:842f:0:640:b96f:0])
	by forward502d.mail.yandex.net (Yandex) with ESMTPS id EBB8760C59;
	Tue,  3 Jun 2025 21:17:25 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LHgCkEULiKo0-pLzcZTYY;
	Tue, 03 Jun 2025 21:17:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1748974644; bh=pOpYljZuYO3T7PKQuPSq6hSLphxMmYBM9c7hIldkB8Q=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=lfjC88AQLYLUsUJy3b7nRVzevTZKollL8zItXcXC4rgjno4MWLGx6K+HDJLEJW5Rh
	 YYsmCJsPg7cOuXLi+Dm6HNyLtLYQKa+LofdjRX7bQxnh6dlTW3AwOjaGjOb6PbLec6
	 iyRtRNFb5eGkXo7L0wJ2J1pBv0BJdWAL954cjgbw=
Authentication-Results: mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Message-ID: <40ac27ab-00f7-4fc4-97ca-f3b519167f5c@0upti.me>
Date: Tue, 3 Jun 2025 21:17:21 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC net-next] net: phylink: always config mac for
 (delayed) phy
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Eric Woudstra <ericwouds@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Heiner Kallweit <hkallweit1@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>
 <Z31CJS1YUvPGiEXs@shell.armlinux.org.uk>
 <98234080-946e-4b36-832f-113b185e7bca@gmail.com>
 <Z3-Tz5WdLCat91vm@shell.armlinux.org.uk>
 <9cc913d7-7e5b-4b6c-886c-ca9778c3f970@0upti.me>
 <aD1lRha-enQ9Pw0g@shell.armlinux.org.uk>
 <2894a781-4d4b-4e3c-9f4e-7c1f04122f8a@0upti.me>
 <aD3Cc7gmB2Tev_ul@shell.armlinux.org.uk>
Content-Language: en-US
From: Ilya K <me@0upti.me>
In-Reply-To: <aD3Cc7gmB2Tev_ul@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-06-02 18:25, Russell King (Oracle) wrote:
> On Mon, Jun 02, 2025 at 04:00:14PM +0300, Ilya K wrote:
>> That's weird, because I do have all the patches applied. I think this may have been broken by the pcs_inband_caps changes, because without the patch I'm just getting "autoneg setting not compatible with PCS", after which it bails, when it should really reconfigure the MAC instead.
> 
> Please enable phylink and sfp debug (adding #define DEBUG to the top of
> phylink.c and sfp.c, and then send the kernel messages after reproducing
> the issue.
> 
> Thanks.
> 

OK, somehow it just works normally now, even with the patch reverted. I think I grew a few gray hairs over the last few days. Sorry for the trouble, everyone, I'm off to not touch this thing ever again.
