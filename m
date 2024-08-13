Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2F3193094;
	Tue, 13 Aug 2024 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545792; cv=none; b=pjgTAmaxVF8ebmtTk9Edo0kShqp4FL6cHWqW1lfeYAPaBEODp96uOUZlebTnofVMAhegrNHzaNeppN0/6vuKGoZWGRAHyY83woLJSI2w0LY6DtSslfTAwO3BZr9ahjZXBLeFYTM3VMKD8P+XAqgPHstXCThg3bWaIEBfw+DUAq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545792; c=relaxed/simple;
	bh=dfRrtZidWVRY9wKIsKcb/ugq5TUhW2b+/SDBUkLcZjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZjU7GbZ726qDp/LC4859cw5M+AYMztrYhz8IZku73Ylr4DjSSR5sy+ZGXp8RPtVFb4FLTKVcKh4tmeIl9QWTTq6xws46bHJwnBwxHVe3PmNb0DfJ8/SMLFjETbTt8U5vzqF3+N7f61qVxxVsnfJlcrflw6IeBvK+Gw0pz0ztjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZM1am94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZM1am94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E9C4AF09;
	Tue, 13 Aug 2024 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723545792;
	bh=dfRrtZidWVRY9wKIsKcb/ugq5TUhW2b+/SDBUkLcZjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BZM1am94AGGOkSmRq7iuu/bRoPcBp8CVX3uXvi+cZQU0mw99908rOkDBlzIHNiC98
	 nI4ChF4nd3LpwBRgXk9Ustrq91kIKMSCdDz42x8kBzq8JrmqBVfP8i+s36+CIItGlU
	 vrM7LhbMXd8fTnMxfaSZhU6kkeG4YY8zlN5rZ4zo=
Date: Tue, 13 Aug 2024 12:43:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.4.x 0/3] Netfilter fixes for -stable
Message-ID: <2024081302-abreast-unvocal-0935@gregkh>
References: <20240812102848.392437-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812102848.392437-1-pablo@netfilter.org>

On Mon, Aug 12, 2024 at 12:28:45PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for recent fixes already upstream for 5.4.x.
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
