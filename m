Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63252AD00
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791753122; cv=none; b=P789VRz9uhdphd/627UTud+TTCrI3KqIgA5z9xPJI1tdoRiPW6PbI1mk5smpE0Rkd5zovFWTGRqqmkx3dIaATYJmUN4L5XPEP3snPxmFN6nPx0NpnzWacJ8VHvmmsvGSXTqqZznlEjZpPX5i+5Z0GyZ3f4/KEoAvbRUr7UuamPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791753122; c=relaxed/simple;
	bh=n/47r1WgI1z6thLDLbf4b4ETvdQPxrZDv/jggXkuR2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAtlIQpwVFYjxXjPK/PdGC/WGPf8VUPlfxAtkEod74zeWo6FG8eBW3tcSAauV/k866zoAHVRs/OTaRvW6YOQYPYGmuHyeAF5OP3epVuPcUVEqnbfq9fySR/KibxBPGGK19atBsOevIjOlmc5ggy9Huf0WEf/m1IzhKjdKf5YZnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qm3UK/9V; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qm3UK/9V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791753116;
	bh=n/47r1WgI1z6thLDLbf4b4ETvdQPxrZDv/jggXkuR2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qm3UK/9Vwro7ym5CDmiQerBaIDScviLIL7O8c21X+TcH7bb30z9Qu5av6Ge3Ys12e
	 Uy4jYXP7+CMgSboZcPIGcw8nuaoJMOQe46YNfy4Av6xuw5ltNltbIL8f6lySeCLSqW
	 i6Z4uGECkIRpRSFRjLDrYtSePv3kgAAhmDCZvh44A/8EJJ2FNuD0+VF8uW1Sz5e69c
	 9SEUrvs9DNXntxHKc1VQL7uyDUDHADYaTRKXGoOzGfOEifRDVrSlvGQNg9kwkgHZm0
	 7Ug5TGM4e5SZ3McvF1W+AM3cB0odZLaaolCJPmpALNxmmQ2RJzqHoJ99Ax113RRJzr
	 F0Cw88Wa0c2Iw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CF1346005B;
	Sun, 11 Oct 2026 23:11:56 +0200 (CEST)
Date: Sun, 11 Oct 2026 23:11:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Cc: security@kernel.org, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: Re: [SECURITY] netfilter: nft_limit byte-rate bypass via unchecked
 u64 multiplication
Message-ID: <asv7meqLHaULXrYE@chamomile>
References: <CADikNYAX9Y0kTzdAZ4zNHrxcheN-tQ-DfQJxzmVmwgR9c5FKNw@mail.gmail.com>
 <ass78_hPLuoRO2kW@chamomile>
 <CADikNYCzQRErYLwDLoUPrDs8dmuBB8z+45yxKAaps7QTCrLXXA@mail.gmail.com>
 <asu_nz0tXmnsZIFQ@chamomile>
 <CADikNYBiijxQjptcYf-2+omXj8Mf5PTGVwK-Ho53E7JEe_ehvQ@mail.gmail.com>
 <CADikNYA74Zco-PnTvQOih+=A-Hq6ZCV1oyoC+xszGJy756gzMw@mail.gmail.com>
 <asvf-crRnd2ReH9c@strlen.de>
 <CADikNYDzCg46TWPk0dAXQF-Yar+FgEegWEzFZvzCp3x7-k_mOg@mail.gmail.com>
 <CADikNYBZ5MqJWypk5NFYcxYvPKJhKKyJ5iOWN4JTZrUWf1AUAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADikNYBZ5MqJWypk5NFYcxYvPKJhKKyJ5iOWN4JTZrUWf1AUAQ@mail.gmail.com>

On Sun, Oct 11, 2026 at 09:32:15PM +0100, SaifAllah benMassaoud wrote:
> One question: why was this not considered a security issue from your side?

This does not crash the kernel, this just does not work for this
esoteric ratelimit that your LLM found.
