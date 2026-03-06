Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFF230BF6
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2026 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772818878; cv=none; b=lDb3QfOabzC/JOdppCxWRs5bWMErDIuqREmKKWE0w+xVzWuYxGQ76pbXzwLYjjvJIH7bZ345xInc9qo3j32jw/4flk41+/fA7xUmNLeVD5vZrb+nYqe3u5elQT5lqMPTJM618ihIT1rdnKyUo1/GH62gyoeIvKC4MX73ouIv6mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772818878; c=relaxed/simple;
	bh=4du3Mx1zkIaU8b+UvcUEDShgMh2W/9PbYL7P0HTWDpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vwv+kgl/tbzbrT3XjW+DgL0H2lKnQeCx4TzkrlMqFNLBMaM6GpM4J6O8ArmoC6oxWcGJwnqvjacIfw3RLlyH9bLrTNWhaZgn52kR9Q+R6iMkDt5Eb59hNmoxuO+rXl3skJ7UUdqqrdzKLaYgMP2/jhYIgyt7zI7uRFXBOjFG+EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ap5rKqSW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ap5rKqSW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4du3Mx1zkIaU8b+UvcUEDShgMh2W/9PbYL7P0HTWDpo=; b=Ap5rKqSWF3jl6sKwC7PWW+TY2s
	0bLrbZ0ZzKagf08vJGFF5CJmKFTEiHJcNpyt3fUqjIbeIh3KD1uCKHoSwjFUE6JRDudqbOkO1kNDb
	fB3QQBymuUAO6RZCeKgqvbaNT4c3iyk90Txt3EyefUz3k1+exxyLtfo+ivyrkv5tByj+aotr+Hc7/
	95BN2TVjVsrcY/kOZ/8OEALkTJ0zWPFwrrvca/8d//c5NLE19D+vFTRjSLxys4nJvhIMX0KhQuNQF
	BaWZDvbVpOshRvlgwrSyNGCiX9Ee8v3Nh/BC98sV19cuO9NvC1JazzsNGLhvLNoWZ1PPfriCElNgU
	t6T/1n4w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vyZAg-00000000888-35wX;
	Fri, 06 Mar 2026 18:41:06 +0100
Date: Fri, 6 Mar 2026 18:41:06 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20260305175358.806280-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305175358.806280-1-jeremy@azazel.net>

Hi Jeremy,

On Thu, Mar 05, 2026 at 05:53:58PM +0000, Jeremy Sowden wrote:
> Since Python 3.12 the standard library has included an `os.unshare` function.
> Use it if it is available.

This patch breaks py test suite cases involving time-related matches,
e.g. 'meta time "1970-05-23 21:07:14"'. It expects:

| cmp eq reg 1 0x002bd503 0x43f05400

but instead the rule serializes into:

| cmp eq reg 1 0x002bd849 0x74a8f400

Do you see that too?

Cheers, Phil
