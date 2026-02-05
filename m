Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B8F2765D7
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770257432; cv=none; b=nDSgWxElKi1Fr+JEHVsDu1pETM+eB6vvQq3lHRtBdO3T+BT64x7PY+ed8thv3R7eJW0XzzfA+Gr/kDMmXRhbyq+IIwvjWtGs75WK2fpY8ULcRrZcY07zBVEZZIudKogu6bLNQX7Cb+4htJTFLZx7aVVfUdR0pdsV+0ScMW67vgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770257432; c=relaxed/simple;
	bh=Mi6TqFE7aORrdGRLbiuUv4EncCHs45NYZ+mDxtCY/gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXJPaIKfY1mULu7odxyYUdPAYnbncsKpmcZmhg3UMkmsXDuYBQ4KksUiSQQphB5p0lbR/RVbwIXfFG8LByAGgC6pZ7RZumP598ysGWN1ZdDxk75JrgVvu2WFUMQqXXRdi9tq88CnCfuaVuU7ocEDxj1gMUizB7umAicjEClsX9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 41D546033F; Thu, 05 Feb 2026 03:10:29 +0100 (CET)
Date: Thu, 5 Feb 2026 03:10:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] test: shell: run-test.sh: introduce NFT_TEST_EXCLUDES
Message-ID: <aYP8ELzFrWADndpT@strlen.de>
References: <20260204144940.63422-1-yiche@redhat.com>
 <aYNgX-nh04sAQdU8@strlen.de>
 <CAJsUoE03i1S6QmnSC++Qijh-q3J+QXdHek=j6E46R7+8-oZ7=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsUoE03i1S6QmnSC++Qijh-q3J+QXdHek=j6E46R7+8-oZ7=w@mail.gmail.com>

Yi Chen <yiche@redhat.com> wrote:
> Some patches may be considered too aggressive to backport to
> downstream releases.
> 
> For example:
> netfilter: nf_reject: don't reply to ICMP error messages
>
> When this patch is missing,
> tests/shell/testcases/packetpath/reject_loopback reports a failure.

Right, that makes sense.

> In addition, introducing this exclude feature makes it easier for
> downstream streams to run this test suite while excluding known SKIP
> items.
> This also helps to quickly detect newly introduced SKIP items, which
> may indicate new bugs.

All good reasons, I'll place this in the commit message before applying.

Thanks!
