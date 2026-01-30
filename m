Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D96123EAA1
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 12:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769776506; cv=none; b=ic7mL/oD3SGAhOOMaU4jV5kx6xW8c6lq3ZNDuyxTavCuzcolVSKsRmrjn5dO4+QW2LmbXRu+8i8e0R7pBO1pM6kES0x0jgbQ+30adkvr7r/8TvL3sUWORHL6r++FQsiWcxy04ZVJFHCoTE8RA4my522Py1ZH95ZiWPvVT30BSdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769776506; c=relaxed/simple;
	bh=Qsz4EnxRkBzPjoRSI9mG/UHVlQsJRx6mXRMI9d0rX3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eidLIPottmtDPNnOM8z+wqPUONX+eYtFmReFb4wb+wUiUIIdve6+rG+mqPy34vxb9If2RyqsAu+//0I36+Mgb9pSk8ZUkcZusd/9jbG7buVlPcUYKZgEQV/k/iAdYhg99xA09sB5rcCR5EdKq00nEWrM6vufbF+ptzGc1ENADWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AB7C5602B6; Fri, 30 Jan 2026 13:35:02 +0100 (CET)
Date: Fri, 30 Jan 2026 13:34:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/4] netfilter: nft_set_rbtree: validate open
 interval overlap
Message-ID: <aXylcZ53xTI3Gp4Q@strlen.de>
References: <20260128014251.754512-1-pablo@netfilter.org>
 <20260128014251.754512-5-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128014251.754512-5-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Open intervals do not have an end element, in particular an open
> interval at the end of the set is hard to validate because of it is
> lacking the end element, and interval validation relies on such end
> element to perform the checks.
> 
> This patch adds a new flag field to struct nft_set_elem, this is not an
> issue because this is a temporary object that is allocated in the stack
> from the insert/deactivate path. This flag field is used to specify that
> this is the last element in this add/delete command.
> 
> The last flag is used, in combination with the start element cookie, to
> check if there is a partial overlap, eg.
> 
>    Already exists:   255.255.255.0-255.255.255.254
>    Add interval:     255.255.255.0-255.255.255.255
>                      ~~~~~~~~~~~~~
>              start element overlap
> 
> Basically, the idea is to check for an existing end element in the set
> if there is an overlap with an existing start element.

This patch causes:
W: [FAILED]     1/1 tests/shell/testcases/maps/named_limits

It passes without this patch.
I pushed a minor change to the test to ease debugging, failing command
is:

FAIL: Command add saddr6limit { c01a::/64 : "tarpit-bps" } failed

and the map is:
        map saddr6limit {
                typeof ip6 saddr : limit
                flags interval
                elements = { dead::beef-dead::1:aced : "tarpit-pps",
                             fee1::dead : "tarpit-pps" }
        }

I don't think this should fail?
