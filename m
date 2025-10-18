Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFA5225409
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Oct 2025 19:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760814797; cv=none; b=Acpr2QuYsArHAgWeDGxvzpTMx+lReMFc9NIdB7r9tjFuShjeVyRtEgCRwYkz9JrmJDUY0y2nXCitOt5iRky2lDQJHSddTyDjCJa6HyaytD4XCrWBEixwNEP1KNdmw3xyV3cuy7ydza/mqB6mUUVHC3t4rU+mV2PL+e0EjiXod0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760814797; c=relaxed/simple;
	bh=iZCROnEPcEXaKEcG3iqMaS5HieIhDIDanHIqqjk39cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDqW2zDhTkLELMaHVJBVl5DiTKdcwbNYcbMZLasKimnjYdXzBQ4YlZisgjkfRrxu+k/xJ6VaCkDDu4bl3JzAa/mN9LwML+AjR0MR4Jv4eFwV6elOEIUeE3IpU0lGflAZuipx07i2JQbNrZYLjOrmXoxys+fq9bA98fpWvWTfPXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Wr4OMqiF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Wr4OMqiF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+5W2bEUYASfKNbs6KOemzLGDpkOPDjAzL/LvVkgAmZI=; b=Wr4OMqiF0dE0z6EYfMj/2SUqAN
	1lK7OREwq7TeK1HOLkryqDdb9uS+VW/dYPaxEfLdO7oka5lkCHr5iWWRGq+J+devzfK5K5IyDy/XA
	2xyw53MFv6f3rzFWOl+pj8pqeDRTR0Dw6D9Xy3CzRhabffIxSxfixkwv13vkORiBOqjGBHPV9JoWb
	TL6Y7xNUTbDwhLTUJ3fX3VsTCOe7uWeoATPzs9bZnRiiw3cUoX6MhsxFCamhK0l2MwRTT96SYYxnd
	gaimhvzdpDShHRFLW1S2Lm0Bs4sraNsDwsPuIu6aiwpSIkIbOWchjTBYf4BpwO884ZFZzhG9hRYqN
	3US/ah5A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vACMT-000000005D5-2t03;
	Sat, 18 Oct 2025 21:13:05 +0200
Date: Sat, 18 Oct 2025 21:13:05 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH] utils: Introduce nftnl_parse_str_attr()
Message-ID: <aPPmwQ6O_4L03DSe@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20251015202436.17486-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015202436.17486-1-phil@nwl.cc>

On Wed, Oct 15, 2025 at 10:24:36PM +0200, Phil Sutter wrote:
> Wrap the common parsing of string attributes into a function. Apart from
> slightly reducing code size, this unifies callers in conditional freeing
> of the field in case it was set before (missing in twelve spots) and
> error checking for failing strdup()-calls (missing in four spots).
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
