Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADBF327BE4
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 10:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763634214; cv=none; b=COC8xbrm8JBvVDeNlfKpT4H60MdFQ+OJzJD+X6wUeMTYIKaPFnpeZq0SkXcDrHpntkA3C4ykz8jmQ+DvOROY12+iGM+W/WFPL8fkwBl3TTq0Qzi7PKYXlpQz12dYuedSWachk5au+tO5vuxEqbMwWJ1i3Ze+yRPRsd+xlcA0nHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763634214; c=relaxed/simple;
	bh=fBrv7AzWxDe0oG7Xd1fbFlHjvwJ7EYL21eafK9plkok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zdo853AnMERzuxfBZhePRoYNlIAd68hAsTzdCgfO+sLD0rQCEx5YeBs0+aGQPteq48Eghv6/PDxuZD7FBwneeNF6GKJtXd8fmWyWRHGLWkAPjYuHauZENV1XBJBiaQ9qa19YGaZa100k2TAGrQUhrWytMkNpQISCVh7sdG0wOjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kj9v7ZUb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kj9v7ZUb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5xjbEVwlIJzN2iHXjQGVO0K/OdVwunGpIx+VG3Vqbmk=; b=kj9v7ZUbM215ytq2r1QZ2PBEBY
	spQb/O6CFeyThLIG3RaEddgOrCfUt/6PxvMT9Ripwz3y8xSddd8pPSiTFwm4Ftcwg/1NMKfYb/E6g
	jZqiEKY7/Q+k5uva88yXF0PCGEBHKz5FSxtyPT5XRIL7GmHXTI4XKoi7UPdnMkE5wOq8Iify4KHFU
	8zHaN8w+BlceRzT0W4t6VhS8GrRXlZ1VeiZVuI22PlDYI8zhRwaTsK3yKS6K6kZUD5rQA5+2JZtlS
	zyVb+Cq/ILqM9XZ1tUqLBnRwonvyn9y6p477OKbrkt5ZawXjb0w1cygmGIV5TB4WgizDyRw6Ab1EH
	8Sh4POSA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vM1p2-000000001CT-0mnj;
	Thu, 20 Nov 2025 11:23:28 +0100
Date: Thu, 20 Nov 2025 11:23:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] src: add connlimit stateful object support
Message-ID: <aR7sIHfbHYERFAjN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20251115110446.15101-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115110446.15101-1-fmancera@suse.de>

Hi,

On Sat, Nov 15, 2025 at 12:04:46PM +0100, Fernando Fernandez Mancera wrote:
> Add support for "ct count" stateful object. E.g
> 
> table ip mytable {
> 	ct count ssh-connlimit { to 4 }

Quota objects use "over" and "until". So maybe use the latter instead of
"to" for ct count objects, too? I know it's a bit of back-n-forth since
Pablo had suggested the "to" keyword.

Pablo, WDYT?

[...]
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 7b4f3384..987d8781 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -2835,17 +2835,26 @@ static struct stmt *json_parse_connlimit_stmt(struct json_ctx *ctx,
>  					      const char *key, json_t *value)
>  {
>  	struct stmt *stmt = connlimit_stmt_alloc(int_loc);
                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
I think this line causes a memleak. It should probably be a plain
variable declaration.

Cheers, Phil
