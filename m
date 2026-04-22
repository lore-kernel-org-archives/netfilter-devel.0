Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CBA19AD5C;
	Wed, 22 Apr 2026 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776865881; cv=none; b=lZiamxQaHowiCcYsiDYZ9KBtCPvRsfUb6GlmD0Ot11wtppwxJdi95HJk7gHaErl1jBCjupTl9elU6X2fnCBwbV92vGWfFdTSfXDyiQHQaGsTuReFBf1vcrIm4qFs5xrLP6HHDamDcrglwcjL+piXv15uk3NYblkZxRhhA1T+Qko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776865881; c=relaxed/simple;
	bh=TfUf5P/ZH414X6ziQV7zEfFP2CvK/Zx8bpWlZdkh0Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUNOVH3V0CkeAHs3G+hErXOx2ygVim5fs6Jjl/+V767pJtgaQOLwv2a5iR3FqxNW51kwK405Tn5Syw4of74bOvC02IsPuBkj3KvQvzzi4g68IBVRiOHst7p0acN3ktmpBHcWiLJtFiPXciycgtrRfPs7OrGdNa6L6qHrDyNno20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 57E6160890; Wed, 22 Apr 2026 15:51:10 +0200 (CEST)
Date: Wed, 22 Apr 2026 15:51:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Vastargazing <vebohr@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, shuah@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests: netfilter: add nft_ct timeout destroy
 race test
Message-ID: <aejSTa7PcHkaOs4C@strlen.de>
References: <20260422131818.106417-1-vebohr@gmail.com>
 <20260422131818.106417-2-vebohr@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422131818.106417-2-vebohr@gmail.com>

Vastargazing <vebohr@gmail.com> wrote:
> new file mode 100644

This should say '755', else you get

# Warning: file nft_ct_timeout_concurrency.sh is not executable

I'm not sure we should add regression tests for regression tests sake.
Else we'll quickly accumulate thousands of such scripts and test
run time will explode.

A functional test for timeout policies would be much more useful.
We have a few of those in nftables.git but they ony check that
userspace and kernel parsing sides work.
