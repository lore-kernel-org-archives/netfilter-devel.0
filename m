From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: fix netfilter_net_init() return
Date: Tue, 18 Jul 2017 23:12:29 +0200
Message-ID: <20170718211229.GB5832@breakpoint.cc>
References: <20170718193856.yh2qd2j5bloiuq5r@mwanda>
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
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53866 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752256AbdGRVOK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 17:14:10 -0400
Content-Disposition: inline
In-Reply-To: <20170718193856.yh2qd2j5bloiuq5r@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We accidentally return an uninitialized variable.

Ugh, indeed, thanks for the quick fix!
