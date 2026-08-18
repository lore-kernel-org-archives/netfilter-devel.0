Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F030FF2A
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 13:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787058629; cv=none; b=uYpkqa8iG91Wpj2Ap5xSFw4Nq7by8FbxlwXzYFvrF1Mvj3+4n5v0eRNrc4pzDACLoriF4tONsyAO0lgTmPEUePmy7U6LBEcvQ+ZTRsqngTZ/W1b+EmSi9xWWGkHO4WUIB9rMbr6MWU7ptKY+LrUM1PbPpPXuWB6b5MJY77DMoYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787058629; c=relaxed/simple;
	bh=UMvU1k0EH4UhRYKsDZ8CpKgCKxjxDH5Dx9iaa2lrMdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQP8OQRm5t9kuJAqLnc8cZchi/+eBulIVHluqL7T9WDbWFxd/h4sPULBnfU6OW0YZBQXcu4sVqX/RvGeoRTNe4zOnevrmMiitJMmcAGhRddTWYj874h251F+34pSm4sJTMn8tX6YeUfOCvObdKwjMnk7N+6mCw1ro3ux2N4lAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C7F826051B; Tue, 18 Aug 2026 15:10:25 +0200 (CEST)
Date: Tue, 18 Aug 2026 15:10:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fmancera@suse.de
Subject: Re: [PATCH nf-next 1/4] netfilter: x_tables: remove pr_debug in
 matches/targets
Message-ID: <aoRZwcnBcn-a6z75@strlen.de>
References: <20260818122741.1329660-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818122741.1329660-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Remove pr_debug() for these xtables extensions, these have no use these
> days. Still, turn pr_debug() into pr_info_ratelimited() in the .check
> path since this helps provide a hint via dmesg in legacy iptables.

Makes sense, thanks.

Reviewed-by: Florian Westphal <fw@strlen.de>

