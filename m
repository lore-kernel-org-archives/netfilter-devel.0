Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC9F425CD9
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217576; cv=none; b=NXIKv1iYHWKc36NTSJKrfXAWy2Zg/jrv5icC9Xsj0V2kDsgGHEIQ/w4jsEUD37ZgXgNcofcc41vv3m6A5zNuMS6M8lmgU0wZUnKgDXb2RgeIJi3agTEYqtBq1u9daGiGuwO5y2XUtpbr52IQAZuaZ3PHN2dEo091vUjW2dOexHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217576; c=relaxed/simple;
	bh=JgLaK1tcCXmrtPJKcF9BMrUBdVPil6YAR1Xo0P/h+I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxs3LEpH9idJ8XOFK9TZ3hlrfCR0F8RGahxT6r08gFxbF+7BNOkKPuNj8RO3lNp7OytW9ESjC9QkWcGYgFODPqdX+K4yM+Ul5Ou9H5J6l3CT7Ux9wa4C9bKCLG7ibmf6GNyeIK1/eZaqmrBQOj/f0I5HaHkw97ETowQ/JAosirU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 322E96033F; Wed, 04 Feb 2026 16:06:08 +0100 (CET)
Date: Wed, 4 Feb 2026 16:06:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] test: shell: run-test.sh: introduce NFT_TEST_EXCLUDES
Message-ID: <aYNgX-nh04sAQdU8@strlen.de>
References: <20260204144940.63422-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204144940.63422-1-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
> Introduce the NFT_TEST_EXCLUDES environment variable to allow excluding
> one or more specific test cases.
> This is useful for some releases where certain tests are not yet supported.
> allowing them to be skipped directly in the test script
> without modifying the run-test.sh itself.

Wouldn't it make more sense to add a feature test for those?
Or is this about test cases that fail because of a real bug that
where the fix wasn't backported yet?
