From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: x_tables: unlock on error in
 xt_find_table_lock()
Date: Fri, 28 Apr 2017 15:03:14 +0200
Message-ID: <20170428130314.GA26935@breakpoint.cc>
References: <20170428125756.s4ycoffclspnr4zo@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35934 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1425931AbdD1NDk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 09:03:40 -0400
Content-Disposition: inline
In-Reply-To: <20170428125756.s4ycoffclspnr4zo@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> According to my static checker we should unlock here before the return.
> That seems reasonable to me as well.

Indeed, thanks for the fix!

Acked-by: Florian Westphal <fw@strlen.de>

