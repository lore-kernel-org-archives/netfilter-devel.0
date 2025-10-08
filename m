Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C02296BD6
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 10:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759919192; cv=none; b=EHHqTdFxsE8IjmED/f0CtGrA+IrgM6Lji0h6kQuH6AJHtz5cVbkmEZ6T8adDvWiVH6Ftlp9HVC0ddeUcM0AilGxXDOfe0UoFm0eB+/tm+coB9mKt4iI9dNK++xlaFawbcuDQ+9oNohYXQP7uwCtjb1E+HCEL1+5u9arMtt9gygY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759919192; c=relaxed/simple;
	bh=3x1vLygmkWuUPTPy+0ycm9e4KmMxN3DN1Bjl3cGCp/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyE/W8wxNsWPTUn2/hEow0h7tBmsnKpfHLhSbcAI13s4B9q1U/oKgdurFfTkujiV68DA9tYk9KbDSwoD0gjvvl8uF8x+6rarrbhDFQYMofHkXz6l6DjQi05tQYbKdw39Lo620z7r6KJ84U2K3xorksyxTyE4ylxERA4ZHXv2wpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 575D9602F8; Wed,  8 Oct 2025 12:26:27 +0200 (CEST)
Date: Wed, 8 Oct 2025 12:26:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Subject: Re: [PATCH v3] selftests: netfilter: add nfnetlink ACK handling tests
Message-ID: <aOY8UolnTfclgU40@strlen.de>
References: <aOJZn0TLARyv5Ocj@strlen.de>
 <20251005125439.827945-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005125439.827945-1-nickgarlis@gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> Add nfnetlink selftests to validate the ACKs sent after a batch
> message. These tests verify that:
> 
>   - ACKs are always received in order.
>   - Module loading does not affect the responses.
>   - The number of ACKs matches the number of requests, unless a
>     fatal error occurs.

I will keep this on hold while the discussion wrt. ACK flag on
batches is ongoing.

Also, checkpatch.pl reports:

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#59: FILE: tools/testing/selftests/net/netfilter/nfnetlink.c:1:

... and a few other nits that should be resolved too.
