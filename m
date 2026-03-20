Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50EF3A3E9D
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005383; cv=none; b=rayUBgtZAXqPpCCPGxa5i8Y17JblN9cpPdeClhUaGmeq7o3UdkTvqdkWsnfOtEnjNZyeq5rDHvitCsjeIITYtnTn6aBTMv9H0zpXbcUa2FnH1krnGbgwBt6k0SkzFHIsvIj053jNNOVmPi66GztDeQL2ycjtcR5vVuTk4qkb+OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005383; c=relaxed/simple;
	bh=TmllLTqI2VD8BtCK9jHG4YjgJtOIxVps/2Tn6BMKWhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6/bH8GhfSX3xQphLYADPfCvbDBgjNYSMrI9pEwhjn9AWYDrRei+88Cl6BC/yQUXKLFVdvDcu4a/5ko6LakDtIepc7bhpZAZBpzUwOwaPB61vXD6EIbn3EL3fJr63OEM2zru7VHGlLzGQQotTdOmIs+b7044bqUmrB3MbP/cal4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5378B6079C; Fri, 20 Mar 2026 12:16:17 +0100 (CET)
Date: Fri, 20 Mar 2026 12:16:17 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Daniel Winship <danw@redhat.com>
Subject: Re: [nft PATCH] segtree: Fix for variable-sized object may not be
 initialized
Message-ID: <ab0sc0AmGcDZjnHh@strlen.de>
References: <20260319133208.19823-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319133208.19823-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Seen with gcc-11.5.0 on an aarch64 machine, build failed. Looking at the
> code, r1len (or r1->len, actually) really seems variable. So use
> memset() and fix build for that older compiler version at least.

Thanks for fixing this.

Acked-by: Florian Westphal <fw@strlen.de>
