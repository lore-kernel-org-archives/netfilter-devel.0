Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F34321420
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209607; cv=none; b=E5QJHjvvWG4xCbQC18Q/uzc4Thu79r/WMK8JM0UhjxnO7R3HtYOJbS4wvQgjWybbDE/CPkaaF6mlfKGGQz1IJ5rQdH/5BUIoICc9OkO7ROhcc3GjDHmjkGurHeKUBzLvmK/0MmmXaGz0vTHRBcEu28JZy5OuB2+RqY+dWcw/ftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209607; c=relaxed/simple;
	bh=MM3V12nWu7teyCbk/u0bS2dSX/3bNjybB13nu/6BDbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAoOvFQf/e0ZHOZxjutoLA+95GTjIZ0PKsNlO5+5dqYFrzwRt+kcp+tPC72vICnLvh8ijFFUS3payfjXvOv94Xay5StP5wXdjO2jdUnR5SGv7qqaB6sNmafcdjRPaUHHS6BV2/epOMsNxzl5u/KdgzLV0bX6SQoRHuxDAp3xeQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KqiBUO7y; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TDP9Vb73; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KqiBUO7y";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TDP9Vb73"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E07DA60255; Tue, 26 Aug 2025 14:00:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756209602;
	bh=vnpG2whL5pXeNVeh02UvRGFNPy9oE/onDbN+mbW3g1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqiBUO7yX/cgKm/GdB7naDG4ZkFEcaahm24kXyG/EbMDQUkFnlfsRgsySxop8Z/ic
	 /zH/t7mj1v18SjI3eMtss7QdbzsU3xCEjg21ne5NDK9qdLxH4aCZuvCrNcG2f+5ljN
	 59CEyFecb316xGpaTp1VHxTJSLYEpPXZF7x+yLGjYAZST7FfIJVXA2103im6UyKdPx
	 RSpWXD50BBc6Xl0sk7J+h4ui3L9ebZhW1WQG2TBoAkh16w8SRT686chsOdBFyZtj2v
	 0RHtqPcb3byCHNof3KBVDHfrHZKak+Nre9TaZtj3cnupJ69r0BgzHjXdRuXhaPkEWI
	 17/Iuhr8pAywA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2F3F960251;
	Tue, 26 Aug 2025 14:00:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756209601;
	bh=vnpG2whL5pXeNVeh02UvRGFNPy9oE/onDbN+mbW3g1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TDP9Vb73+dj/FvtbgJFqpk5Av4lMmrxR65ZmK+OwyyCEzmGgkZsPfL4tBVdVYXrqy
	 /ZRTX5vIPPhtdbC5irCf4NRZBaQiSPWP+Ecu8ColLhIU2mpKyaGCm5mAs6G2rWYmSt
	 Rif4g+1SjvRFU/Rex5jX7aQNISPIilb39jtc1N1AW3EXrcMAATJasJjlowun6dzyg3
	 N7RNCAnTGbPgYm1noqVInDwSSeXE7uDhbmalYUjtmRqQRSLAuG0s3+mYH9n8qXrgXp
	 xW3q3nh6Nc2OQS6xdcrPnGsws8vPDn7qLnpm8NAIS+qkJ3Ej1lCALnV2f3Wu1cuVO2
	 H3askJ0UK+4xg==
Date: Tue, 26 Aug 2025 13:59:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] trace: Fix for memleak in trace_alloc_list() error
 path
Message-ID: <aK2hvhaHxcHQveN6@calendula>
References: <20250826105737.32345-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250826105737.32345-1-phil@nwl.cc>

On Tue, Aug 26, 2025 at 12:57:37PM +0200, Phil Sutter wrote:
> The allocated 'list_expr' may leak.
> 
> Fixes: cfd768615235b ("src: add conntrack information to trace monitor mode")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Please, push it out, I am preparing for 1.1.5.
