From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] src: prepare for future ct timeout policy support
Date: Wed, 27 Sep 2017 19:53:52 +0200
Message-ID: <20170927175352.GA17665@salvia>
References: <20170927173807.29882-1-fw@strlen.de>
 <20170927173807.29882-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38251 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751016AbdI0Rx4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 13:53:56 -0400
Content-Disposition: inline
In-Reply-To: <20170927173807.29882-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 27, 2017 at 07:38:05PM +0200, Florian Westphal wrote:
> Change all places that expect ct helper tokens (ct helper configuration)
> to CT HELPER.  ct_obj_kind is removed.
> 
> When we add ct timeout support, we will add a new ct_timeout_block,
> plus extra rules.  We won't extend ct_block, it prevents the parser
> from detecting bogus syntax that only makes sense for ct helper but
> not for something else for instance.
> 
> ct_block should be renamed to ct_helper_block, will be done in
> followup patch.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

>  include/ct.h       |  2 --
>  include/rule.h     |  2 +-
>  src/ct.c           | 10 ------
>  src/parser_bison.y | 98 ++++++++++--------------------------------------------
>  src/rule.c         |  7 ++--
>  5 files changed, 23 insertions(+), 96 deletions(-)

Nice diffstats.
