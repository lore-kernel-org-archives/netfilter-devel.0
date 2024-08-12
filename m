Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B97174EEB;
	Mon, 12 Aug 2024 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472449; cv=none; b=Yr4zt3e9Ev+2WbmhCnGRlXO9JEKtZJs/1Ds21/jny9R4sZKXpD7hgLLm5tvMVk/gvJxDuPHzmaac2hdYfE+GCIYv9AKSvd9EeyDWx9sMBfvicmMktVjUAnWb8JCPdQ2DNND9O/PxEPebv8JLpn6oId6ei9G8Y4RXULrBO9IL+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472449; c=relaxed/simple;
	bh=1I5YVmdb8Z6Uv3WAQk31KYXQ9KuPWkc9M7SBNqqVF8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWjtLuDKMvhBxmJFZEWFDRW6hrUIy70Dxc1+5z4YpWpRDHNhCDBzl12pEWzYYw7aY+J5ckGf8/hgtyBak19OKREHeQmi/1ouig1LYpxTEnbP9pLBSQ+Vou1sbqVLPctHIVr3Q4qzXrTTfdPblIR4R+6t02IMy2ZlPVY6pb47asU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVzJ8oUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVzJ8oUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB555C32782;
	Mon, 12 Aug 2024 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723472448;
	bh=1I5YVmdb8Z6Uv3WAQk31KYXQ9KuPWkc9M7SBNqqVF8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bVzJ8oUkDg0ibE4YBYyDRUPwwK3zxf6xftkQCLwoSELxliHym0mHQIq05ZgKpQtr5
	 7QPR/BcYcigJxXImyaLNHJ6Qs3dMo+U5X8UpAzMyhtcKfYmrE5VqZ0ZHy4TKV74nia
	 /+Iv4QSxqqdf5Jmz4OX+fAINoq21roUt4b60X7BQ=
Date: Mon, 12 Aug 2024 16:20:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.6.x 0/1] Netfilter fixes for -stable
Message-ID: <2024081240-freeway-tricky-4625@gregkh>
References: <20240812102159.350058-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812102159.350058-1-pablo@netfilter.org>

On Mon, Aug 12, 2024 at 12:21:58PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 6.6.x.
> 
> The following list shows the backported patch, I am using original commit
> IDs for reference:
> 
> 1) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")
> 
> Only one patch for this -stable branch.
> 
> Please, apply,
> Thanks.
> 
> Florian Westphal (1):
>   netfilter: nf_tables: prefer nft_chain_validate
> 
>  net/netfilter/nf_tables_api.c | 154 +++-------------------------------
>  1 file changed, 13 insertions(+), 141 deletions(-)
> 
> -- 
> 2.30.2
> 
> 

Now queued up, thanks.

greg k-h
