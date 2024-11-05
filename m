Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C461CDA3E
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847696; cv=none; b=Rm9jqvkrnFYQveFQF8EMGghiVWvmIIPJSgtUPFuWzm5UdYj1hFeVwqAtnJ8u2R5iNe76s81yKF2HGpFjIgY8QhY8ESthOtWySNbrkiTeVi+SyinfcjnVTbI2US5H2Zv9F8ke6PisKVw14dcIG0dNyEkCwO0uTLGn+4euI7YdsjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847696; c=relaxed/simple;
	bh=TocvJ/pmrY06d0yEuS08dy1MBN34h8/t3kvqaYAzs9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQOu588RjXNYqw/a1xyJhx3rv50EjJwTAgtpLKYxJDS//fPKlIiPckUD8SQd1oPsFCVfqdC7qSJJAgGnN+GmAdp8Fo+f/w5pQPZH6Lqe9CgtjcS9XVq7PY/THIP+xfr0xLY8ACUKRxSsBCXAbW3AvDAViMJqYEPFUM/3ZccEeq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m4JHJMbB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m4JHJMbB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YBfcZyRS/abEHwp6uZeY3+hklStEVDDO9Jklzh1PE34=; b=m4JHJMbBH6cQjW470MHIbWFQC0
	6QdOxuZXm4/l2MSsXX74mdo/+70CkFzzMvNTG7moU+4W/4JTURaLZhmuw47p6m22euhUTUglbVbV8
	CslTTPxHmUoVAXcg5p3gkGBNLqklhSDBRH+vYZo3NCm9W1FY53V44Tbe3oXf9FYjar7JWrkiSTCP/
	ZDlpeXRj/uF1RBpvjsK0QLWUAqpbPoDEIwGAtgPqsY7FdT1UwloQ/jPtL3fZIGSWuLaFGyGUhgQGY
	Lo+zISFwB4JNu23u0DUACA5bPN+4b5uqGPN2FvZUJiCZ2/IyZhauUsBWg9hskZv75LN/IBCHSM0Tg
	W1D6DfOA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SYH-000000005J2-0zWD;
	Wed, 06 Nov 2024 00:01:33 +0100
Date: Wed, 6 Nov 2024 00:01:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] tests: iptables-test: Fix for duplicate
 supposed-to-fail errors
Message-ID: <ZyqjzYlbRU5wCAL8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20241022150426.14520-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022150426.14520-1-phil@nwl.cc>

On Tue, Oct 22, 2024 at 05:04:25PM +0200, Phil Sutter wrote:
> Unexpected results for lines which are supposed to fail are reported
> twice: Once when fast mode runs them individually to clear the path
> before batch-handling all others, a second time when non-fast mode takes
> over after fast mode had failed and runs all tests individually again.
> 
> Sort this nuisance by running these tests silently in fast mode, knowing
> that they will run again if failing anyway.
> 
> Fixes: 0e80cfea3762b ("tests: iptables-test: Implement fast test mode")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
