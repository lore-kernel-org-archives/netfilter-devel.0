Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAC419B589;
	Tue, 13 Aug 2024 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545860; cv=none; b=DGAEbMdRRkzDnY/wYA8Ngc+nnv5qxzbTdYYGfJD30enh6P/toWXoRsTT9On+Sd1LRwFyz8IwZxfWU26NdvcYyfLYO6wCXrpq6thyogp/2hwTmrQreEe0UDgCPD38HMdkS2V+x+1QKfjdcwhQtzDrX01YwE1/8ygqs/9pM1yfLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545860; c=relaxed/simple;
	bh=y+siaIvmE7cpofe8TFpPKN00mxWqNzAe8QsJ7RJ4Dag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sriVxBI9WEtqHNm47us7NJCP/AuJXAASbC4eQEd4UzeWyNiYtg1DYMg6beaB6ZtNAT0mpEDBkvmqCo1+n/zI64LICsJU82pT/HKV3H/2W20gXYaE2s0wrqbJ4zw3Bh1oSklxYRX1sA5UGlqMdUEKR2TRwA1Z91fBx4dp+d6A8KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rZF9sV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rZF9sV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5074C4AF09;
	Tue, 13 Aug 2024 10:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723545859;
	bh=y+siaIvmE7cpofe8TFpPKN00mxWqNzAe8QsJ7RJ4Dag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2rZF9sV2lLZfunGbvxtZ/kk3QuIA94jTmQAr/33k5uxqlPIFDmcTdpY+meKsd/Z9p
	 E3Xw8sAoq5Wv08qkP2QfTm0dPWdAoKUyzoVW+3BYoA99sfKhfpaqQV7btJ/okA2MOL
	 gMIE348K+ptmAPFJ86PAXxyM7tNwXHKqKJcp/x98=
Date: Tue, 13 Aug 2024 12:44:16 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,4.19.x 0/3] Netfilter fixes for -stable
Message-ID: <2024081306-oozy-open-a7ea@gregkh>
References: <20240812102925.394733-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812102925.394733-1-pablo@netfilter.org>

On Mon, Aug 12, 2024 at 12:29:22PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 4.19.x.
> 
> The following list shows the backported patches, I am using original commit
> IDs for reference:
> 
> 1) b53c11664250 ("netfilter: nf_tables: set element extended ACK reporting support")
> 
> 2) 7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set element timeout")
> 
> 3) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")
> 
> Please, apply,
> Thanks

Now queued up, thanks.

greg k-h
