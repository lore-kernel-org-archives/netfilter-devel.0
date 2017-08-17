From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] tests: add test case for ttl/protocol set
Date: Thu, 17 Aug 2017 12:01:17 +0200
Message-ID: <20170817100117.GB6928@salvia>
References: <20170816170156.11594-1-fw@strlen.de>
 <20170816170156.11594-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:47239 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdHQKBj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:01:39 -0400
Content-Disposition: inline
In-Reply-To: <20170816170156.11594-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 07:01:56PM +0200, Florian Westphal wrote:
> nft .. ip ttl set 42
> 
> did set the protocol field and left ttl alone, add test cases for this.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
