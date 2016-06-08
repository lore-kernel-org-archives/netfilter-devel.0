From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 libnftnl] Check all strdup
Date: Wed, 8 Jun 2016 13:37:41 +0200
Message-ID: <20160608113741.GA13163@breakpoint.cc>
References: <1464689312-8136-1-git-send-email-carlosfg@riseup.net>
 <20160607150810.GA17951@salvia>
 <20160608110701.GA919@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Falgueras =?iso-8859-15?Q?Garc=EDa?= <carlosfg@riseup.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59121 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613AbcFHLhr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 07:37:47 -0400
Content-Disposition: inline
In-Reply-To: <20160608110701.GA919@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +	if (attr > NFTNL_CHAIN_MAX) {
> +		errno = -EOPNOTSUPP;

The negation should be dropped.
