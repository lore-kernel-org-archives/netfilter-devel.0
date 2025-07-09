Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353CF111A8
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 20:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752091849; cv=none; b=cNDK2ReTJHebu9UehKJeR0QpOgnMWEkpqkNHnfUnFFLrj7N5knxrjtBMz2RzMgFLSWjryvtfY0i4y5nvTuuqwUr875nMp6Fwzap68TPAi3xhCG2cW3EKzbHjepMR55kXzvW7+YrhLbt48jKOO0uefNDkI+PSvTRvktPUu4/IeU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752091849; c=relaxed/simple;
	bh=FfymprTAkJuRlGuZHI9UJ1ycT8ydia0sB1MkVo7VyIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g35wyBGg8McKljLF/kZU3Xxi99LSux/nWnEI7XI9qxUyFGztWk00tkeGNqJ8UsLM2qaAOJ/Msv4cPpOdcy8j+Sv6eBm97sEF9zs0HLdueKotZCvYEfcrDmAtIbJYeq0ida0lFXy2caD9cmUKsS0ceLSAWgKOteLJAP1OLnjSN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BDEBE607AC; Wed,  9 Jul 2025 22:10:44 +0200 (CEST)
Date: Wed, 9 Jul 2025 22:10:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Xavier Claude <contact@xavierclaude.be>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] Typo in contrackd-conf manpage
Message-ID: <aG7MxJpZsKsKEwjo@strlen.de>
References: <3365321.aeNJFYEL58@kashyyk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3365321.aeNJFYEL58@kashyyk>

Xavier Claude <contact@xavierclaude.be> wrote:
> Hello,
> 
> I've found a few typos in the conntrackd.conf.5 manpage.
> I hope it's the right mailing list for this kind of  report.

It is.  I've applied the patch manually, as it was corrupted somewhere
in the path.  Even patchwork only has a garbled copy, half of the patch
is taked as part of commit message and several long lines have been
broken:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/3365321.aeNJFYEL58@kashyyk/

Next time, please send the patch to yourself and make sure you can apply
it via 'git am' first.

Thanks.
