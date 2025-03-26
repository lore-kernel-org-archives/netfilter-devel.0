Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A59225332E
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023929; cv=none; b=GjvioOZ/S/VbGuU6wHMvpauuxMrKeqaGa8Dx13BDZxqj8+h7GAesxMzKH1+zQOMsZ5g4hRAtnIVjExOc1J87thHtBetmLCyp72VmdswLx38evVlcm1erZrdc71MEeyXx9v34r+5V3MugYT5jVMzCMks5kr+2Ov62P1IbYrLzSxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023929; c=relaxed/simple;
	bh=Cokp8Ir4vMKQAE/tbGOZCkWah19q1JW/KBUQIt9Yq1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LXNqpUAInUMZHVi4ol4N4eVc0fmPpd+7pZ5JlJzBZkhdDIfGu1fN+gBkgAvOqCKh3NkFTlO555jdHu8zCYaY/RxYFpenBKJhlt9GMX/9AUxPlNNwSKnvlfDqnoDQZ1i/Ta/Y+7H4s3MJ8uxo3KVgNTnw7XOboJS8TdINAtBKkf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T4YlRZLm; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lGue/+OL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T4YlRZLm";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lGue/+OL"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C6E0060602; Wed, 26 Mar 2025 22:18:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023925;
	bh=JqPoPQ/QwLVwURos4c8/T+noZTlFnCF2aQsDZJ1vEHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T4YlRZLmbCBoQgVgPHt6HBHHqncztKsVQGFWjoZ35Mz9LOU50J1zi7koei1dAmnUj
	 UfSgWT921Oh7AxrTO8dMjRjUIf5GUS0uTjOK7UGDBTQhOuti3I9HWMibNmFfAIQCDO
	 K/285zxTD6PkvKq9eXCcAgOImYCfnWU0cwZM+dSE7TxmYvtFe3uQX8jNNqf/pDYGRy
	 B2uMF3wzA28jNjrgw+AFu4K8+j1UeOSU42efbuMGtBx1jIqjz+ptpTRyfZp3L8i5B5
	 oZgLeZ0k/K5yR7zDgmcv7wPP9YZjhOT5To6FToukpWMJL0JRKxw7bjJ89TEkBIHD9T
	 ltpu2IHLX2pzw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0F0BD605EA;
	Wed, 26 Mar 2025 22:18:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023924;
	bh=JqPoPQ/QwLVwURos4c8/T+noZTlFnCF2aQsDZJ1vEHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lGue/+OLj4yk27iBkD+YXpkJvn/Ozgdt+3x7IJKdXMbHTiwmBCX+tlaK+87AwYuZy
	 jl29H2xs2HOBTMz6mI+LIenVmFtr/yAMHdU3qTr7KKGnJwxHRo6rRD32Tb5NcIniyB
	 FqopnOCB+J1UylntMVuWLyeLq+47imuB1nG7VRAWX/mfRdB2E/3TWB63pyZXy/Mzrj
	 kf0Bqd1ctkNTf1wMOilG1mXTUeKpnIAEctkizRqpR4iXieKyzqsRIEbV6VxezebVKm
	 xU0GJK21Eyy6VeqI/4mcGBSXIrCZ6GdhOpxrv8fsfpXhYfFkWtuxf0ji1Ng3c2l+nD
	 OSMg3lYVsacAA==
Date: Wed, 26 Mar 2025 22:18:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next v3 0/3] Disable LEGACY iptables on PREEMPT_RT
Message-ID: <Z-RvMRHykucNvvdO@calendula>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
 <20250325194804.GA18860@breakpoint.cc>
 <20250326074721.Y1sIc4Al@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250326074721.Y1sIc4Al@linutronix.de>

Hi Sebastian,

On Wed, Mar 26, 2025 at 08:47:21AM +0100, Sebastian Andrzej Siewior wrote:
> On 2025-03-25 20:48:04 [+0100], Florian Westphal wrote:
> > I applied following diff on top of this series, after that
> > ./iptables-test.py -n
> > and
> > iptables/tests/shell/run-tests.sh
> > 
> > pass (legacy version fails as expected).
> > The change in xt_mark is awkward but its the only place that
> > needs it so its not worth to add a new kconfig symbol to avoid ||
> > test.
> 
> Thank you. I'm going to fold this into 1/3.

Unless Florian says otherwise, I suggest you collapse these three
patches in one, my initial patch 1/3 in this series is indeed very
much incomplete.

Thanks for catching up on this.
