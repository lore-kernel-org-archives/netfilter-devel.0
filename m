Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A2D170A18;
	Tue, 13 Aug 2024 10:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545634; cv=none; b=ml8yEDx8RmrUz5T+MIDsedfvnp38vnjhAwcU07M7QVqTSZKdXIAQKuMqYCujaivdDc3i5IRAy10PvJzZ5U9kQUnD42CmH9rcCKEJla6PikUbscH2/F5adwZxnz9JjG2UyOXe/2/55IA/Mr2q9Ud6l5JWqwLE4zOGt+uhOvFKOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545634; c=relaxed/simple;
	bh=b1en7/XveLuXRGpb6HwF8A/2H+1LvNvVfLKvzo+osBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a6DRiAalsV6SPMH0+gWqEL7N2Ym3wHaKBu40R5b7G1UccoTW1D358p/pXg0EGpQ8QJfOo+ZiB8Idn0MFfPKqVsQK2m7j8NXxgxqlmcCsSgQ/JoLY28jwo5kV9vrrvsS9wLGR0PF0BvNRX/rh1a0aX1iSYWUJ3hQnAuJPw1zEwNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y7B8B9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y7B8B9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1D0C4AF09;
	Tue, 13 Aug 2024 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723545633;
	bh=b1en7/XveLuXRGpb6HwF8A/2H+1LvNvVfLKvzo+osBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2Y7B8B9rJNQBZBD1I+uFKh/A1FRD0pWEXBnKaAiNlTomd3z6BMEKwIBfGYM6ZzZ0j
	 iBGFStiHRRJ3XnjZGTRtv/TYjSQtYe7anlD2Nl9IHLHR7POsaUN/9LajmdFiuiwIlK
	 +E2pOjr66q/ULQYV+ebH+1mo/dnP6zbPmDjBG27I=
Date: Tue, 13 Aug 2024 12:40:30 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.15.x 0/5] Netfilter fixes for -stable
Message-ID: <2024081320-thank-generic-05a4@gregkh>
References: <20240812102446.369777-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812102446.369777-1-pablo@netfilter.org>

On Mon, Aug 12, 2024 at 12:24:41PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 5.15.x.
> 
> The following list shows the backported patches, I am using original commit
> IDs for reference:
> 
> 1) b53c11664250 ("netfilter: nf_tables: set element extended ACK reporting support")
> 
>    This improves error reporting when adding more than one single element to set,
>    it is not specifically fixing up a crash.
> 
> 2) 7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set element timeout")
> 
> 3) 3c13725f43dc ("netfilter: nf_tables: bail out if stateful expression provides no .clone")
> 
> 4) fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")
> 
> 5) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")
> 
> Please, apply,
> Thanks

All now queued up, thanks.

greg k-h
