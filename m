Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1AE7F6;
	Mon, 12 Aug 2024 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723474868; cv=none; b=KNIAPNdsMIKHVQOogCaLQzzynpCEOBEyvjlQv1Jov6rvMf8XmPEvtg+8sI08RpC4Ir5Z9SINxJFdIGrnH4HSZ6KyLCEd6IlQpGaxHU45X+689xF+hioYYWSw00W77zOefiCOtHdZmaghzVz9iOTZC7BQe5fLrhg2yMuUsqaoOH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723474868; c=relaxed/simple;
	bh=jFXwuHnHZvX9TUcpQkYawiiGZfBsAuGXkFiTH1tSLt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/TkoR1dp7FD4CZLdJcWtmsey0bfeoPpSl3gt2I9T1UVm402leE+3Pq1NxO1kqbBdFU5lGU8ELyN+dw6kt48zTh+cdK0YSZr2pzEKzGsMK6wN2QX1ko/ocP10zYeHtC4wgBgUud6hWCmUozoxIzwzULIp58AaEmZvNpbsz1xDV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1JSbnAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1JSbnAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A6BC32782;
	Mon, 12 Aug 2024 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723474868;
	bh=jFXwuHnHZvX9TUcpQkYawiiGZfBsAuGXkFiTH1tSLt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q1JSbnArerenmBslahulEIYEaSli2Gj+u5MsWwpiUiht0iYRtY4IRY0KLCeE7Ye4d
	 YuVeGaXriyYNVXW5gHvUr+LzkuzBWVpXrC2TyuJQtEssvSdjOO1BUS57lJIxqo9deq
	 dJpWOXoFtRaQeoZJrbkiCiDopNNujkrIieYXZjg8=
Date: Mon, 12 Aug 2024 17:01:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.1.x 0/3] Netfilter fixes for -stable
Message-ID: <2024081256-growl-avert-8e3e@gregkh>
References: <20240812102320.359247-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812102320.359247-1-pablo@netfilter.org>

On Mon, Aug 12, 2024 at 12:23:17PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 6.1.x.
> 
> The following list shows the backported patches, I am using original commit
> IDs for reference:
> 
> 1) 3c13725f43dc ("netfilter: nf_tables: bail out if stateful expression provides no .clone")
> 
> 2) fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")
> 
> 3) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")
> 
> Please, apply,
> Thanks
> 
> Florian Westphal (2):
>   netfilter: nf_tables: allow clone callbacks to sleep
>   netfilter: nf_tables: prefer nft_chain_validate
> 
> Pablo Neira Ayuso (1):
>   netfilter: nf_tables: bail out if stateful expression provides no .clone
> 
>  include/net/netfilter/nf_tables.h |   4 +-
>  net/netfilter/nf_tables_api.c     | 172 ++++--------------------------
>  net/netfilter/nft_connlimit.c     |   4 +-
>  net/netfilter/nft_counter.c       |   4 +-
>  net/netfilter/nft_dynset.c        |   2 +-
>  net/netfilter/nft_last.c          |   4 +-
>  net/netfilter/nft_limit.c         |  14 +--
>  net/netfilter/nft_quota.c         |   4 +-
>  8 files changed, 42 insertions(+), 166 deletions(-)
> 
> -- 
> 2.30.2
> 
> 

All now queued up, thanks!

greg k-h
