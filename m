Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419F44C98;
	Wed,  4 Jun 2025 23:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749080107; cv=none; b=N3GpHGBNnOd1XpMW/OLznXJPsfBo+1GwQngtSa+gN7wIHks5nnDqAvnZ7mE341XwKrecLwdmmDhHWRi5tFRKYH7rvCBBXnFQLZ2/lJFXqc1gdIyB8kiMs0pXScxjxGq7WXgSNgxAtbLW3VBFtWTba/yilYwze6MHtZey4uppUNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749080107; c=relaxed/simple;
	bh=4VAUKMybIKMKGek7WEFClUf0cJy93EVetNi+YJ8e0EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpWDUAIFmEILmzUuRSh4tjVeB6jGIChqfSqVpQxUcrDNg5pPEvg+FtKoHhDtzNQuwTRVqNleY6gAR0QDu9XlopQUNj7v0TyHOcyRRmQ2bRkPvMxQ0k2MWsq29MBOPCtSjUEk83bLfFmjk020ZoHT5Sqm5P6P3YabAjfl7MNlnAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AlUNwDlh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AlUNwDlh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AlUNwDlh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AlUNwDlh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A81D86074E; Thu,  5 Jun 2025 01:35:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749080104;
	bh=cgYt1SfH/hz8If7AHMwB8tOLhN2d3CZoWCY+F2J1E5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlUNwDlhoYMUR2fy7yWSGrvfOImzFVpecgurD3ns3UCmDiOVIIDclZvgC+1BDue9m
	 EBE5P4KcecZ1pwnZ/gXL9GoaVaYKRn2tmg10LLKT3pHmY8uqR5OZFAuiGJnBNnGYMz
	 aOVMrmwM6GFUjhNReNMkA83xIe842CfjwKHFUMtajpSEprku8lbkM+rYraJurBjwTZ
	 6s7VmU2SpLrn6UpmoC5anLnXu9yXEHEc0ernJoVGNsS+R/8jRPnhVpM5W+tpSsgVKs
	 GIz+9IS+uqfEGY6WC5xdiAWkpMWKnSN8551blztGokOR2i3u3ccYrYJ9iLevD+nux9
	 s+02WVvbf6k0w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2ACA460749;
	Thu,  5 Jun 2025 01:35:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749080104;
	bh=cgYt1SfH/hz8If7AHMwB8tOLhN2d3CZoWCY+F2J1E5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlUNwDlhoYMUR2fy7yWSGrvfOImzFVpecgurD3ns3UCmDiOVIIDclZvgC+1BDue9m
	 EBE5P4KcecZ1pwnZ/gXL9GoaVaYKRn2tmg10LLKT3pHmY8uqR5OZFAuiGJnBNnGYMz
	 aOVMrmwM6GFUjhNReNMkA83xIe842CfjwKHFUMtajpSEprku8lbkM+rYraJurBjwTZ
	 6s7VmU2SpLrn6UpmoC5anLnXu9yXEHEc0ernJoVGNsS+R/8jRPnhVpM5W+tpSsgVKs
	 GIz+9IS+uqfEGY6WC5xdiAWkpMWKnSN8551blztGokOR2i3u3ccYrYJ9iLevD+nux9
	 s+02WVvbf6k0w==
Date: Thu, 5 Jun 2025 01:35:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.4 0/1] Netfilter fix for -stable
Message-ID: <aEDYJC7iOWYTOi8m@calendula>
References: <20250604232817.46601-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250604232817.46601-1-pablo@netfilter.org>

On Thu, Jun 05, 2025 at 01:28:16AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains backported fixes for 6.1 -stable.
> 
> The following list shows the backported patch, I am using original commit
> IDs for reference:
> 
> 1) 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")

Apologies, original commit actually is:

     8b26ff7af8c3 ("netfilter: nft_socket: fix sk refcount leaks")

>    this is to fix a sk memleak.
> 
> Please, apply,
> Thanks.
> 
> Florian Westphal (1):
>   netfilter: nft_socket: fix sk refcount leaks
> 
>  net/netfilter/nft_socket.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> -- 
> 2.30.2
> 
> 
