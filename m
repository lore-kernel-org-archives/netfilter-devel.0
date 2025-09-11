Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E8F352FCD
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603622; cv=none; b=A7aUIB1ZHXSXEn5mGeok7brpsFw11uVK3Mqgg7GAOuyJKvQVXImc8eWBowjNIt6CBuOddm24tTxuFOmXN+zTFtqziNkhOuDYal+QxdeU5zs/Ol80n740Jqiz4uVqTfSiz+Hw7Q/ui5yanKIkEfFyecbal0nFo+kmPnvi+c/t7Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603622; c=relaxed/simple;
	bh=AWWNsXP5S8UHgQzpvePbB4VveYQ4KCg3Gvvq8icydgY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkzsR7vR+fST3K2If7GHT+aHSjjiRU85sgQKNamdb/ApwoOGPHM4QuGWp2+HJUWjm2f9ZrcL/bq1OHTTpAjS+k1E3c1sT0Kh5UDL99OctY2XG4dH8VuPx/mYlWInTQ3S41UhduXsrMaP/MXDjimtO6AmM9bl7LVHWd6+61CIDnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NC9q0OVf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X8wqsJH1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NC9q0OVf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X8wqsJH1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1E6AF60763; Thu, 11 Sep 2025 17:13:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757603617;
	bh=S+E2s1tMQ0cj26gqe2VW5OKRPuxZ2AhDJfL+Xzdprec=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=NC9q0OVfeJsHVHSglQuSSwTCXDWvlwoR9K5vn9DEmO/S2B28kNpyQZDx38+rSbSfp
	 ry2ZGGTfhD9WYL86vVGX5QMfhuxwwbqQ1iwOMuVFbR7c6iM8rzFb8mzYrjm8d2P8Lq
	 76KrYKZbHvUFh0fR8qtjy1xWwuGJmPVE4YXMcF8lx0N5CyNuFXvUVIAkJzMQzhnUvh
	 9eYJUqa8YCAmKaRLjbf7lH1H9qppNhPfYc1ToueAv56CxDXe+6wdObB6TwR8Prx9rn
	 SKJhyKu8r8GvszN/7+2YDyAQg7CkmAFB0Wvw7gjdSETHmJ+YG4XVtD3xoR23nBOMlt
	 136eoE+yVzd/g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7C75B60763;
	Thu, 11 Sep 2025 17:13:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757603616;
	bh=S+E2s1tMQ0cj26gqe2VW5OKRPuxZ2AhDJfL+Xzdprec=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=X8wqsJH1eZ03KnbmtNiG2uYTTUZotqu0NoOexvoenE3M6BS0M2IMYSBi1ZoinQUvV
	 vvOPLxvfyE5T5VU8Tp8aM575Mjp+wm1zONY6486tei71UYOH38rjM22UbrTB+wWXzt
	 uGfz22KE0pKylRwb6NS9Sva/bDDTvqu9UAyvNKqEbtxzb7ykDYJUuDxDB2Ximb1L+R
	 L2X3myzd+eNt4xrWmbF7xr/MQbtVOLDwHAGk5tQbm2D4EbEDPEN5y18ssDKKm3KCxH
	 XHQvsFFM0kfZY73R8B+Y2lVm+fhzMKrec+IhuCqzYhZflkgIsIsACxm5uA179fEvq4
	 CQaan2QpUzDrQ==
Date: Thu, 11 Sep 2025 17:13:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aMLnHRNOro4E4Z6A@calendula>
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
 <aLm8pkZu0r1hrlUf@orbyte.nwl.cc>
 <aLnFEDmuqOckePL8@calendula>
 <aLnc7AidZLW9dCbY@orbyte.nwl.cc>
 <aMK6XUffoFcnzkXM@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMK6XUffoFcnzkXM@orbyte.nwl.cc>

On Thu, Sep 11, 2025 at 02:02:37PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Sep 04, 2025 at 08:39:40PM +0200, Phil Sutter wrote:
> > On Thu, Sep 04, 2025 at 06:57:52PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > > distcheck-hook: could set a env var so test just print a [SKIP].
> > > 
> > > Similar to your previous approach with the env var, but logic reversed.
> > 
> > I don't think the 'make distcheck-hook' call is able to inject variables
> > into the following 'make check' call's environment. It could create a
> > special file though which all test suites recognize and exit 77
> > immediately.
> 
> What are your thoughts about this? IMO, the special configure option is
> much cleaner than creating a special file and patching all test runners
> to check for it.

Yes, makes sense, thanks.
