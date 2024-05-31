Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714E215664C;
	Fri, 31 May 2024 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717172055; cv=none; b=gHc0ECaDEzkBi+IZ89lh1yTWdj9rsngxNttOuenL9sJZ1a0PILJBbBgYH79NtNKDpon3buE5SO5yRpdW5ySrFyVFq7mO+mrirkFIKTxkVPAAgHztv7jhuzs9826l58wBLRWCDfgbD2iudzQoor2Ps15il7WJD6b3hyjVyrLBmok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717172055; c=relaxed/simple;
	bh=eV0g9Ph7jJLsyZUcpm94JqOOAYt/kXhHzqUmzlnrmAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omW4K6OOI4lP4sBAMQAMvoIalPQUEZe69LNZ7MVlGFXaBu4YZfR4bSvnm6Ia5DV6zta31uXA1AdPdmRmOdqB3c15/bMfMx4Qdlqu5ygFFVBUVnTbZVCo3O9Gy9Wux8YcAKxl9aZSc1jcISzdnqC56MzQ/oYDXAaUXx6pwJ0VDZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7AxhjmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7AxhjmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F5FC116B1;
	Fri, 31 May 2024 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717172055;
	bh=eV0g9Ph7jJLsyZUcpm94JqOOAYt/kXhHzqUmzlnrmAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u7AxhjmV99/1FjY6xv/+wmGIh/pR2TUra3c9K+SYUBPyvWpqGuMNGOd5m1/8ah011
	 N+2HZ1cqn0EW7d6vBRQ1h5gRr/WJMeYw876OSeYzn9lJtLFXtlrX6/qmE0cA7Wr+ko
	 FWNEgEutkRudMb2snFtXHrrBjHJY/S/BIaXNCN+Mpc6IJoUOflNwPIWvcYXYq7uGYd
	 /OzY4FTDUkduy0fmnZvv//lZP9jLurjAQFVb0cbCk79woPb/4xaGTDwpQHl0Wmyd4P
	 Iw40VvzN9ZEYGkzwyLcazLqN8OPPZ23wDoM/PEOokmfP7/UeCwQ5p3b5tbnBEGay2a
	 Wb3ERVcnAF4RA==
Date: Fri, 31 May 2024 17:14:10 +0100
From: Simon Horman <horms@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1] netfilter: nfnetlink: convert kfree_skb to
 consume_skb
Message-ID: <20240531161410.GC491852@kernel.org>
References: <20240528103754.98985-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528103754.98985-1-donald.hunter@gmail.com>

On Tue, May 28, 2024 at 11:37:54AM +0100, Donald Hunter wrote:
> Use consume_skb in the batch code path to avoid generating spurious
> NOT_SPECIFIED skb drop reasons.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>

Hi Donald,

I do wonder if this is the correct approach. I'm happy to stand corrected,
but my understanding is that consume_skb() is for situations where the skb
is no longer needed for reasons other than errors. But some of these
call-sites do appear to be error paths of sorts.

...
