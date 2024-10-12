Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB0019308A
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728742188; cv=none; b=gBEUDUYQsxuUbcfiwsjZ8SmA3C3ckKGQpjqtd6cXR0PDW+6CU1uP+ke9FBssHW6HPwklso9Io23KNGZS8AWDi5JI10EM+lPvVTaERWwKl9ljQwoiZT7FDHTjNWGs6LtVzCUT3UrlnGD24Y9Tzxm2IhyiuQZiWNgMDL/SXsL2Atk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728742188; c=relaxed/simple;
	bh=gEH0I5Dx9bBfS6vNbmnieXx+0gt8fjxm/bIH/g3e8MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgQq3Wo1amy8ptuFcfl6tOSLA+OZiyUjS1MzOpgc5f7N8sTVdhtXAwdEIwQh6k3RboYsyLmUn0AZ4xHBL+mbM+fw3OOXtjdcWD03EZV9e4P4l7PI8tBqY/jLYRQvbXaaWKtGbxupEqO89e6JD+MEgurW54GBkjAVlN7CngFcA/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53914 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szcoO-001KHR-Eu; Sat, 12 Oct 2024 16:09:42 +0200
Date: Sat, 12 Oct 2024 16:09:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Message-ID: <ZwqDI5JcQi5fMa46@calendula>
References: <20241002155550.15016-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241002155550.15016-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Wed, Oct 02, 2024 at 05:55:38PM +0200, Florian Westphal wrote:
> Provide more precise drop information rather than doing the freeing
> from core.c:nf_hook_slow().
> 
> First patch is a small preparation patch, rest coverts NF_DROP
> locations of NF_DROP_REASON().

One question regarding this series.

Most spots still rely on EPERM which is the default reason for
NF_DROP.

I wonder if it is worth updating all these spots to use NF_DROP_REASON
with EPERM. I think patchset becomes smaller if it is only used to
provide a better reason than EPERM.

Thanks.
