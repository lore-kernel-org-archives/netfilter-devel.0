Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20A53603D5;
	Wed,  5 Aug 2026 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785950439; cv=none; b=hpcOvFGpHJj+JunFhmcYBd4Ndz0mDPsTzxsIHf93fS3mUb/O0hJvxo2fFc/WUnH5eg/baI8RXRHNOi/b/bUjg13quvEfsRHAbfF9SvFAsbVR7mBDDICPHOVHp0zY7sPjx63g+GX51WDYcsLfB7sm3IFY2hz5pahwFwT3RVy4UuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785950439; c=relaxed/simple;
	bh=PP9hhDek3h+Rr9ee/vFRxD3cH5poqgkbr10s3HY8dOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G166ziuDnMTWPeWU3G5DWpH/3vD76LbDKZNPoUtE+YA61QQ/h+bM/h61MdBmHiD6VQxDS1HI3VAoTBPYQ+hqV8zsVGoeQpcM7rSZedFa7Jgkm080hPeQ7R4VHVqLL02x+6wRAaiqLbWdpIcBeqQ9Z0Ibo3og85JYsDdjo2GlS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pPveyYMd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pPveyYMd"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 31992601A5;
	Wed,  5 Aug 2026 19:20:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785950436;
	bh=wWHabixD7HuEg8x/uwGeoTvTPK6AdXYQvv7RSIfSwkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pPveyYMdIJh/Ad3fPPQ7Kg2q45dXoEQfi50OrYamxHfOBxCy0lXTQRKjU+X6xAZ1r
	 UhOupoKRszsEefr2gzPnLYMYM6I8RZhRDIgLrIB8sVrWqatoM4VKEK+j7oBFh8njuR
	 UnlhSRhv+vLzKxxEfoqe9GQur/hcrwZHG5qQyB/FuCevt7CqF9tbJFN5K7alvU7t9v
	 9UkPW7Xcck6ZwDUFLFJhW0Iub6ehp7OYTltGarXJhMvRR+nTcAwrpyvXOxKa9qS6+w
	 xg0NbzDe/nDH93dD8uAnuiLGAR0UZEX7LZQMmVQ4egeRJGeGlwxNoeSg2K8noUgUvb
	 XS0rmR/spPzHA==
Date: Wed, 5 Aug 2026 19:20:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 08/10] ipvs: avoid out-of-bounds write in
 ip_vs_nat_icmp
Message-ID: <anNw4WG2wUiuatg5@chamomile>
References: <20260731151806.849724-9-pablo@netfilter.org>
 <20260805001534.3978877-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260805001534.3978877-1-kuba@kernel.org>

Hi Jakub,

On Tue, Aug 04, 2026 at 05:15:34PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
> 
> This passes the already-parsed ip_vs_iphdr down into ip_vs_nat_icmp() so
> the embedded transport header offset comes from ciph->len instead of a
> second read of the inner IPv4 ihl field.  The IPv4 header sanity checks in
> ip_vs_out_icmp() and ip_vs_in_icmp() are also reworked to read ihl only
> once.
> 
> Link: https://sashiko.dev/#/patchset/20260722101517.36313-1-ja%40ssi.bg

Julian (he's on Cc) is ready to follow to address the remaining
comments mentioned here.
