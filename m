Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D8C45A2B9
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440454; cv=none; b=KLIOupiyuzV+DsqDMZkNBJMsLS3Ymsz3GVqykHpljcNBGpuTncoX0Q02IQX1uOJ22EjtWe8+/V7s3W+2JLB1lQjV07m185aTdCh5wrXqfNEefAXua7KQPEEY2IY7s17Iv8yrAZbCuYWiSYP2dz+TRrfrSK4GeI1eRQUVuTUW/r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440454; c=relaxed/simple;
	bh=BwNbRENfbkXG+Qnk6baBXxGMGoNmgfEm1qkSh1LBa7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bY35hCmZfH91Bgq6fJyP+yye5wXUKny6b6crapyJ+qwrBKEoOMvmt0IYDx/3D2d0vIDCGRYGpquOSZMXIyeFnlNp470plmFOIbtkrFETfL0K/ecKAGbRPFdlyrRZ4DdS1KEcpCldIEkTNadwSNHhy/b3YOro/8UueNEEEHs1JDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jqWYd3ar; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jqWYd3ar"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g6ndbZdJ8o4iGrfmTO46l1Wnc84Lv0RWumt8Z1h5L6c=; b=jqWYd3arW5l4Af+DtHb/m5XU0o
	ScdUs/dqhjCDO7SHzOrw6RbTC+7DPNhPRgKGm3xbvo/utLyH/JRRLUGDHCihtgvOo4o32FseQZhPp
	fL0ZKXOmAXc+6sIZZK5JnO4NRBDDbKYt/QR0vqD13+T5298LO5lxhHAxWxcTErmp7ssbUcYnK3cyz
	EdFPpgAxCiiF1GlWezGK9YpV8ptxXlGH912NPMFWJhrDJ6rNXaxJvhZnjLUc0fAIOZSH9O2j8TRAo
	DB75Ksf1kJ/3UhSNoH6Htb50GGVmCqz4bxEVRhw4cnQfNEiaHID5Y9RPRwRVmshMm9iflbamwDJhQ
	8uMtiGug==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x273V-000000003Kk-3VqX;
	Thu, 03 Sep 2026 15:00:37 +0200
Date: Thu, 3 Sep 2026 15:00:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH v2] conntrack.8: Document --stats counters
Message-ID: <aplvdbHQAkxjOiiT@orbyte.nwl.cc>
References: <20260730091858.1982235-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730091858.1982235-1-phil@nwl.cc>

Hi Florian,

On Thu, Jul 30, 2026 at 11:18:24AM +0200, Phil Sutter wrote:
> Provide a brief description of each counter's meaning based on
> code-analysis in kernel's nf_conntrack_core.c and feedback from
> netfilter-devel list.

Are these now good enough to be pushed out? Could you please review to
make sure the description matches what they're intended to count? Fixing
them up in kernel code is a separate task IMO (although I have prepared
a patch already).

Thanks, Phil

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Update descriptions as per feedback from Florian
> ---
>  conntrack.8 | 42 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/conntrack.8 b/conntrack.8
> index 2bfd80e5d6aa4..bc78c4823881c 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -108,7 +108,47 @@ Flush the whole given table
>  Show the table counter.
>  .TP
>  .BI "-S, --stats "
> -Show the in-kernel connection tracking system statistics.
> +Show the in-kernel connection tracking system statistics. The returned values
> +for each CPU are:
> +.RS
> +.TP
> +.B found
> +Number of times a tuple was already found and had to be adjusted  when setting
> +up a new NAT mapping.
> +.TP
> +.B invalid
> +Number of invalid (e.g., malformed or non-IP) packets encountered.
> +.TP
> +.B insert
> +Number of conntrack entries manually inserted (via netlink or eBPF).
> +.TP
> +.B insert_failed
> +Number of new connections dropped because of unresolvable clashes with existing
> +entries.
> +.TP
> +.B drop
> +Number of packets dropped due to memory pressure.
> +.TP
> +.B early_drop
> +Number of connections dropped in an attempt to recover from a full conntrack
> +table.
> +.TP
> +.B error
> +Number of invalid ICMP/ICMPv6 packets received.
> +.TP
> +.B search_restart
> +Number of table lookups which had to be restarted. In rare cases a lookup may
> +encounter an already deleted entry which causes a search restart.
> +.TP
> +.B clash_resolve
> +Number of entry insert clashes resolved. These happen frequently with DNS
> +traffic and thus not neccessarily indicate a problem.
> +.TP
> +.B chaintoolong
> +Number of oversized hash bucket encounters upon inserting a new conntrack
> +entry. This is a fatal problem for conntrack and it will drop the packet as a
> +consequence.
> +.RE
>  .TP
>  .BI "-R, --load-file "
>  Load entries from a given file. To read from stdin, "\-" should be specified.
> -- 
> 2.54.0
> 
> 
> 
