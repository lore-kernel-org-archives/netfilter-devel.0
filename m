From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Wed, 24 May 2017 17:46:15 +0200
Message-ID: <20170524154615.GB32408@breakpoint.cc>
References: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
 <20170524154419.GA24697@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shyam Saini <mayhs11saini@gmail.com>,
        netfilter-devel@vger.kernel.org, arturo@debian.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45066 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1764198AbdEXPqX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 11:46:23 -0400
Content-Disposition: inline
In-Reply-To: <20170524154419.GA24697@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 24, 2017 at 06:01:51PM +0530, Shyam Saini wrote:
> > Add translation for cluster to nft
> 
> I think this should be:
> 
>         -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef
> 
> should be translated to:
> 
>         jhash ct original saddr mod 2 seed 0xdeadbeef eq 0
> 
> if --cluster-local-node is 2, then:
> 
>         jhash ct original saddr mod 2 seed 0xdeadbeef eq 1

Looks good.  But I think we need to take care of mangling pkttype as
well, right?

