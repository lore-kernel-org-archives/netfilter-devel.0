Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5CE42314A
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433769; cv=none; b=Pwd3huNPQU80cqG8Rw8IPQigAQsIfeGpnE7Z4cbZXaysO2bj0lVXd4HI2fF6c5dWghENbtJYay8VZC+ZlQr6YWzCWXtvxCaHglMHbR946yZk5X9LiqpYCXhV4s1Zc4yM8mqaYbx4KD5kF5T88RSOp987S4XTmaTTGD48qyP0Dm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433769; c=relaxed/simple;
	bh=HMvXTewk34QsdjmyjVlR3zGuOZkgzgyjyoUxXYtKLgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dlZVKd7/6XQexU5nq/B5CqforNs1szZ1GGF2T7hurKLRZaAnACuvMM8L8x3bjyl54SpfCfsmHgxXXRfwIjHzHKfDebMSE0jsMv9WpDC/SsODk9BeJ4xmWql/BwboVQU3F4bJ/RahGjbb4iMM0hg/54lVumWVf1NQkRK4JskkC84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y7VY/bnp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y7VY/bnp"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9CACD60577;
	Tue,  7 Jul 2026 16:16:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783433764;
	bh=Oys78aXhyImAMTFuC/BnSM5ZKfmKeImYGz6ni3EF0V4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y7VY/bnpuQEERlFbmPaA/yC2VKyQ6KH31n1hDtJozh+CSZajeciK7JxnJ04Fkmy1r
	 2vRRB5i9R8keDMoa9p/mzBPodWuFbCJYNXi5IA619CbyIHnJwGLiwY1TRV3IXdlwYF
	 OpQ2h1mK450KnlwlhJJ/yShjL1wcxVMWM/HPXuZpGDya8eL5cJY4uGRA3YSBrbQzDY
	 r5Y5DzXNWe35uIFknV3dzI2Y4hWzVCMTKJyJWyDt5Q7qtft0O+87yibK/cWp250sil
	 9TNI7mJSVMciMpJYoy7ZGpjwzqUchcpexuWRkbTqEhMBS0fLpJ96qC8jsRLQoDP10v
	 mtdsO/K0BmKow==
Date: Tue, 7 Jul 2026 16:16:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: expand get command test with open
 intervals
Message-ID: <ak0KITUOuYAXYm5v@chamomile>
References: <20260702123634.349861-1-pablo@netfilter.org>
 <20260702123634.349861-2-pablo@netfilter.org>
 <akz-fH24aKQbjaHm@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akz-fH24aKQbjaHm@orbyte.nwl.cc>

Hi Phil,

On Tue, Jul 07, 2026 at 03:26:20PM +0200, Phil Sutter wrote:
> Hi Pablo,
> On Thu, Jul 02, 2026 at 02:36:34PM +0200, Pablo Neira Ayuso wrote:
> > Extend the existing test to cover get commands with open internals.
> 
> This test fails on a Big Endian testing machine running Fedora Rawhide
> running 7.2.0-0.rc2.21.fc45. Does this perhaps test a recent kernel fix
> or something?

Does this kernel contain this kernel fix?

https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=d63611cbe8af99dd61b118ee6e5b5e3e518250b2

as well as this userspace fix:

https://git.netfilter.org/nftables/commit/?id=4eafc1a2a9ef5a827b1b4e58cb3b2832d2eb1650

> Here's the test output for reference:
> 
> | W: [FAILED]     1/1 testcases/sets/0034get_element_0
> | Command: testcases/sets/0034get_element_0 
> | Error: Could not process rule: No such file or directory
> | get element ip t s { 11 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t s { 15-18 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: Too many open files
> | get element ip t s { 60000-65534 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | ERROR: asked for '60000-65534' in set s, expecting '60000-65535' but got
> | ''
> | Error: Could not process rule: Too many open files
> | get element ip t s { 60001-65534 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | ERROR: asked for '60001-65534' in set s, expecting '60000-65535' but got
> | ''
> | Error: Could not process rule: Too many open files
> | get element ip t s { 22-24, 60000-65534 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | ERROR: asked for '22-24, 60000-65534' in set s, expecting '20-30,
> | 60000-65535' but got ''
> | Error: Could not process rule: Too many open files
> | get element ip t s { 22-24, 60001-65534 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | ERROR: asked for '22-24, 60001-65534' in set s, expecting '20-30,
> | 60000-65535' but got ''
> | Error: Could not process rule: Too many open files
> | get element ip t s { 60001-65534, 10 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | ERROR: asked for '60001-65534, 10' in set s, expecting '60000-65535, 10'
> | but got ''
> | Error: Could not process rule: No such file or directory
> | get element ip t s { 10-40 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t s { 10-20 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t s { 10-25 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t s { 25-55 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t ips { 10.0.0.2 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t cs { 10.0.0.1 . 23 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> | Error: Could not process rule: No such file or directory
> | get element ip t cs { 10.0.0.2 . 22 }
> | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Cheers, Phil
