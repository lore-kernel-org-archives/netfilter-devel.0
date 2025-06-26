Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3065D1CFBA
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750939731; cv=none; b=o+ajqAdD/jBpYyuOCAI0SbHTxr+qf3C+Ni8hOg9lyIEKSE4KbjvA80vCGwkDsR27rBhjKb/jaT7bfmyZM6i58OnseZ410tNT7/n6I9q27q7wmuM1on9AwnYjCKXH+Ulqal3Qex9UdV/mJer1fCgEOuYULz87T5DV2w7BjHGccvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750939731; c=relaxed/simple;
	bh=sZnDs7woGHo0zPbUHGMv9QaPbtQF1pNDqpXezEv9JmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tx46P4t1p/UhbjJ94iuLpaW9urBgO02DvsSCVASfNoGSzbggbApPrmPqyuIwL3d+dIcw+nKEEw8VLv+Cm0qSkF/EdyaAvlltdo7vzPNba/VbLgm3jHaiaoV12vTGqnazuTkUySBfrubHrfYsjTTf8Q15jiMsY+qp9Gy3aFCPx+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 87EFA6146D; Thu, 26 Jun 2025 14:08:44 +0200 (CEST)
Date: Thu, 26 Jun 2025 14:08:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix ifname_based_hooks feature check
Message-ID: <aF04Q2ppk70lssKl@strlen.de>
References: <20250625165336.26654-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625165336.26654-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Fix this by detecting whether a netdev-family chain may be added despite
> specifying a non-existent interface to hook into. Keep the old check
> around with a better name, although unused for now.

Thanks, this makes shell tests pass on fedora 42 again, so I pushed it
out.
