Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46518033
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 21:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VLRlS+bH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Gt+VtnSGVrvGcex/WGxljNp2v/Mkn2RS3B2p55D0DiI=; b=VLRlS+bHmcJxM55BT9Mw5U97Tu
	EIeaO8VwSmSZ2rNduR3hYuhGGCN2aUV6XBTQj6e2WNVuycBKKNjddJHl/7IvJPXP8iEjjDZyqr0FL
	ZAxU6XBmuIeoEGO+daHY5iS4pLZdk8UmXUq4xnW1T5oav1x1F90btSxcZPdXVEehlg94KmXP0iHXT
	HDWjtzT8I5uJ0a4wZbOsbTTUU7LyWVX++/R09nP83/ODOBKYpCj+HcFkucljv4DrCGAFOWcclymYz
	c7BqVlWFfbiP5a2Um5qoVww+59XyaCb+5ASOxweLutMfGnyusxNmPFmOk7lVnetppHmRXHBmQ5CR+
	08o0KCEA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rKmkl-0000000012t-4Brs;
	Tue, 02 Jan 2024 22:56:52 +0100
Date: Tue, 2 Jan 2024 22:56:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: Han Boetes <hboetes@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: feature request: list elements of table for scripting
Message-ID: <ZZSGo8gwo9_7Cpqg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Han Boetes <hboetes@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>
 <ZZNuZBK5AwmGi0Kx@orbyte.nwl.cc>
 <CAOzo9e4o3ac0xTY4U3Yq0cgrwcaK+gYoyA3UH7xZEqQ6Ju7UYg@mail.gmail.com>
 <ZZRG_yBt8nf-cqxs@orbyte.nwl.cc>
 <CAOzo9e6GvnSs5XY+DY8qW3b7OHNaYk_QjcDSMRS6tCntkhzHFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzo9e6GvnSs5XY+DY8qW3b7OHNaYk_QjcDSMRS6tCntkhzHFA@mail.gmail.com>

Han,

On Tue, Jan 02, 2024 at 10:24:14PM +0100, Han Boetes wrote:
> Don't worry, I'm used to people not actually reading what I write.

I did read what you wrote. In nft nomenclature though, ranges and
prefixes itself are individual elements of an interval set. They are not
expanded internally to individual elements but merely converted to
ranges of min and max value.

You quoted two elements in a row separated by comma which is standard
formatting for 'nft list ruleset' output to avoid exceedingly large
lines. You're complaint about "clumsy" format for scripting might have
been about the two elements per row formatting.

> I already wrote some working, albeit ugly, code that converts ranges
> and CIDR to individual IP-addresses. But I think if nft would have the
> option to simply produce the individual addresses belonging to the
> set/table, it would make the whole script a lot simpler and more
> logical.

Prepare a patch and put me in Cc, I promise to review it.

Thanks, Phil
