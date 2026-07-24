Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE16421232
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2026 10:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889150; cv=none; b=bdHC2uhTs3DOFhg9RmGWlXzKrF8so1dQfs2ekfWhzv4O94oDpW8d3SC5bUE5MB0j37dca8PMB/O/JlphO0AVX2NvgP7ZAKSFBY/xTZ8tq7/+0XAz+NzuWFOm424UGzXAv99VNu1P2hG8dg5FW9u+f0H317d1IQJht9SltRaG4vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889150; c=relaxed/simple;
	bh=C2s4hWpxdNAVzAqqOlmCGxT43Y3j275YinDQYrlxfyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fua8i4LIoZGdaeVI2m35vn2kQ43QXoiXrVBzke2qx/ustqvuuvHraRlCv/R1dBkAFyR3ym82J/nzB8s5eN/zgWbwRByCURKC9dJy3K4gI5XwYnZjBXDZ8gtla2NjFQxwe6b972rsVm8dsKk6KKY3E5BWRrpLLZF/J/IVv0U1C4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b/UmY5GC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b/UmY5GC"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BD20060194;
	Fri, 24 Jul 2026 12:32:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784889136;
	bh=sjKWk5DPmbrJN6C+y0YdcTWPDVOXuKNsqoKr98C7x0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b/UmY5GCc98BBea4sQ43ek0RP9w0lvEruSMvAzW3y8XBdLwzAQm/m8rJxKZTyxYpw
	 s4ytqJrOpMZATj/AvpwgwBIVEZzZkq4IQn4ETZlcf1i31MAbdvznyx2sobO4gZpQhl
	 LxX1ysPkJ+kdXGx55hJrwef2kTDJmtzxNFpMr3p8tAnb+0xekovYRW8jRurIAJXwWL
	 d77wca+OsIlph9J6nUiIQiwVIREggHwcqWS6MWV1V0GxHdJGFVHr6lqE4W8vFyyhmh
	 1thGq0DocgjmXikmtRDqaR5ARpb0Hhvu71VCyQ9vecvqjy0FO+b2udvdt2pZlCXHtZ
	 nrOfLCVZbrgBw==
Date: Fri, 24 Jul 2026 12:32:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 0/4] Address Sashiko review of NAT hook dump
 code
Message-ID: <amM_LjFL83jCngtg@chamomile>
References: <20260710151411.2358773-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260710151411.2358773-1-phil@nwl.cc>

Hi Phil,

I think we have to tackle this from a different angle the
nfnl_hook_dump_nat() dump issues, see:

static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
                              struct netlink_callback *cb,
                              const struct nf_hook_ops *ops, int family)
...

        if ((e && i >= e->num_hook_entries) ||
            ctx->natv != (unsigned long)e) {
                cb->seq++;
                return -EINTR;
        }

Because as sashiko reports, memory address could be recycled to defeat
this which is unlikely, but correct.

Instead of making heuristics to detect if interference has happened,
I think there is a need for something like a hook_base_seq per-netns
that can be used:

        cb->seq = READ_ONCE(...hook_base_seq);

which should be bumped when updating the hook arrays via WRITE_ONCE().

Then, a call at the end of the dump:

        nl_dump_check_consistent(cb, nlmsg_hdr(skb));

will set on NLM_F_DUMP_INTR flag so userspace can retry.

I would suggest to check that i is safe to access the array, ie.

        if (i >= e->num_hook_entries)
                goto out;

and perform the netlink dump even if it will result in a stale dump,
which is what other subsystems do, ie. just add a safety check here.

We can discuss later on how to make improvements to the netlink dump
logic to detect an interference early.

Thanks.

On Fri, Jul 10, 2026 at 05:14:07PM +0200, Phil Sutter wrote:
> Changes since v2:
> - Drop patch 1 again. Fixing nfnl_hook_dump's broken NLM_F_DUMP_INTR
>   flag setting in corner-cases is out of scope of this series and should
>   be solved in a more elegant way in nfnetlink itself.
> Changes since v1:
> - New patch 1
> - Fixed three aspects of patch 3
> - Fixed two issues of patch 5
> 
> Patch 1 is mere preparation to add the missing case handling to
> nfnl_hook_dump_nat().
> 
> Patch 2 fixes for missing READ_ONCE() calls when addressing hook ops
> array elements.
> 
> Patch 3 adds missing multipart dump support to nfnl_hook_dump_nat.
> 
> Patch 4 adds code to detect and mitigate concurrent hook updates while
> amidst a multipart dump to nfnl_hook_dump_nat.
> 
> Link: https://sashiko.dev/#/patchset/20260702105003.13550-2-fw%40strlen.de
> 
> Phil Sutter (4):
>   netfilter: nfnetlink_hook: Pass cb object to nfnl_hook_dump_nat()
>   netfilter: nfnetlink_hook: Address hook ops using READ_ONCE()
>   netfilter: nfnetlink_hook: Handle multipart NAT hook dumps
>   netfilter: nfnetlink_hook: Fix for concurrent NAT hooks dump and
>     change
> 
>  net/netfilter/nfnetlink_hook.c | 48 ++++++++++++++++++++++++----------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> -- 
> 2.54.0
> 
