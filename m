Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163D812F586
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824209; cv=none; b=YexR1mXS2VUwPP0HQxjUKyXvgifHi2K5NZvDGCsYTCFHCQMc3AWJL1mHvHwzpwkYQlgmeb/GNrBfpnpR1iu0sPjZOSZyfYIHN3UIKFFqPMbXapxSwE0vZMYJrtyUOiZplkhUZP50gRn2YGu6eavSBtOWbxxQlJnXD1aYmm5bSz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824209; c=relaxed/simple;
	bh=M5lLDR0b55oHuHEb19W6WObkm+YloCUwPjNiOlAb0fA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYJhCJIUWzYzj+8MJz+BT2UXTl7hYhXawb4klr1aBxGJqcwwzB1IhElOMszapnc/79tT+HGNXKk5FZGpSfYwleWHVSmYoe/fZnrhD4YHyEpDB9ZpPBKj7YhvGYYgCZG7U4liMePRTmY8nMSw8otA08EeGyJ1IRfw3XbW1LkLpqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riFNl-0008AR-9G; Thu, 07 Mar 2024 16:10:05 +0100
Date: Thu, 7 Mar 2024 16:10:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/5] parser_json: move list_add into json_parse_cmd
Message-ID: <20240307151005.GM4420@breakpoint.cc>
References: <20240307122640.29507-1-fw@strlen.de>
 <20240307122640.29507-3-fw@strlen.de>
 <ZenP32bq9xtJglJQ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZenP32bq9xtJglJQ@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > Problem is that the json input parser does cmd_add at the earliest opportunity.
> > 
> > For a simple input file defining a table, set, set element and chain, we get
> > following transaction:
> >  * add table
> >  * add set
> >  * add setelem
> >  * add chain
> > 
> > This is rejected by the kernel, because the set element references a chain
> > that does (not yet) exist.
> > 
> > Normal input parser only allocates a CMD_ADD request for the table.
> > 
> > Rest of the transactional commands are created much later, via nft_cmd_expand(),
> > which walks "struct table" and then creates the needed CMD_ADD for the objects
> > owned by that table.
> 
> JSON parser simply does not support nested syntax, like, for instance:

You mean, WONTFIX? Fine with me.
