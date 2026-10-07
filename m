Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A6F26B742;
	Wed,  7 Oct 2026 22:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791413881; cv=none; b=OK9I8FP7s1GMsjCPEXtxsMFlQjvyQCGdWb6+G7XQm2vs3jnndnbOvrSCGg9+mluUd8Ce22J426bhuO8qVp2i9nLbliieC6ITZ6Kj8oLv29bKRENWvMyhgJptSi+5tTCR+sNbOd1iBwATdmcfpsza/+dUJlbSWEA+4Gk439qh8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791413881; c=relaxed/simple;
	bh=8pbsa1UWQxpTLQcNNtAraCqKkjuiKPHk/HGNM8H8EkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Px5vcDnR9NKdzqAOmbTDfNi1AHatIlSzuu+wU3rymCkE6i76Ti5nZemf2RxwNj6Hpwqq2WAAt1Pr9fx5cqMuzus49Niq8BkvVqnmLYy4MLkaUJxFLfClehTQrKQjq82DAsrTMV6ELBJRdw/9Eqx1zZ+vUIr2hMYJbTFpQheNcfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eHuyKtVR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eHuyKtVR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791413878;
	bh=8pbsa1UWQxpTLQcNNtAraCqKkjuiKPHk/HGNM8H8EkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eHuyKtVR+NT5eNnvI18WC+CVrciP7/PyhwjK2NwVhJWEHLmtEppHygiuyjs7QIODZ
	 bczu8rHKmvlWi3LbBCC42TUchczEkxlhkyye+AXBxlbxRMmi41v5jjh9VKxmsnnLzH
	 WypuU5mdW0Zi95pQqLYh4p0R/Oo+zQps1MNyCnBDp4iAVoq0ICDgo6It0oX4YPj1oS
	 MQIfcWVQwS7DGOxK+yofccGed3ZoKDSE9bJaPD8N58P/b9vfu0HecCyn3F+N/7lyK7
	 rywVlFsQ0Nb2tfHa4ZRTGxhbF2ZsrpWRHEIBY5DOcpIex5HitRKXdSkl/JnZvrLjjh
	 YKl2PyFWX0/AQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D7E5060077;
	Thu,  8 Oct 2026 00:57:57 +0200 (CEST)
Date: Thu, 8 Oct 2026 00:57:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: tjdqudcks0424@naver.com
Cc: netdev-bot+sashiko@kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de, phil@nwl.cc, netdev@vger.kernel.org,
	stable@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] netfilter: nf_conntrack_reasm: avoid truncating
 header offset
Message-ID: <asbOclh-IMDXtFTO@chamomile>
References: <20260929090027.200041-1-tjdqudcks0424@naver.com>
 <179089937913.434549.5874493628033954656@kernel.org>
 <20261002074210.140795-1-tjdqudcks0424@naver.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261002074210.140795-1-tjdqudcks0424@naver.com>

Hi,

On Fri, Oct 02, 2026 at 04:42:10PM +0900, tjdqudcks0424@naver.com wrote:
[...]
> Would you prefer this check to be folded into the existing prev_nhoff
> patch, or should I submit it as a separate follow-up patch on top of
> that change? I have the reproducer, serial logs, A/B results, and an
> applyable follow-up patch ready.

Please, send a single patch to address these truncation issues.

Thanks.
