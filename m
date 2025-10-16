Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F37263B
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 11:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760612507; cv=none; b=FDNquZugZTHJVPlFqS7JbX+NEV9BC3yDNNiO/uNp7RQbx0Pd8exhh8B9nyXiHmZQRyNZboLVSHyBrMt/+opCCJpQ9zjgXTFGn8P5/R1W07HZYRZe8ByPnN/QlW55UBW16eRUHIHB4Dql1Yy6TLg0J8C1XZBm20+dM1AraP91dIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760612507; c=relaxed/simple;
	bh=Y0s4QFE2JXKyn5DtQgScJAEAy9l+1vLyOt2UqDScYBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0rW7zU5fADkkA/cLtNxArLh4r50kTSqJKyr/EwD0CQH8v65NvxzosVweCs5D8bpQWTYwwX//Os9KyDu8TFfyTomqySM4gPpHw59/Sz15VVcbVRVboOHhXdOoGtTxNkCcmXZspOeA7fO7olVSGP5N8F7yYY8YC9euuh92g0s2XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C26DF60308; Thu, 16 Oct 2025 13:01:42 +0200 (CEST)
Date: Thu, 16 Oct 2025 13:01:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Introduce nftnl_parse_str_attr()
Message-ID: <aPDQljEef_EXGmFy@strlen.de>
References: <20251015202436.17486-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015202436.17486-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Wrap the common parsing of string attributes into a function. Apart from
> slightly reducing code size, this unifies callers in conditional freeing
> of the field in case it was set before (missing in twelve spots) and
> error checking for failing strdup()-calls (missing in four spots).
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/utils.h         |  3 +++
>  src/chain.c             | 33 +++++++++------------------------
>  src/expr/dynset.c       | 12 +++++-------
>  src/expr/flow_offload.c | 12 +++++-------
>  src/expr/log.c          | 13 ++++---------
>  src/expr/lookup.c       | 12 +++++-------
>  src/expr/objref.c       | 18 ++++++++----------
>  src/flowtable.c         | 24 ++++++++----------------
>  src/object.c            | 14 ++++++--------
>  src/rule.c              | 22 ++++++----------------
>  src/set.c               | 22 ++++++----------------
>  src/set_elem.c          | 38 +++++++++++++-------------------------
>  src/table.c             | 11 +++--------
>  src/trace.c             | 28 ++++++++++------------------
>  src/utils.c             | 15 +++++++++++++++
>  15 files changed, 106 insertions(+), 171 deletions(-)

Nice compaction.

Acked-by: Florian Westphal <fw@strlen.de>
