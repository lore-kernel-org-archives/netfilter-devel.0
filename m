Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF4B170A18;
	Tue, 13 Aug 2024 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545706; cv=none; b=mcnBGzfnJMyqF85ziCsKGpB1TArDVO+sdhGP2Ct1EtZhH9N64OfzkSYRhViGrLXGiakswy+hwDvp9cJkB9kj8m0LFwh0LbgMVaFWweFPeX87Imrwnx5toc0BK7Yx0xRjQ8Jknm5FErxy2M1WnWQY9lcSIUleYAehUJUXlJD2eD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545706; c=relaxed/simple;
	bh=TYgnbaemO2O0KaRi7vxLBV3YJwNKxbih0WlB5ndVKGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YX+D3bbCo3Hn6GOCgMxOfznSKiWHPpmiavZIbHhA0L1MIDhWp0mgSqTwb4yOSnq7H20r96RFnxomPBUxWXB+VUkOz1Cxz+XxFhRXFFt+U6sLrQqfqj6xfYAldRCVw89aRmUu/Ol9YSQJzjCY4dFS5RqJ280Y5aWc9A7xIohGy9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOu+rr3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOu+rr3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F56EC4AF0B;
	Tue, 13 Aug 2024 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723545705;
	bh=TYgnbaemO2O0KaRi7vxLBV3YJwNKxbih0WlB5ndVKGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gOu+rr3upM8+6LJDfPN1oBlawsTOPtJfqZ+dnB01wer9ofAd6TfpaI+vJX+wVhSrP
	 nAS3p3NEMRdyo6SQAcmx530uNibcm6fL75RlyVxw3Bi6TDQmqMK/S9GTYMRxBmR7nD
	 MwoajDm3oa4Y+29qqMrIaCJtuiMYsvOGC2BZk1nE=
Date: Tue, 13 Aug 2024 12:41:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.10.x 0/4] Netfilter fixes for -stable
Message-ID: <2024081333-factor-surprise-b366@gregkh>
References: <20240812102742.388214-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812102742.388214-1-pablo@netfilter.org>

On Mon, Aug 12, 2024 at 12:27:38PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 5.10.x.
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
> 3) fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")
> 
> 4) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")
> 
> Please, apply,
> Thanks

Now queued up, thanks.

greg k-h
