Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE5E213E7A;
	Tue,  2 Sep 2025 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756816345; cv=none; b=QTZEKR2S62E1lnbPi1V4SrfJSqyzxclU991vCk5aE5Y/SsLU/gzWBLUua7YqAAMZWNY/2YMgDaqi80txe0T2MrwGZjZeOkNAjiKInqVwWNH47x4knsDLx4w5egWUl0DJB5thrQPUzEWZuDDoz52Efq4wKmyVbP1s7R0WMooqK1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756816345; c=relaxed/simple;
	bh=eQAdZ+NLRZ9XrY3caOR7K8Dw227PpScMR3T8gTOyt8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7V04glX/X2mKkf+9JO9Wp5ywSO6hLv1eYmI50t/apnirEd8Y5PMKCHGG+nR7XRjNeF+JyBXRe4FWv6VZIzlpx/pZCwCnB/l1i3wnkq65TcPb2MZ78kg1CJ7JC1eHYO2wuYZUzUUZ4f0Z7bzyuiXzR9xfEjTyoATY5J538R9Q3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 20556606DC; Tue,  2 Sep 2025 14:32:21 +0200 (CEST)
Date: Tue, 2 Sep 2025 14:32:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 nf-next 0/3] flow offload teardown when layer 2 roaming
Message-ID: <aLbj1IjZ1Lb37rYu@strlen.de>
References: <20250617070007.23812-1-ericwouds@gmail.com>
 <0452a9ce-72f4-41c1-b71a-a444d490fd97@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0452a9ce-72f4-41c1-b71a-a444d490fd97@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> > Changes in v3:
> > - static nf_flow_table_switchdev_nb.
> > 
> > Changes in v2:
> > - Unchanged, only tags RFC net-next to PATCH nf-next.
> > 
> > Eric Woudstra (3):
> >   netfilter: flow: Add bridge_vid member
> >   netfilter: nf_flow_table_core: teardown direct xmit when destination
> >     changed
> >   netfilter: nf_flow_table_ip: don't follow fastpath when marked
> >     teardown
> > 
> >  include/net/netfilter/nf_flow_table.h |  2 +
> >  net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++++++++++
> >  net/netfilter/nf_flow_table_ip.c      |  6 +++
> >  net/netfilter/nft_flow_offload.c      |  3 ++
> >  4 files changed, 77 insertions(+)
> > 
> 
> What is the status of this patch-set? Is it still being considered to be
> applied? Should I re-submit it? Anything I can do, please let me know.

Its marked as 'Changes Requested' in patchwork but I see no feedback
on patchwork or lore archives.

Pablo, do you have any objections to this patchset?

AFAICS this is ok and I'd apply this patchset.
