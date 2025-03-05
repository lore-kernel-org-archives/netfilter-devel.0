Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4772C25DAE4
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741211693; cv=none; b=hggq78mfD/e2LwF6+zYoU0eaaPr0MSbrdb43m5e/+IVBNyxEZ+lS7/TMCjE2WVX0HRxz6Pt79O74ycMxoV1NeyPRmPiHDYtG6XSyny5eyB224iQeEYPcSiQpArkAr0FsAD0DH97H9bL6CbFM4+yD9l4bdf4rbuCgR1Zea3ktbw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741211693; c=relaxed/simple;
	bh=ln8a6fw+K26qsyFg1cY5POQQajfhG0nJ8KO4TBNTJ6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2xe1DT5X6ch/gGUKkwP2wnIunExu1pxX8nTyDuwoGxDsxUYReFrYEAtn+0xoj/zcazHtzDEDzihut221vUWjovovXKxWHyYLemxPQc3XcGsyE0webM4Hjd0cCeSLfwolo7wFKXtPJxSlh7wHFGtMpaBM+BKlEfen1lNDAqnTno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uU8Arbdj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HxN75pNR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uU8Arbdj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HxN75pNR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CB38D602A4; Wed,  5 Mar 2025 22:54:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741211690;
	bh=cHyGHqwQEkwv3VIvBLsxi5GQOOoeh3sSairXD5woem0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uU8ArbdjP2ewyPVapb04jGY7Ti/jDZMqLo39Sdp92kuSe/CcPHdKxH67iSYe8mv2E
	 IV5e6Oohom7WEK4rXXWq9Xl8T1abz8aBgXm36Oy7abGymynACaFYi0js3HWr6pxyNv
	 87tl8TenFf0VCfPrU3DtIrHlOff2c3M9DChrugVfwrJTersqiH28S6uSAibJGcr3dz
	 rqtegkBmYVa81z8j6mrSmVyKddAPVE5mmIA2su02uFLhTTS+dWXRJr+uizvACWnynx
	 P/yFlXHdCkl+nur8eEixC+fe13IRAENbpCx5VxOq96QjvaSJ3p4CxsUNR+gMxC0mUB
	 i5n19EaS4+8PQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C80060298;
	Wed,  5 Mar 2025 22:54:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741211689;
	bh=cHyGHqwQEkwv3VIvBLsxi5GQOOoeh3sSairXD5woem0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HxN75pNRerSpwWhogyZ03qqHmTH0TTKPV9kZ+9/6bkRyMMbGM/3If98CDQd/yZvpB
	 qpUsyo73ac55QZyGLaWPQ8zeNAV9nLEf5iNKRelzIBSmWi506P0hY9uERRwWeJqxpj
	 JtUS7DTDC9okAGh/awJfuMcMBJo80N7Cf3Coczb6KtL8xq+SAQtoYVqfUu3nv1rV0u
	 IOWk7vmtGYGqSmZFxFmol3PYDXXl9w74Rr1IIgt9dM5/g0UTJfusXGaopRPtTuoXMD
	 39MSVS77NQUo0u6S6Y1Q897XAPLj0uFbJIX7KXAWRVcKG2zsPqjFhS7hNVKRDdLvEx
	 w6BcZEgrc6rJw==
Date: Wed, 5 Mar 2025 22:54:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] netfilter: nft_ct: Use __refcount_inc() for per-CPU
 nft_ct_pcpu_template.
Message-ID: <Z8jIJyB0KpTpZ-yK@calendula>
References: <20250217160242.kpk1dR3-@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250217160242.kpk1dR3-@linutronix.de>

On Mon, Feb 17, 2025 at 05:02:42PM +0100, Sebastian Andrzej Siewior wrote:
> nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
> locking. The refcounter is read and if its value is set to one then the
> refcounter is incremented and variable is used - otherwise it is already
> in use and left untouched.
> 
> Without per-CPU locking in local_bh_disable() on PREEMPT_RT the
> read-then-increment operation is not atomic and therefore racy.
> 
> This can be avoided by using unconditionally __refcount_inc() which will
> increment counter and return the old value as an atomic operation.
> In case the returned counter is not one, the variable is in use and we
> need to decrement counter. Otherwise we can use it.
> 
> Use __refcount_inc() instead of read and a conditional increment.

Applied nf.git, thanks and sorry for taking a while to collect this.
