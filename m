Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561D923D7EE
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999452; cv=none; b=gVrCJsEVMu2AV0kVs0JTSxD5TP0AE2qZULF5Al14NxAMpY6WVvTeAydQpy8CAXNfqYjXuE7Y6qmLKQFGuLvktiAPAB6p+u3C62t9cqHuB+lApUSHj5+2gYkEnHR4qVOrEqaV9wWCyqdgWBl1lZDBaYBG8yNOQ5nhvfuV3RN3jLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999452; c=relaxed/simple;
	bh=nvcuav2QtRv7A+NNm68mEnLbKOw9+xI5K49IQGr0Vr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsB8NKaKWIpLtjAJ5BBnAshKkYK4CRTynf6i5KKEnTmre2VzpSY16/bK8KiM/yK9f3M0v+9W8e8VSOByu1JCvDc3maooVti9Ypeu2WFx3EbhVy9meNA6+1DTTNl6AVYyHjHhsxvYc8eYrHFxTGqPuwfkrxlQSaP9OILveEhSBhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OLh0Bk6u; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PhjWrAZs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OLh0Bk6u";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PhjWrAZs"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3E25C607F4; Thu,  4 Sep 2025 17:24:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999448;
	bh=u0wbBnf2ChIc33W82N14jjv0ijnfYKqdFu+NogzjJyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLh0Bk6ukUlso+c/Epg46xTFN99X9ObVOeL7a/1a4amsp0Hg1SnE/EfBA77Nv5D6F
	 Wfwo+XtMAJURAMel8m2eWLJO9lQyXlSTGcLcszzmFrHNhfiSjiis0qdreiZsLsbbj8
	 TFNoiEiAqUi6scjqhppFeGJvD1iZ2AIuYLrLl8/YYjbveINFK7i5bHGtQGA0lOgbZc
	 KNe3a4zS2VEAmpTRI4ymgOvh4efQ11rjY+hNJhDfO0OM+jOQacbDO5Z2w194IAnyGu
	 F9LWopy+Gb5Pe2gYRr5g7HGFCmNQSKl0Rq7cxzD8ukYeosv+mHe0RSiGLS1D1xaxU3
	 HUZy2jTzKiwAw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A42ED607F4;
	Thu,  4 Sep 2025 17:24:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999447;
	bh=u0wbBnf2ChIc33W82N14jjv0ijnfYKqdFu+NogzjJyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PhjWrAZsw4/Jwoc9UKhP0KAEjdrtG66mhhQdYqGp9Wh4dE6WGBG5ttR2LVYt8uyRd
	 T6BYo9fEFzAHjNMn0unbKK7Zma+9jxFWrMw0p69rEH3u5MYwoYOKeprq13THxeeOqd
	 bNhyWinIbwo6WtwcXpSsvhzM4kH55JPq5YxjbjecCancjHixRMUWldFPkzoMks2niU
	 +xRYlxvWaXX5OLc+ZgzUN0nLAjXX9YSZOKiIzQsuHr86Y36D6L2bBctBtXYgb3VkaC
	 XKRAXe+V3a4PBm2m7+nkhl+8Woq9yw8DD/NU9Lz4g51b1qCF8G0l+qpsZfC0vbqV7O
	 9s+2S3ZEQbV2g==
Date: Thu, 4 Sep 2025 17:24:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 06/11] tests: py: Enable JSON and JSON schema by
 default
Message-ID: <aLmvFelK5vCyulGT@calendula>
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-7-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250903172259.26266-7-phil@nwl.cc>

On Wed, Sep 03, 2025 at 07:22:54PM +0200, Phil Sutter wrote:
> Introduce -J/--disable-json and -S/--no-schema to explicitly disable
> them if desired.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/py/nft-test.py | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 984f2b937a077..12c6174b01257 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -1488,7 +1488,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
>  
>      parser.add_argument('-j', '--enable-json', action='store_true',
>                          dest='enable_json',
> -                        help='test JSON functionality as well')
> +                        help='test JSON functionality as well (default)')
> +
> +    parser.add_argument('-J', '--disable-json', action='store_true',
> +                        dest='disable_json',
> +                        help='Do not test JSON functionality as well')

Maybe -s for standard syntax only and -j for json only.

Otherwise, default to run them all.
