Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF132F1FDB
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Nov 2025 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763813017; cv=none; b=XsML8RBHyzOkRLU0XfP03vOT3i6llOVKtLdC26PXRcYi4qSMppYxZzPBWW+TYZNvFtwqe95bmcFTdZraytQZXw0VrgOYYmWFvf4hCdl8ePleNnrHm84TfPqy1V4Q2DjL5xy0lfzeQ2NUGqHYLIrPWFHGS7vwMfHsZjDBIPHEARw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763813017; c=relaxed/simple;
	bh=2BnTkQ6DVAGS6tv5cpKsqihSIzoJq2SDwob5g960MDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p2fsaBxCwp+K6s4mSozQDfUbqSqr/2krujJKLnoZdYgFJBC+PTFrp+htX8qA0WSUQ49AMbWWeyMrszLzAUZPjIb6YiApOIRfwFacM7h3oT3nxLCz9EloSZ9eKRed90D5rhAXd+OMUgNqQsr4SyqhIsaryAxBMY3aMTAN/Jng75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YAY2KGoJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YAY2KGoJ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 731E260254;
	Sat, 22 Nov 2025 13:03:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763813005;
	bh=6+jbI3RcYC3fjjLL51JASu22AKrSV/0t+FeA1FvBHSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YAY2KGoJ5jZjYMuCt4X6RI34RJ50Bk95vTNu0S+fCKY9yZ3OEXaoSnRSlEF5J14qa
	 4z7H0PcUcX7cwxW9GP0JA028/HXjWi2Rkt0DnqYSTOW/PTw5w2ZOl2kfSToRq/zFHD
	 zBTQXJlKiObTVK27e9NwiLonHLMxi0SjDxOHIm+PD74k2OLAS2pWws3N7Z9efYEGEt
	 +w6xWB7nJFo+9Ey3BS1XxmIfnxROKNIPfInL3peqnFx9CGD9DzT2EjPONTmWt92igN
	 gjz6Et8Vs8oeGl1Ckb0pNlj/g3UqgUpq3ogDmkDJfxwUZOrsHVAUa0wZNZbS2JBXnQ
	 ZpsyAMTKyEZ+A==
Date: Sat, 22 Nov 2025 13:03:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH nft v2] src: add connlimit stateful object support
Message-ID: <aSGmiho8ighIT7WL@calendula>
References: <20251115110446.15101-1-fmancera@suse.de>
 <aR7sIHfbHYERFAjN@orbyte.nwl.cc>
 <3a187dec-cd78-43cf-b202-e8c1d64c4f3b@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3a187dec-cd78-43cf-b202-e8c1d64c4f3b@suse.de>

On Fri, Nov 21, 2025 at 02:40:54PM +0100, Fernando Fernandez Mancera wrote:
> On 11/20/25 11:23 AM, Phil Sutter wrote:
> > Hi,
> > 
> > On Sat, Nov 15, 2025 at 12:04:46PM +0100, Fernando Fernandez Mancera wrote:
> > > Add support for "ct count" stateful object. E.g
> > > 
> > > table ip mytable {
> > > 	ct count ssh-connlimit { to 4 }
> > 
> > Quota objects use "over" and "until". So maybe use the latter instead of
> > "to" for ct count objects, too? I know it's a bit of back-n-forth since
> > Pablo had suggested the "to" keyword.
> > 
> 
> To me both are fine. I don't have a strong opinion here.
> 
> > Pablo, WDYT?

Fine with me too, thanks Phil.
