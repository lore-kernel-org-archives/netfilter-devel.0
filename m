Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74D171E51;
	Wed, 10 Apr 2024 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712764698; cv=none; b=iCZm8nU9obsKg2pZrkuIXgM/IhtAETQh8w10wqmNoZCz0M5jCEetCuLfVynqJjur1B5UQCv6xiNnTPqtcOw7QbubrNcTOc59a1vMw/mBgYHiO1QiTBCUUUG2uYiQURPwRPeeLihj18pZ6KUs5UATamtQRj3eJy9+SMwZ05+ekfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712764698; c=relaxed/simple;
	bh=IjcjpbthsKgPlNjxPYeb8mBABFto9/2+SHuSGx7ljbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuQad6Z5uFSaFkjETaAEBpq5KKff7dH+tsg4bf8f9IRLzevdjKtgl9sCPrPLIZiT85muqWvuuAYB3h1qgWykshae4O1svVmYc9Sk3oFe+ihsjZvoupjQYqhJrn+tZ2d+d63TRFn1/+qIl+Xk6cxwYFWRNKF+hUHmnhHiNOkGl7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W857UGwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W857UGwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18233C433C7;
	Wed, 10 Apr 2024 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712764698;
	bh=IjcjpbthsKgPlNjxPYeb8mBABFto9/2+SHuSGx7ljbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W857UGwTGxtK5mtdjPyRZRlZL+6hIRLNzqeEH7uQ0nm/FI6pKYJRrkrMrIQA6v00n
	 oJa/6AHVViAlCrYmI+PN0/u51GlXJ1SfIHk4mPmMNTgelUMXn32cgJawyUwc6DJKs3
	 okKKhqE3TgjsOkXkoGWArJsY01k4q2qoATup8RiB4tpy09WjnRj3c+I//32WYoXCaR
	 mFX8v/8Ccgz7u7aXVREI4UWCFIvd0UQEhvK++C22PxPhCzZgIniMueAV7+8/fklbEP
	 3FBYt6ByLxQWpE0jhUDOTrG+J/TEegksc/siGcUQ5nrGWXGUZe4fpiyeRIZseutcfx
	 FNpy9AGxGfzWw==
Date: Wed, 10 Apr 2024 11:58:17 -0400
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH -stable 6.1.x 0/3] Netfilter fixes for -stable
Message-ID: <Zha3GXjK5y-83Qze@sashalap>
References: <20240408211834.311982-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240408211834.311982-1-pablo@netfilter.org>

On Mon, Apr 08, 2024 at 11:18:31PM +0200, Pablo Neira Ayuso wrote:
>Hi Greg, Sasha,
>
>This batch contains a backport for recent fixes already upstream for 6.1.x,
>to add them on top of enqueued patches:
>
>a45e6889575c ("netfilter: nf_tables: release batch on table validation from abort path")
>0d459e2ffb54 ("netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path")
>1bc83a019bbe ("netfilter: nf_tables: discard table flag update with pending basechain deletion")
>
>Please, apply, thanks.

Queued up (this and for other trees), thanks!

-- 
Thanks,
Sasha
