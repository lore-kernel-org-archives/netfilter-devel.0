Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD815200B0
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742552657; cv=none; b=f8TP12cm/wmOfX4gYXeLaorFx+KWKwGZjlgJFyrEeiUCb4qzDHItUSPdcsBMuRptyTbwr2+FeJGP5LuaYIjoO4raQiO9xcKcWA8li+sLi0PY4NagJHjVPN4oRUulNrKbB1ynsWbkEirwO3zMFp859tRrzKjWF8i102/vXokLnY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742552657; c=relaxed/simple;
	bh=4FQwSd2aFf18jE2urjWIYF9C+ZFzhJGSfdYB1ZQM6Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvyPg8s5qJEbDJq+GVqutPIN0v3YN/fCBEx8bT3ytiN5t/s/cbSdrfBILoqXjfzS8+yzfyJKXb46uWtIb+o8eg8dEqlB8sWLx2iwbHBPJdBtCIBWx7eoGLPcqhIvbxOYE8LedKkmEJtcXWtiwVXvmyqj6C6yghoans8wDLolAzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jmpL4OQC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F4IlCd0p; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jmpL4OQC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F4IlCd0p"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 86403605A4; Fri, 21 Mar 2025 11:24:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742552647;
	bh=wUe/cxr8dFw3rnh2ltKOm+ywb0yay2kuy13ZGTamU1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmpL4OQCY+/4swBpeoIdT4uLdCnfF+PY7WvCUxn990090JjLHN9jejrmwC+bv1C5e
	 S+pegAPbzcZPpmhTRlQB9kTOWTwdkBjcSLPglWLv6IHinzff/Nx2cVv9xM8OjQ3u2z
	 BuoLh2boTPI5hl/b8tElptg5iCrFmLtREnurLR4tD1+ZJWUdNgrPA4VvNJod1XDELz
	 7QEOJ3myEXNO5JehyTOyltdM4IowGJ0rySSTzkZ+W82RDvc8pDREQ1/0jNjdGbIJOh
	 bog5+MYJv+05YlHgPA3hTldQv7hpjWddNzNv5+alvXzlWvMaT23Cc3rOvN0Y4ikpIf
	 qYgBKJ4dPwODQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1460A60572;
	Fri, 21 Mar 2025 11:24:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742552646;
	bh=wUe/cxr8dFw3rnh2ltKOm+ywb0yay2kuy13ZGTamU1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F4IlCd0pLY7tOPxCE38Hzd6S7KfgR0bv81cau+7UT6nhbAjPqF/OeTCT/olUV2kwe
	 L3RV8qzIm3nl4QLVuPykb9s1byfWiNrFofW0I5Qs8+UPU1Ts1Nk9y2dFwgdtFfZTiA
	 IPfw1xE/QgKja+wFueDpze3btXlqTPVcS/mgFrcWofUOV18FQgAtisTLmE2aEIBd+6
	 QfMy2RYXwZNfvTRwbgoHS6cXOspFZUAbZyTBMJRrShSNYlliERNaUdJ28VR0q8dSzM
	 OB6ZZVZsTuiTTztkIbk24BWWhfWb5IIFca/RusysSFRNQrJd8MTQd6B84MepoG+o7n
	 T9lHhIcpEg5pg==
Date: Fri, 21 Mar 2025 11:24:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <Z90-Q3zyEHDWPBNr@calendula>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
 <Z9IVs3LD3A1HPSS0@calendula>
 <20250313083440.yn5kdvv5@linutronix.de>
 <Z9wM9mqJIkHwyU1J@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9wM9mqJIkHwyU1J@calendula>

Hi Sebastian,

On Thu, Mar 20, 2025 at 01:41:26PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 13, 2025 at 09:34:40AM +0100, Sebastian Andrzej Siewior wrote:
> > On 2025-03-13 00:16:03 [+0100], Pablo Neira Ayuso wrote:
> > > Kconfig !PREEMPT_RT for this is not an option, right?
> > 
> > That bad? I though it would make you happy ;)
> > Making it !PREEMPT_RT would essentially disable the whole nf-legacy
> > interface. Given that it is intended to get rid of it eventually it
> > might be an option. I mean there is nothing you can do with
> > iptables-legacy that you can't do with iptables-nft? 
> > I mean if this is not going to happen because of $reasons then that
> > would be the next best thing.
> 
> We could give a try to this series and see.

I have been discussing this with Florian, our proposal:

1. Make ipatbles legacy depend on !PREEMPT_RT which effectively
   disabled iptables classic for RT.

This should be ok, iptables-nft should work for RT.

2. make iptables-legacy user-selectable.

these two are relatively simple.

If this does not make you happy, it should be possible to take your
patches plus hide synchronize_rcu() latency behind deferred free
(call_rcu+workqueue).

As this looks now, I am afraid chances are high that this series will
require a follow up.

Thanks.
