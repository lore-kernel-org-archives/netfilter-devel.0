Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA822EB5AF
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 10:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756895657; cv=none; b=RwLCpyro8QS6t6L2ldaeiVYfgeIQ+sGPdafrIZ/P+D0+Nv3M8AAS7imCg7UKy/v4aHAklnHor9DwigDn0trRGOHvk6MTeZSULZit9N9TI+BdN53nGzgRccKzHaNf3Toro97ogr3nV9gxuIlIXTwmyXq95R34Hi3T4PsghsqQ4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756895657; c=relaxed/simple;
	bh=zRMSho8Vm8drw45K26uP52DrElaAiIBvwwY3XxJzWho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jk+Bmw74cEG4hWZAIVyei0K2ilzFJPKJRDzrmrw1TDCMvEmn78YEK/uDkFwVr0U1A66mRsyMcRxF9Ua1iYUxI5pSrm3RoKnJJicVN4+qVMrcc4HFrMtSOb9w/E7+DeJ7fdU9HG2O68aDKU9SvoqfJZ2CAR+GiwEnfsk3SELrr2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UYzEQ4w6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XJqFQjid; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UYzEQ4w6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XJqFQjid"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1503660718; Wed,  3 Sep 2025 12:34:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756895653;
	bh=swDfE20rSGAECdBsXPpBnk9JgSrtg8uX1bY5BzeM5n4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UYzEQ4w6aA/lzMQl+nDBCl/V9ANq6YwV9iPywcH7DsUnA2/8wHQvJsb4qZ1Dr0dze
	 Ym2QfumvZaB/Fg99OdXhU4/zMC6bEyl54+VDAghAOa+CEvkdGwYATSxTAlRK370aZY
	 fyGkLnefw7zp23pUvdrDZbSFmT9eWKaJI7epaqbdnTuHyZAvgytWrCekdYXtfcrbms
	 0xO3nbWbqZZYlH/YX0F0gYHfjfhojZZQOvdRuLbYg4aZM47qNzFt7JVoR5p53QxDGu
	 VeI/jyfklC8xFI4PyKoPwzpzduA2COpteiBgzGAUWGVqeFQG+/qWSkWDkiNb3p+3Lx
	 rBbxY7pz45Jlw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 63F466070D;
	Wed,  3 Sep 2025 12:34:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756895652;
	bh=swDfE20rSGAECdBsXPpBnk9JgSrtg8uX1bY5BzeM5n4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJqFQjidiow7aZ6TgJrEE/MTPJQ3MhjGHgAo7tESZV57nGoECXusxvYj3eqHgLBBX
	 UUAatjku4EY3qHyo2SCDhuKV9fOW01ErujTCoQDXfqLGD+ISSFI0m6rBG3vRUbj6rj
	 fHBXBUbMqQIxE89sFYOq1W0KJ7iTz+HOMh19AAVLde6u51yj2gypYaVRr9xQ7Gl/gO
	 AVaU11PBJaxSy9OmdJ8MwAnwsCrDmVSu1hG6BCe+ZRaAE0VHYjlY74TP6qnj7TR6LO
	 8MC7ie4ogxvA43LkCACFdrQ6GC534Ep2Sb2AxxADI1CT+KD5yFlB+7dWaf3ubGYeLx
	 frhlpyxlHoCkw==
Date: Wed, 3 Sep 2025 12:34:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Nick Garlis <nickgarlis@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
Message-ID: <aLgZoVg-lIffgWI-@calendula>
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
 <20250902215433.75568-1-nickgarlis@gmail.com>
 <aLdt7XRHLBtgPlwA@strlen.de>
 <CA+jwDR=zv++WiiGXTjp3pMrev2UPxx9KY1Y-bCFxDbOV7uvjbQ@mail.gmail.com>
 <aLgUyGSwIBjFPh82@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLgUyGSwIBjFPh82@strlen.de>

On Wed, Sep 03, 2025 at 12:13:38PM +0200, Florian Westphal wrote:
[...]
> You could submit a patch for nftables userspace to no longer
> emit NFT_CT_SRC/DST, I think there is no need to support kernels < 4.17
> anymore.

Yes. Better to fix this from userspace.

linux-stable-5.4$ git grep NFT_CT_DST_IP include/
include/uapi/linux/netfilter/nf_tables.h: * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
include/uapi/linux/netfilter/nf_tables.h: * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
include/uapi/linux/netfilter/nf_tables.h:       NFT_CT_DST_IP,
include/uapi/linux/netfilter/nf_tables.h:       NFT_CT_DST_IP6,
