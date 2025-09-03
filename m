Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684E2E88B9
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756897883; cv=none; b=YbxqRUK7/msJ+UqfZTVVzZpFaPyFqxMuLTZLJTOENBsy4NmoA1k9LnSz5AJE8d3C18gWbds/IH80Pa/BXMRTQ+Ss/DILmunLYhMSsyPAHjQXRDZ6Sh4sHB4355RwOamq27RNzRsUUuKwLeKB6KBnzzIc7sgjx/UC4fuodufptEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756897883; c=relaxed/simple;
	bh=M9rMtN9Yj6DSJCjuW/ko2UeHVMiPylMvFFcUHzrO648=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSBZa8glKGMcCPgiv8scpVnx7FBqtyMhDH95NOh67CEDY9ySLP/wAjPWCyxtGTrT4NGbqz6qa1AbdWFgZgjXyC62gsGsU4vFfGp3PBrxwHqiuh2heKuQ19VNTFtsFLTh5IJIUNM1Seujr4uKeeaeRG1MpcDBBZY18s2Emfy8Ns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VmJpqCdA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VmJpqCdA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VmJpqCdA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VmJpqCdA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BA93B608AA; Wed,  3 Sep 2025 13:11:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756897878;
	bh=7tEUOF3CpcD1a0AEdExNvMZynrtvCDluS8Ydj9ypJV4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VmJpqCdAA/tt65n7kD02N+RbKZ3YHbw0rl4DKmeQz2f01Ouqc6mgZwG+YhUS7WhHi
	 kOJVR4H4vHFycRzoy9vJVESKHIOMW2KbRiW6dWY0cLBKwsCHY+199mY/VvLYhQdL3i
	 zuy468OklG+lBYIYX8sHtdm3o2YwCWGKRmiuSHrZfn6KfZqjD+6liTQ5G9JuR8mI7a
	 tFFZsTI3aoXWcAeqjkukKs3RaEA1dHprfmDmlD+Y4wzHShYL/o6Gw4QZQQrTBQ1s3C
	 a9gtFbV6iFj85nJ5Iou0CvktotSK1FWvxLjRciZKscogl9M8P8F48naz9uHjQ7llAG
	 Rw81kK3+7NpSQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 284546089D;
	Wed,  3 Sep 2025 13:11:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756897878;
	bh=7tEUOF3CpcD1a0AEdExNvMZynrtvCDluS8Ydj9ypJV4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VmJpqCdAA/tt65n7kD02N+RbKZ3YHbw0rl4DKmeQz2f01Ouqc6mgZwG+YhUS7WhHi
	 kOJVR4H4vHFycRzoy9vJVESKHIOMW2KbRiW6dWY0cLBKwsCHY+199mY/VvLYhQdL3i
	 zuy468OklG+lBYIYX8sHtdm3o2YwCWGKRmiuSHrZfn6KfZqjD+6liTQ5G9JuR8mI7a
	 tFFZsTI3aoXWcAeqjkukKs3RaEA1dHprfmDmlD+Y4wzHShYL/o6Gw4QZQQrTBQ1s3C
	 a9gtFbV6iFj85nJ5Iou0CvktotSK1FWvxLjRciZKscogl9M8P8F48naz9uHjQ7llAG
	 Rw81kK3+7NpSQ==
Date: Wed, 3 Sep 2025 13:11:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 7/7] Makefile: Enable support for 'make check'
Message-ID: <aLgiU3Pb2dLPxYK_@calendula>
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-8-phil@nwl.cc>
 <aLcDF_OEWQ5KmkZr@calendula>
 <aLghQ7G-fkdvOKLc@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLghQ7G-fkdvOKLc@orbyte.nwl.cc>

On Wed, Sep 03, 2025 at 01:06:43PM +0200, Phil Sutter wrote:
> On Tue, Sep 02, 2025 at 04:45:43PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 29, 2025 at 05:52:03PM +0200, Phil Sutter wrote:
> > > Add the various testsuite runners to TESTS variable and have make call
> > > them with RUN_FULL_TESTSUITE=1 env var.
> > 
> > Given you add a env var for every test, would you instead use
> > distcheck-hook: in Makefile.am to short circuit the test run and
> > display SKIPPED?
> 
> I don't follow, sorry. The RUN_FULL_TESTSUITE variable is merely used to
> enable "run all variants"-mode in test suites.

For make check, I think tests should be updated to run all variants by
default. Then provide options to run independent variants.

> Test suites are skipped only if they require root and caller is not
> - one may still run 'make check' as root or not, irrespective of the
> hack to leave 'make distcheck' alone.

Right, I call diskcheck as non-root.

Maybe we can just skip tests for non-root when make check is called.

If the tests are updated to run all variants by default, then
RUN_FULL_TESTSUITE is not needed.
