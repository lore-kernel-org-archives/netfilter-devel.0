Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CA3E51D0
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 23:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445246; cv=none; b=JL9mNeWsH9H1a4Pd2V1Qp3dCMRHpmiFteXmIqIfqRQiyfBJhxVTHcF9MOmbwrOPwdpMAcqH5Ho3aBroYjgG8rFnBkb30/FBRJeTY6+OUZjJRRrGad8MqrhYHSSoi+FqB1RoD+NvXCecmkOgkeGr13KGneJyg8WFVM6+WQ0xRHvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445246; c=relaxed/simple;
	bh=4oi0o/OEND28cLeahdAWn4IC1ysSwdIThbN1PdkRRs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VoJvwGZ7F9BtEiYl7wRz7cF2c+SLaKrOfEzFHZK9Ic9R6+FFheueAPkrJSiKcp2dh9xkqSFoRFOseMedMGckQwE+NpTKDa1k4Cw3kCxz/cogTuBu3YCTiIfy6u77/WKLPCzCVCvMoDHPH89u+LffE1bSKYCWFyj9PgyeWEJ5ddI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A71076047A; Sat, 14 Mar 2026 00:32:35 +0100 (CET)
Date: Sat, 14 Mar 2026 00:32:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_nat_sip: validate exp->dir in
 nf_nat_sip_expected()
Message-ID: <abSelah2hPOUbEng@strlen.de>
References: <20260313201346.562476-1-qguanni@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313201346.562476-1-qguanni@gmail.com>

Jenny Guanni Qu <qguanni@gmail.com> wrote:
> nf_nat_sip_expected() uses exp->dir to index into the 2-element
> tuplehash[] array without bounds checking. If exp->dir has an
> out-of-range value, this causes a slab-out-of-bounds read.
> 
> KASAN reports:
> 
>   BUG: KASAN: slab-out-of-bounds in nf_nat_sip_expected+0x804/0x938
>   Read of size 8 at addr ffff0000d113e3b8
>   The buggy address is located 72 bytes to the right of
>    allocated 240-byte region
> 
> Add a bounds check to ensure exp->dir is less than IP_CT_DIR_MAX.

Ok, but exp->dir isn't expected to contain crap.

How does exp->dir become >= IP_CT_DIR_MAX?
Are you sure this isn't papering over another bug?

In particular, there is missing validation in the ctnetlink code
for the dir argument.

https://lore.kernel.org/netdev/20260313150614.21177-3-fw@strlen.de/
