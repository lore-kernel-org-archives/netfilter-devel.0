Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166018EAD
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2024 10:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707907666; cv=none; b=jeQl7KF9643HHr7a7fVGH13wSgJsmMlTIMA1R+W57P6pf0J0XFmPHvS2VUAyfjA0t7MCiMPUE7D6iv/+Hl8vph+TWZDOFyc6Ekdq1/StHcxxFfZDtMvkFmh/K/s0hKULQuULXnOoU13SXNzJkpFnLW7zQIxl3j1ujA1rD/SIMFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707907666; c=relaxed/simple;
	bh=vpxzMyyaV2FMFH53jJKSZiWu8i4m72xVQZYbfCQ1kWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQRKoJe7/lws+bzcYprv87RNb0e7FDdgyWKHJk5Lw3cvYNHw0zG0aPFp83Qkxlev/OtScARssrjDzc2cQ8xImbGfr31pipS5ZP9834w1rOcQ9wqQ3EKvXNcDSwrQgjHYl50pwkBrvA0RQREoFAMoLRsJOwxqGo9qYYREq87N/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=55928 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1raCna-000zvq-Nm; Wed, 14 Feb 2024 11:47:32 +0100
Date: Wed, 14 Feb 2024 11:47:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] Convert libnetfilter_queue to use
 entirely libmnl functions
Message-ID: <ZcyaQvJ1SvnYgakf@calendula>
References: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
 <20240213210706.4867-2-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240213210706.4867-2-duncan_roe@optusnet.com.au>
X-Spam-Score: -1.8 (-)

Hi Duncan,

On Wed, Feb 14, 2024 at 08:07:06AM +1100, Duncan Roe wrote:
> And no libnfnetlink headers either.
> Submitted as a single patch because the first change essentially broke
> it until the job was nearly finished.

This is too large. Can you start with smaller chunks?

For example, use mnl_attr_get_*(), then pick the next target
incrementally, so there is a chance of evaluating what could break,
because this conversion to libmnl _cannot_ break existing userspace
applications, that's the challenge.

> diff --git a/src/iftable.c b/src/iftable.c
> new file mode 100644
> index 0000000..d0ee7dd
> --- /dev/null
> +++ b/src/iftable.c

There is a iftable implementation that has been working for years with
no bug reports:

http://git.netfilter.org/nftables/tree/src/iface.c

It coiuld be reused for this purpose, this could be your second patch
after the one your suggest above.

Thanks.
