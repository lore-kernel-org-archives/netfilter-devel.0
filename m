Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8929338F40;
	Wed, 27 Aug 2025 12:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756298467; cv=none; b=GhMKz8Z+WQxlL0/o2Nlf0+ZW7NI+4MSc20Rc9+lMp+6Mg9jgtNBvzpULhdkX6OCCJaq/Bdg+EliPnVfUSJM2UcZSfSWZcIb/twIvVXdiiEL/xzpGC/I508oepFZo+ThS0yEDzHxsVkwM79iyn8F8KhLTR4xOZUzFUAi9/Sc+Gf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756298467; c=relaxed/simple;
	bh=TBOKimkYBrWRANWVXSzialdhAF23NQgsZPqia2U1uho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJmYrrDm6mhmEnwYgS+ar9SirMYqbnMHGSR/liYmTQnhGSAewaamINk4/VwwS/UXLSNS8z6MD7Outk/FAZ5R/Ugp1UT7DBkAd+jCJCGq9V8bni0LHkbyID+FDf50fjfcPVf8F0OgeN8h6BGhmtkf6vvW50xKgXyJoqjAN+vAQmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gp8ZV72t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gp8ZV72t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45EFC4CEF4;
	Wed, 27 Aug 2025 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756298467;
	bh=TBOKimkYBrWRANWVXSzialdhAF23NQgsZPqia2U1uho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gp8ZV72tw7m7md3nL656aXoQe7xkXivQkIo/uklVVlIjFl9lk+qoMrKAy5GaF8BIK
	 Y5DBKWtkw5PdIYG4pZc++i9bPl1W2bAjPkG+1ndDVA3Z+eyA9ahxpNwKW0TkAeA9zO
	 OUAO7GPVWqz3jOuMg4gjAK8AaoZFlSWIMI6HmzvkqGgHAMBhIjYwNhvQdrj6u4hauW
	 SXCoj1JfViAT8F7MPPA/szaZQUfp7nYkZmIQo2CTwK0YF/qRjCSebgIxB+lVkpCm3E
	 +vWh9WKZWOpEDC/UH/ILaBn5ORGWYHWk3cuN4rTO8KEu+bsEALtaQvsqFIGeZk42NQ
	 UEAsTj96QiMoQ==
Date: Wed, 27 Aug 2025 13:41:02 +0100
From: Simon Horman <horms@kernel.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] netfilter: nft_payload: Use csum_replace4()
 instead of opencoding
Message-ID: <20250827124102.GB1063@horms.kernel.org>
References: <e35d9dca6ce3a67b5a0fb067e02b35f3f53ce561.1755510324.git.christophe.leroy@csgroup.eu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e35d9dca6ce3a67b5a0fb067e02b35f3f53ce561.1755510324.git.christophe.leroy@csgroup.eu>

On Mon, Aug 18, 2025 at 11:48:30AM +0200, Christophe Leroy wrote:
> Open coded calculation can be avoided and replaced by the
> equivalent csum_replace4() in nft_csum_replace().
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Reviewed-by: Simon Horman <horms@kernel.org>

