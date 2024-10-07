Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5561D2B1B
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 12:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728303878; cv=none; b=eF8V1BKy1r2pBzxTQNufu1JCCr348sbPvuDDR/4M0tL8KzBh6PDswMsZk7nG6erlzXmbG6i3yg6exprbRN6ySHxd9CCl6/WJ4mV3ne9cE+jtr3IguYuuYfP3uCSUpvxRS4Wqq0YnPOipChS6O6P27nwijpjc67XdM2NeEHWIoj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728303878; c=relaxed/simple;
	bh=d57KdwQi3YevmexPA7v3YQQVEew2c3VTugcGGXj7Ue4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0IRcHSHNRAUjeEPZ2xw3QkRwH1xSd840XCBrYd6ox3Ng8D7teZSUkJY3Ux0MHLjSvWi2aS4n4A5OUd71SwQTrrsrKKv0oZZG/kCOoV1KDIusJajHsouz9tpl6LqeVt+/RW/ZY/B5KSZxSIBLqAu2eO3jE6L3f6jhKQWvzF0mwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aD+RxPl+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aD+RxPl+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wcvkpuLPvpTsJzSPbJM5rWXj3ai654wK5Aq0lVRsPq0=; b=aD+RxPl+VREHUwQiTmPdl1Nepf
	4L543eaxmcuOfGw6W9yHAK5JZbXUC5e3ORu08LQVSzL8u1pPmwsE62bW899Ymat2GDUMtne3XvIcl
	9w9oE1naMaCki+/Bd3fPpa8zWJ5Eb5X2mpyKCtIoXfKBxy8yF//OSs+nu3bgJcV2QkbDKT6FiHpyA
	+hNMbOe61kGmiysPpRHc4GeEt4osTBex52p9ayCoqvGVlm8fE9JVOSIMO0i5R/3H5qdAN1oW9GXt7
	m0ogJRSllrv4sYFhjta4P3eV5uElkw/qTKiixRUtke8CxNV9cV6ZM3HKp5/enesM0yVQpwKSyqvaX
	aGy1vlSg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sxmmp-000000001Tn-2mjZ;
	Mon, 07 Oct 2024 14:24:27 +0200
Date: Mon, 7 Oct 2024 14:24:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: add missing backslash to
 build_man.sh
Message-ID: <ZwPS-3s2-wUcVBzU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
 <Zv_rJM6_dyCVA7KU@orbyte.nwl.cc>
 <ZwMi1knK7rqs+iEy@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwMi1knK7rqs+iEy@slk15.local.net>

Hi Duncan,

On Mon, Oct 07, 2024 at 10:52:54AM +1100, Duncan Roe wrote:
> On Fri, Oct 04, 2024 at 03:18:28PM +0200, Phil Sutter wrote:
> > This holds another interesting detail, though: By quoting your
> > delimiter, you may disable expansion entirely which might improve
> > readability in those ed commands?
> 
> I did try quoting the delimiter when I was working on speeding up build_man.sh.
> Rather to my surprise, the used CPU went up albeit by a tiny amount. I was
> absolutely focussed on speed so left the delimiter unquoted.

That's odd - while the shell will have to unquote the delimiter, it
should have less work with the content. Are you sure this is not just
noise you were measuring?

> The CPU increase was so small that you might consider the improvement in
> readability to be worth it.
> 
> But there is another possible downside to quoting the delimiter. Some of the
> here documents in build_man contain actual parameter substitution so would have
> to be left as_is, leading to inconsistent appearance of here documents.

Sure!

> I'm happy to do it either way, LMK your preference.

I don't have any, just stumbled upon this feature when checking for
when/why unescaped backslashes are interpreted or not.

Cheers, Phil
