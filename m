Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434E214F9D6
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255334; cv=none; b=BttH8nLmkzrfUrG1CHY3ZvEFZXnOB951BtiLiJOFupn1NJyGbPMen0GmYTdU4YX4uwvM/HTZessgi4QB4rUHkt9dBIjU01d09wipXg6kig0SmavZnASOBsqxdREvwB0CV1C1T7M+PmpDyZjNTcGFQ4Xnf0akGs2zCXG6mavtSAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255334; c=relaxed/simple;
	bh=+Z0s9AQfvYnFni0TcjvmmA4cxkeXvzu4rvGmyFupX/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIi8RYtUtvLJBeK3qJGeBfRua3NxZHuFluEt2SC2DKtutfK2sAIirXDNQARYue+CNVlWyHQXsVJiaM0GR6z0WpixRc7tx7sazw5OyRWHchArJsMkX3ar93zV9WQ6Ib8mqbA0Rn8qoLpCSrEbyGCc7sBJsbqwtUjcp+wIUa93Te8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AuQ8mxla; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AuQ8mxla"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 140B66087F;
	Thu,  5 Feb 2026 02:35:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770255332;
	bh=BY69nTAyDfp1L+BBJGlWFkpU32AN2p5LNmvdtRtFfuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AuQ8mxlay+ULFUNu2BdY8pJpFo1DJLRXPTub9omm8ja4lBOXNmHqEn/0ZwHyMAFys
	 MALzG5IcGj5WxR4WrkGM4xBGGi+fXWzMlzJuOpvkJ7Id9LazWC/x4avvnfy1zZSwqg
	 BHw838JyzgTt9qgWuknx50Cxx4JxxzEHsuY8q+agwKbxcI1FCtg6MNmyGZzLknxkE0
	 2f6C1jg2Xs/4l37w6Jp0OsokDnACtupwI0w7ncbnLue5tT9IsiZRDPZVbRJAmpD2Eq
	 nnSqGZBd5X7vhpKHk5l9znepNqflDStkTfaq++ybsUBzumZdOSqLHBpswY7/lSL3Ka
	 eC1Y2MzE3qy4g==
Date: Thu, 5 Feb 2026 02:35:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] xt: Print comment match data as well
Message-ID: <aYPz4TwVBQm3Fb0k@chamomile>
References: <20260127222916.31806-1-phil@nwl.cc>
 <20260127222916.31806-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127222916.31806-4-phil@nwl.cc>

On Tue, Jan 27, 2026 at 11:29:15PM +0100, Phil Sutter wrote:
> In order to translate comment matches into the single nftables rule
> comment, libxtables does not immediately (maybe mid-rule) print a
> comment match's string but instead stores it into struct
> xt_xlate::comment array for later.
> 
> Since xt_stmt_xlate() is called by a statement's .print callback which
> can't communicate data back to caller, nftables has to print it right
> away.

This is a bugfix, correct?

> Since parser_bison accepts rule comments only at end of line though, the
> output from above can't be restored anymore. Which is a bad idea to
> begin with so accept this quirk and avoid refactoring the statement
> printing API.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/xt.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/xt.c b/src/xt.c
> index f7bee21618030..c3a8c47621cbb 100644
> --- a/src/xt.c
> +++ b/src/xt.c
> @@ -112,8 +112,12 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
>  		break;
>  	}
>  
> -	if (rc == 1)
> +	if (rc == 1) {
>  		nft_print(octx, "%s", xt_xlate_get(xl));
> +		if (xt_xlate_get_comment(xl))
> +			nft_print(octx, "comment %s",
> +				  xt_xlate_get_comment(xl));
> +	}
>  	xt_xlate_free(xl);
>  	free(entry);
>  #endif
> -- 
> 2.51.0
> 
