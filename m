Received: from forward501a.mail.yandex.net (forward501a.mail.yandex.net [178.154.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0611B221DA0;
	Mon,  2 Jun 2025 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748869727; cv=none; b=ZD6cGKTjFrI6QeogsVoCiHkftC24lAnMYX0wlZJ5snmZIxCvMpHmIqsfOz2zGbD0tV6hZiKSExROIMXRURTV8EUYrqcYsYlS3d8nbHmojrocCk0BRuAKGSoAPMSawBBhj6p9jxm0Euhhs7Ii2PuVfcTXQB26Xrj1Qe7SEu0mPsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748869727; c=relaxed/simple;
	bh=yTEXqsnUcW3cl5WcXbdMtFzmwUho1rDc7vZsuRYKyXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTfWjxXNz6q98PXo1kFA9yDRzg5MMs0uH9UA7FECSCgeupQ8iu7SjxPeCqjzdYsrg30hfiXy82VGV0iG82mpU4Gj9TpvIgynItNEgM0qLiVqWs1DhXggNP5DT53unxNDhC1xCQ/BNpIztrNnx8NBqxUuLRJKEAbn76scvMgMzZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=EzcWINEr; arc=none smtp.client-ip=178.154.239.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="EzcWINEr"
Received: from mail-nwsmtp-smtp-production-main-74.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:160e:0:640:a44a:0])
	by forward501a.mail.yandex.net (Yandex) with ESMTPS id 89D6961677;
	Mon,  2 Jun 2025 16:00:19 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id F0aS6QbLoa60-v1prNre5;
	Mon, 02 Jun 2025 16:00:18 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1748869218; bh=oZ32ri9UvCA0ZFnxXbOjw3nZYx8ajIN2VWmbh80DLjU=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=EzcWINEr1YcBsyckPUR3nlN3K+/LMzSaQKkMLqlbcJj6CrPBngXx/eDKc18C6WbJ+
	 RJztATJ/WAvys8DZNnSxo0MbSn+9ezY18d5m9s1x9LMmcGUTwkR4lIQP67AAm6ZkCd
	 Gv5gMnOxTZ5Oaa0NtUAkqX5gKrFUfqZi7JSa191U=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.iva.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Message-ID: <2894a781-4d4b-4e3c-9f4e-7c1f04122f8a@0upti.me>
Date: Mon, 2 Jun 2025 16:00:14 +0300
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
Content-Language: en-US
From: Ilya K <me@0upti.me>
In-Reply-To: <aD1lRha-enQ9Pw0g@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-06-02 11:48, Russell King (Oracle) wrote:
> On Mon, Jun 02, 2025 at 10:19:22AM +0300, Ilya K wrote:
>> On 2025-01-09 12:15, Russell King (Oracle) wrote:
>>> On Thu, Jan 09, 2025 at 09:56:17AM +0100, Eric Woudstra wrote:
>>> I'll look at what we can do for this today.
>> Hey folks, don't really want to necrobump this, but the original hack patch is the only way I can get my weirdo Realtek (noticing a pattern here) GPON modem-on-a-stick to probe at 2500base-x on a BPi-R4. I've actually tracked down the issue myself and wrote basically the same patch first :( Is there anything I can do (with my extremely limited phylink understanding) to help move this forward so other people don't have to suffer like I did?
> 
> There were two issues that were identified. The first was that when in
> 2500Base-X mode, the PCS wasn't reporting link-up. That was addressed
> by the patch series:
> 
> Z4TbR93B-X8A8iHe@shell.armlinux.org.uk
> 
> then, the replacement for Eric's patch was:
> 
> E1tYhxp-001FHf-Ac@rmk-PC.armlinux.org.uk
> 
> So the problem should be solved with these applied, as when the PHY is
> attached, "changed" will always be true, which is in effect what Eric's
> patch was doing, but in a cleaner way.
> 
> Please confirm that you have all six patches applied.
> 

That's weird, because I do have all the patches applied. I think this may have been broken by the pcs_inband_caps changes, because without the patch I'm just getting "autoneg setting not compatible with PCS", after which it bails, when it should really reconfigure the MAC instead.

(resending because I replied instead of reply-all by accident)
