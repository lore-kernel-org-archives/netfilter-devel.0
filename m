Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA2F1AC43A
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333501; cv=none; b=uPC2MAcDwE4mfGJoxmIC+hGJ238Wi8cCczJXnQC1YODRyoqnWwU//36PaL0OFaYyOp0sIh0GqklzweH89gwu8TOiFFM1bo9J8SM/cV+JfoGhU/iNWIDao4vWri5D6nhhEWes8sIGiwBgRHEcP8jY/sTojUrLUv67z/9+ErNGJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333501; c=relaxed/simple;
	bh=52cG+F6W+lF7ze+b0REeGW3RrKqpOqI8Wz/rdZOvJyQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3oLB/nQ/0/PuB93qQo0M7hyHEUUBFUFgCCR77JF4ZnjimBAshedDEBsV6M/2soirSBv6nEJ8cKvrhbece8XYHno55J/l19JnIdEZjYQTF1d70LCHdf8FxsPeBTLPuZIJO2NhNLoUkSOmmKo5gOWdkW/LjWz+YxFlyyuAVU4kek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UGSlU732; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UGSlU732; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UGSlU732";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UGSlU732"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C4D2860780; Thu, 28 Aug 2025 00:24:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333497;
	bh=9sI36Ys5RmQm2CV5gN882ktH4H6Kbf/Fy1/4HuiVDRk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=UGSlU732napYBoUxq7230BeM3DZQ7o+npirhL7OoigU7ABRrjRtCuTjaihBkB/KWk
	 BFba6nCynOxyReHvF5Q+S36+3B+HQ3OiOr+Fzk9pN7RoAtvjmM/xIn2JUXc0AnLkEs
	 JrzPbl9a9/KlpbPUGBQVE8q/9s4hp8zqVn0nPJM4KiU1byZxZahrJ+uzITTx1VtZQT
	 O9uBHSzOigjzgCMZXt5NVcct6dbeUI7RT+j38G7rsWAfBge40s6ZNqnxORjpSkVMtI
	 oN+LSEjXxeFB5toZ0DLoMfAzJ+O4X+2wC9t7F/20qaGzuZHEwT5L8TIffSl4bF2wQp
	 5n6pTnkeKrSGg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 660C46077B
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 00:24:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333497;
	bh=9sI36Ys5RmQm2CV5gN882ktH4H6Kbf/Fy1/4HuiVDRk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=UGSlU732napYBoUxq7230BeM3DZQ7o+npirhL7OoigU7ABRrjRtCuTjaihBkB/KWk
	 BFba6nCynOxyReHvF5Q+S36+3B+HQ3OiOr+Fzk9pN7RoAtvjmM/xIn2JUXc0AnLkEs
	 JrzPbl9a9/KlpbPUGBQVE8q/9s4hp8zqVn0nPJM4KiU1byZxZahrJ+uzITTx1VtZQT
	 O9uBHSzOigjzgCMZXt5NVcct6dbeUI7RT+j38G7rsWAfBge40s6ZNqnxORjpSkVMtI
	 oN+LSEjXxeFB5toZ0DLoMfAzJ+O4X+2wC9t7F/20qaGzuZHEwT5L8TIffSl4bF2wQp
	 5n6pTnkeKrSGg==
Date: Thu, 28 Aug 2025 00:24:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 00/11] replace compound_expr_*() by type safe
 function
Message-ID: <aK-FtjV-eiiLd23E@calendula>
References: <20250821092330.2739989-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250821092330.2739989-1-pablo@netfilter.org>

On Thu, Aug 21, 2025 at 11:23:19AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This is v2 with minimal changes wrt. previous series.
> 
> The aim is to replace (and remove) the existing compound_expr_*()
> helper functions which is common to set, list and concat expressions
> by expression type safe variants that validate the expression type.
> 
> I will hold on with this until nftables 1.1.5 including the fix for
> the JSON regression is released.

I have applied this series.
