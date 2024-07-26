Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FBCA2A;
	Fri, 26 Jul 2024 01:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721956600; cv=none; b=uYg+IfWgiNyV8hWGX/qB4+jgSngUJGBFsN4j+SHy5uinDLeZoZGKttKzlTmpSJy1iKchhMsVGrcGqVD8AUGxc/bWGs8iJEbaOL7SBKGhuHrJ/QEahOODgTd6QbbaDITRatDTxGUnazPkbjaLGL/V/DwynfucrR+ydEzMdzpXo2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721956600; c=relaxed/simple;
	bh=KXNpTpbMgAzzbzLCBBI04qIrGFaCJwDwbrjLdGh4Kfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u52Ez+S7cyc8uyixkzWy5eIsGd9QG+CwuDN5+t29CujqGk3f/b5SLnqWkKhTXuuAtDA/i88XoqbtuurX5bhZ++kiefUL4S3XUcbki4C5DIpMS1WHa2SDt2h3D1CLuuhzYSWp9FITY39sipuct6v6URbIUobE3KBrzSfkhGcBozs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sX9ZS-00042J-D0; Fri, 26 Jul 2024 03:16:34 +0200
Date: Fri, 26 Jul 2024 03:16:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Kuniyuki Iwashima <kuni1840@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v1 nf 0/2] netfilter: iptables: Fix null-ptr-deref in
 ip6?table_nat_table_init().
Message-ID: <20240726011634.GA15148@breakpoint.cc>
References: <20240725192822.4478-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725192822.4478-1-kuniyu@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> We had a report that iptables-restore sometimes triggered null-ptr-deref
> at boot time.
> 
> The problem is that iptable_nat_table_init() is exposed to user space too
> early and accesses net->gen->ptr[iptable_nat_net_ops.id] before allocated.

Right, the other xtables don't have a pernet id, but nat needs this
because of the nf_nat_core -> iptable_nat dependency.

Reviewed-by: Florian Westphal <fw@strlen.de>
