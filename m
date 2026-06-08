Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8984B3B14DA;
	Mon,  8 Jun 2026 22:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780958375; cv=none; b=QIRy3/P4Be06rFLDKoepsXUMas4u4LZwGJhiCrVQ+cvF89YLYSBar3xqKDID09nmjOGhACI7YjIlp+sW4qRbRFutrNVLOo63vBznRtlbBL6RDJEPyxGmMro8Y7Oj2rs03snMrn2vGHYFZW/gIcvgsSDEUw289GYZWgHP0TKh828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780958375; c=relaxed/simple;
	bh=+Fi3sVsuwExNL+7pNEZPC52ELM3zS+sCwv6XvTeLfIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsIVzior6vwc68LFX9/gXBctoJCNg8BKEIbH/u5cBP9VhXcWWlQ94QAaPvxJBd2UNij6J2qA5frygiQVmD3M6YSiOBFK9Eo5AItu2sj0O95flzyaWcuhvxJz5SvTKdYBG3ob5O6oBLKB3Bwm216/7KZcM0eCYhVKNKPHOzz0604=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e/zlx72T; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e/zlx72T"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 95CA66017D;
	Tue,  9 Jun 2026 00:39:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780958371;
	bh=JK1bd7LvraTNFT4vJa+JYC9LaSx8/4N0x/mO2QrqYkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e/zlx72Tvq4BYNFBexcJ2DstWTQjL11q61Ft8ozJIrbs02Ws76UpVmIhArFAJcfeE
	 DJo/Iw8qqTNEqwIT5vxnC2swIncTF1foDP1T/++fQNcB5ZslYhj+Xrjqcw0udo4N/M
	 bob6cGRmjCH+zYiYUSj5JKxzSlt/gs6j4VdFOc19p1Fx7vy+AVlb+ZAjQcyLC0hRRE
	 RO5K3Te5GcP4CkDjDn0xfTk2qncmhjYtrzOxx/jUw6dkeFG+rh14qTy+O2qEQp8NOa
	 kzu8FZrgMmBws9wK0waI6S9inPv7MzrJIv39nRwm+pQd+4Hd4wx4bitXVKtchla2DM
	 hT+Xjw7KwZ3ww==
Date: Tue, 9 Jun 2026 00:39:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <aidEoZt4bt085hss@chamomile>
References: <20260607094954.48892-1-pablo@netfilter.org>
 <aiaubSEfDp_JQk_p@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aiaubSEfDp_JQk_p@chamomile>

Hi,

On Mon, Jun 08, 2026 at 01:58:40PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> I'm replying to Sashiko.dev comments here:
> 
> * [PATCH net-next 06/15] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
> 
> Refers to pre-existing issue. I think this comment is not correct?

Yes, it is, inet_proto_csum_replace4() needs an even offset to the
16-bit word. Checksum will be corrupted, but at least the alignment
issue is addressed, which leaves things better than before. Maybe
it is worth to add a note to this patch.

I can post a v2 of this PR to refine the few things that make sense at
this stage.
