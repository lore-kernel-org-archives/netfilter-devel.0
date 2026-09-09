Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE475505C5;
	Wed,  9 Sep 2026 12:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956078; cv=none; b=evu3T1CdTVFI4KyMq1Y3oe0J+ciKPN6S/Bw4SplGv/LkTZOryP8kZTB8hGL03bESZl1W6nhYD+J+NLrze0ZacnSCFDLVCrNx1szOzkNcHVtrpuvb6qOwtAMH1u6BQQsZ2Imfb/o3BQ9CBc7BWDUw57vS2dpSCrDAgCOai5o+3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956078; c=relaxed/simple;
	bh=9JbpEc8760nrzDpDDVu42GQ8PqBtNex86gHXndZb21I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbr1eDH7Sdh6gtjjaL6nGht80ZypvuGcuT8k19S2R6BVUa8Ezm01yfT2JGN6vvjq7N1dUI4egROVuZXrd6nKjMccDUlg4YmCFK35A9SWq9vk/NnlCH+6mlJr/XSzt6GSbHwvzQ7hbWMVam37+CQfcID0neUEY73EvhHD6+J+8x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8403460405; Wed, 09 Sep 2026 14:14:21 +0200 (CEST)
Date: Wed, 9 Sep 2026 14:14:20 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: elb12345@hotmail.co.uk, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kuba@kernel.org, rc@rexion.ai
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
Message-ID: <aqFNnGrfB65odAFn@strlen.de>
References: <178894676277.219967.1844924383954861310@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178894676277.219967.1844924383954861310@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
> 
> - [High] net/netfilter/nf_conntrack_amanda.c:amanda_help() — the new
>   range check closes only the htons() truncation window for numbers that…

There is queued patch in the backlog that added a unified port parser
for use by all helpers:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260503083220.630655-2-rc@rexion.ai/

I think it would be good if the author of that series would rebase and
resend a new version.
