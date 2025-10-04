Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8270919B5A7
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759580795; cv=none; b=s2fjkrfT4XgEcrzJ7QX/0w+tGrGFRXPIaEhjlqXdKmJ+wRcWRMn5hwhXzas8iLzJ9Jf7jYBAxpcQ+QAHmW1wE9Z036rTXdSRFCRW4XwPUItUldIBXNmdlZLu/0kZhQ/o8g9vaabwHE43HMKIdiWtPhxfmrcM36uUtrTuN+vpNnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759580795; c=relaxed/simple;
	bh=vVwfjzj1/SkP7WRq2a0x9tllg84SJiLDa/qc1+fCFQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXhFXU6m5jZLlXAW8BNnowg37VmDSdbEgDYjrFFakj9mrmCI4/OKzEwsdq6jAf22DwnK7xOMvqoT/mJ+ySaYXtg6dVB+x+casjAwns/yWEHC9v/pdJjxnXs4I8D/xj73YLAKm1Ew3pKi1ImNu55knlXYWsx3D5QvHu1hk1HznoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5350F60326; Sat,  4 Oct 2025 14:26:30 +0200 (CEST)
Date: Sat, 4 Oct 2025 14:26:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Subject: Re: [PATCH v2 2/2] selftests: netfilter: add nfnetlink ACK handling
 tests
Message-ID: <aOEScmNyuP_k_YsU@strlen.de>
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
 <20251004092655.237888-1-nickgarlis@gmail.com>
 <20251004092655.237888-3-nickgarlis@gmail.com>
 <aOD7IaLqduE9k0om@strlen.de>
 <CA+jwDR=0riXXHig1wcq4BjbGDUngksrUTxdgJgD4S8PUqAvO=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+jwDR=0riXXHig1wcq4BjbGDUngksrUTxdgJgD4S8PUqAvO=A@mail.gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Can you drop the shell wrapper and just call unshare(CLONE_NEWNET) from the
> > fixture setup function?
> 
> Yes, I can do that. However, I am wondering about cleanup both
> before and after the tests, as well as ensuring that the nft_ct
> module is not loaded prior to execution.

Is this to exercise replay path?
Perhaps add a comment to the subtest that depends on this.

I don't see the need for this otherwise.

What happens when nft_ct is builtin?  The test should not fail
in that case.

> Should these steps be
> included in the program, or do we assume that the tests will
> always run on a clean system with no modules already loaded?

No, if you need nft_ct to not be loaded then the rmmod has to
be used, but there is no guarantee it will work, e.g. because
nft_ct is builtin or because its in use.
