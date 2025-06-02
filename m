Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A27E2C325A;
	Mon,  2 Jun 2025 07:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748849255; cv=none; b=RptVLF326lqnjwWOFvmzNXfUNne32A0WaH9VniaKDVbpPu/1MCxcTm0/wR0e8T1IGkJm1BZQzF/UsagX2d14KRhE52jhJXek5aDYlXzzmszVCHwAt9wpFOcwy8YSJvOjDoQqzur3nLW7fmVSfuD7HS1r/YuFWzIPzRA8p6Qwygk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748849255; c=relaxed/simple;
	bh=G4aZKGSQPz/8voWyJkorwYkhzOYNTkUjx/JN/k2FWQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fsadRxI0tjwpVzspybZu7HYKylDEKFz5P5KRW4IgjZJdO+VKtMhk9gFsoBByHtnDRu1JFubmj9rXZIaja2T4H/3bMZwiEy1Ha8EdUooxRh2fk87GoZKYNE+GVZ7WKqBvZmng4VIlm8R4qkn3WmAIZS8zisMRXfOaNQixl7+ExjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=GvrTeIBL; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="GvrTeIBL"
Received: from mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:c122:0:640:3648:0])
	by forward502b.mail.yandex.net (Yandex) with ESMTPS id 2AF7B60D83;
	Mon,  2 Jun 2025 10:19:32 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id RJUpJHHLi8c0-hfsa8QqR;
	Mon, 02 Jun 2025 10:19:31 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1748848771; bh=G4aZKGSQPz/8voWyJkorwYkhzOYNTkUjx/JN/k2FWQE=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=GvrTeIBLtjaZsU746DJnnqDfouxT39Ss2JFa+ViS8lhkrNTHiyeIaEgPOCRJufifx
	 ypWBAlyqitB55eomIvIMRCoBB2IT01KecMEktzXuOc/CxPvYxducIqrT1ComqNutT7
	 yJ94HBeuNVi2/PzMTHPIuFbzOpMKw5Py+7TzBuNY=
Authentication-Results: mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Message-ID: <9cc913d7-7e5b-4b6c-886c-ca9778c3f970@0upti.me>
Date: Mon, 2 Jun 2025 10:19:22 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC net-next] net: phylink: always config mac for
 (delayed) phy
To: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
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
Content-Language: en-US
From: Ilya K <me@0upti.me>
In-Reply-To: <Z3-Tz5WdLCat91vm@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-01-09 12:15, Russell King (Oracle) wrote:
> On Thu, Jan 09, 2025 at 09:56:17AM +0100, Eric Woudstra wrote:
> I'll look at what we can do for this today.
Hey folks, don't really want to necrobump this, but the original hack patch is the only way I can get my weirdo Realtek (noticing a pattern here) GPON modem-on-a-stick to probe at 2500base-x on a BPi-R4. I've actually tracked down the issue myself and wrote basically the same patch first :( Is there anything I can do (with my extremely limited phylink understanding) to help move this forward so other people don't have to suffer like I did?
