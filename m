Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A56BFCE
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 14:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090384; cv=none; b=MwK2qMMujwc6YvKeuE7Oph1238ToMpVwKIiLR63l025DCbMneKSbSZz31FZa1rV0PkEowaw9EN7NJyun4PCvu7SZkf7EaxfapeU6P+BYGsgm3XFm3IoODwodUHCelM5d8l1JbZLkKQcMbl6kODLH2630rKxSPEXr+EPpIBASpw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090384; c=relaxed/simple;
	bh=38ONMHZin6AGukIFxXmEGOlhxnenE8QJ7jdXj/gi3Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1RUzP47ULBg0QCfVcWkMxVUv1ChiR92FH58rI3okEocCe23I7Se07S6+jVgAWI7eUOjl2+anwdPvPb0JXQa4I412z4ekd7dcLh9FtG0Q9UzRkYmqLDD275Wb1Gyv0y5zV2USebgHxvCc9QEzpuuT14GID4d9bkSB86PrAbuJvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D327660966; Mon, 13 Apr 2026 16:26:19 +0200 (CEST)
Date: Mon, 13 Apr 2026 16:26:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Vladimir Vdovin <deliran@verdict.gg>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	coreteam@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: make number of hash
 slots configurable
Message-ID: <adz9CyDXi2wSwvjM@strlen.de>
References: <20260413123712.42993-1-deliran@verdict.gg>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413123712.42993-1-deliran@verdict.gg>

Vladimir Vdovin <deliran@verdict.gg> wrote:
> Some workloads with high conntrack rate
> generate high lock contention on insert_tree(), so
> constant 256 CONNCOUNT_SLOTS can be too small.

No.  Compile time options suck.  No distro is going
to alter the value away from the default.

Maybe change the code to size the array dynamically
based on e.g. number of online cpus?
