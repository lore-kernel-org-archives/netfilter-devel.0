Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4089C1474AF;
	Mon,  8 Apr 2024 21:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712611410; cv=none; b=nkW/YodG2u8a8SYx9gFHz1ZSqRWLSPEpRYngMeY3H9TJ+6NAVmoQToREl7yneu5/vUBi6UZhgDx7DexfjGxnUmmKt30xip5IE4rbBwx5KuS29/B/GFwBDnLC5Gkj80bX3rNtMXJED2FedLGIyPtUjk3ob/q3NzKMwainWj0f6jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712611410; c=relaxed/simple;
	bh=OzlEQ0/BCiGtWj2oEcDZzZlHF+f/MV9Cu5k4PrQiQfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wv+v3fiPuEffSfsK3AL/PwwGf7PEBjfnIU/2PY6XySg0Q0bjVepENrQGoahq0I1ZZymbSc8EbKgFmcyh71cMjHbeGH3hh/wNR/b3Spqq08zpwyyU9YcS9vEBoo6wp821OPnt/T0ePc0VqEHVZ975kLOdUU+MCeBSlksxVcg8cE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 8 Apr 2024 23:23:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, sashal@kernel.org
Subject: Re: [PATCH -stable,5.10.x 0/3] Netfilter fixes for -stable
Message-ID: <ZhRgTdwFtFwBSIsB@calendula>
References: <20240408212042.312221-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240408212042.312221-1-pablo@netfilter.org>

On Mon, Apr 08, 2024 at 11:20:37PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 5.10.x,
> to add them on top of your enqueued patches:
> 
> 994209ddf4f4 ("netfilter: nf_tables: reject new basechain after table flag update")
> 24cea9677025 ("netfilter: nf_tables: flush pending destroy work before exit_net release")
> a45e6889575c ("netfilter: nf_tables: release batch on table validation from abort path")
> 0d459e2ffb54 ("netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path")
> 1bc83a019bbe ("netfilter: nf_tables: discard table flag update with pending basechain deletion")

Side note: this batch indeed contains 5 patches, subject should be:

        [PATCH -stable,5.10.x 0/5] Netfilter fixes for -stable

I can resend if needed.

> Please, apply, thanks.
> 
> Pablo Neira Ayuso (5):
>   netfilter: nf_tables: reject new basechain after table flag update
>   netfilter: nf_tables: flush pending destroy work before exit_net release
>   netfilter: nf_tables: release batch on table validation from abort path
>   netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
>   netfilter: nf_tables: discard table flag update with pending basechain deletion
> 
>  net/netfilter/nf_tables_api.c | 51 ++++++++++++++++++++++++++++-------
>  1 file changed, 41 insertions(+), 10 deletions(-)
> 
> -- 
> 2.30.2
> 
> 
