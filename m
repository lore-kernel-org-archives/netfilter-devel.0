Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0198179CD
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764342944; cv=none; b=o0ae+2zhghqAT3WE5p23AcRXch6IvYSkAbmnamUWp0SQwe2z8OboWfew8ZzYacsx1U/GjRPoN+HQQIokShiNhc9wxvD3sa3Q7gd6c0L+mceC7d4Y6lDLPGsDQycEzC7SpvX3TsMihx2tz9DQIdYbT06Save1mcR/ER9hmASVrtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764342944; c=relaxed/simple;
	bh=q86eHBzNnKgxCEx3o1czrE+mHjOtdamU8iutLFtni54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgvAP9McWEjEZDUVBKspCiSn1omUt4soUD0fLdjXZp29DdYQrjWgYbqUZz+5T6CtxPqGducwjmgUZRHBUOehmWB4V3Wa1fanSeorus1S7fmbWFo/DzuIKZgdSiC3O1GXokGwSCrjzotwl7h3UUnrZgNxuW+S88alt6RYEore30I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2650060308; Fri, 28 Nov 2025 16:15:40 +0100 (CET)
Date: Fri, 28 Nov 2025 16:15:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 4/6] parser_bison: Introduce tokens for log levels
Message-ID: <aSm8nU2vpSYvt0ME@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-5-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126151346.1132-5-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Since log statement is scoped already, it's just a matter of declaring
> the tokens in that scope and using them. This eliminates the redundant
> copy of log level string parsing in parser_bison.y - the remaining one,
> namely log_level_parse() in statement.c is used by JSON parser.

Reviewed-by: Florian Westphal <fw@strlen.de>
