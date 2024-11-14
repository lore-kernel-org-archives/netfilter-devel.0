Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEBB18B49F
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 11:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731584092; cv=none; b=ALB+AUOvzPt9NBCfirnusOkyz1lXdQKuOH47ChufXgU2pWg7Z0UJM9R9NQCeS47Nhwo2t3hRBOI0GCkfyh6RWO9Ve1ZKZfaCvhxE6bKvVoTy+Gzw4HZ+QfxYUGkVaWrPgTdrUZ+JZf1fd4i1tw8yA3txC//a2AAfIjL51GRfJls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731584092; c=relaxed/simple;
	bh=NdSndsB5AGN4QjVFIXMH99uDxQ5nPg1kbuTmAtiuSd8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GEgbnidYH2wRhcP3YaAtpmP9wxCBFBZt8w5B9zBIGbqIxD0IQ/q/QZUeyhoiN0gAY4bwrVnjhSrKtPXgEXFEFQ6YrPcqNPdQQNn3uaXK3B8owMnWsBI6x4laEGgUlfoT16SFFxIVn3lWwW+jLH0CoY5aXjbZNcuJGtxxP72X+Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tBY7V-0006iY-I7
	for netfilter-devel@vger.kernel.org; Thu, 14 Nov 2024 12:34:41 +0100
Date: Thu, 14 Nov 2024 12:34:41 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: nft set statistics/info
Message-ID: <20241114113441.GA25382@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

Hello,

nftables hides set details from userspace, in particular,
the backend that is used to store set elements.

For debugging it would be good to export the chosen
backend to userspace.

Another item i'd like to export is set->nelems counter.

Before I start working on this, how should that look like?

Option 1 is to just include two exta attributes in nf_tables_fill_set().

We could restrict it to nft --debug=netlink so the information isn't
shown by nftables but by libnftnl.

Option 2 is to add a new type of GET request that only dumps
such extra set info.  Frontend could then support something like

nft get setinfo inet mytable set3

which would dump the set backend name and the set->nelems counter.

Yet another option would be to include the info in normal
list ruleset/list sets etc, but print it just like a comment, e.g.

 nft list ruleset
table inet t {
        set s1 {
                type ipv4_addr			# nft_rbtree_lookup
                flags interval
                elements = { 10.0.0.0-11.0.0.0, 172.16.0.0/16 }
		# nelems 4
        }


Whats your take on this?
