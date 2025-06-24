Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE32288C03;
	Tue, 24 Jun 2025 11:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750762860; cv=none; b=lhNcaew76O7zkZSogZTnB/Zfwez0aD0VUDFJ7jfFVwWKIjPZs22apgln/merzcWE4CS575Btx65wo/WAxNpR8cDER/WjG1BmFxsNOCwSmmurheB//ijQ6WVV9fCV+U96uAji7oSUKpWJJo2X1b8pANPdstYl9aSppMjDl93zwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750762860; c=relaxed/simple;
	bh=Ju8pVGQLrQqy8Z6AtRq2leg3alQFLxuYAyioS6VkTgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQqdpPz4k51q7zXRJTQiWEhHC9z9HOlHjfdMhN6I+Lfgi2KXMVj4XZpzjmWMQeA8YP+qOsfhVIMhR8LNium3ZwpldTLO6rfbgSHjDyKXg/kWx7b9hrFu+WbjD9oPWIzAzb6v0WlQ2xxo+52vjrebViUDpy8elEXfyg/CQzL9LRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJRvvKb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJRvvKb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48491C4CEEE;
	Tue, 24 Jun 2025 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750762859;
	bh=Ju8pVGQLrQqy8Z6AtRq2leg3alQFLxuYAyioS6VkTgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJRvvKb5VqglVQUOWwPNTgvy+KGRrxudy4kSKbwgxLGSDocnZ7Gj7YLW2GkF6SWzA
	 C+3edGQGJK3MNg2OBF3KzzrM7S7C5t5eG5ioHkHHg7G920u/iDOf8f8EnpcY3Q1Mp3
	 /xUDcamBz0IMasJ0Ol0q+HqK3mPiZRRV/j3kgs5fn+q9aZ3OXvI6HO1ZwLcslAySCy
	 kqXrBrnB3NFPP/b4NGaifjrCnDapJJYrCqrVBbIqBlzIboRsyvIM9T24v7R1oOgNsr
	 ocb6SyNT4XlstP7iMESwDxOAmvcNiN78p/v5IOixVjyefH/QXLVDLtpJX/7TEcNzZe
	 DuBfVqoy4UgIA==
Date: Tue, 24 Jun 2025 12:00:55 +0100
From: Simon Horman <horms@kernel.org>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_tables: Remove unused
 nft_reduce_is_readonly()
Message-ID: <20250624110055.GH8266@horms.kernel.org>
References: <20250624014818.3708922-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624014818.3708922-1-yuehaibing@huawei.com>

On Tue, Jun 24, 2025 at 09:48:18AM +0800, Yue Haibing wrote:
> Since commit 9e539c5b6d9c ("netfilter: nf_tables: disable expression
> reduction infra") this is unused.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <horms@kernel.org>
