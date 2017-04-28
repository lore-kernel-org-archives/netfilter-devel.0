From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: x_tables: unlock on error in
 xt_find_table_lock()
Date: Fri, 28 Apr 2017 15:51:20 +0200
Message-ID: <20170428135120.GA8648@salvia>
References: <20170428125756.s4ycoffclspnr4zo@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170428125756.s4ycoffclspnr4zo@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Apr 28, 2017 at 03:57:56PM +0300, Dan Carpenter wrote:
> According to my static checker we should unlock here before the return.
> That seems reasonable to me as well.

Applied, thanks.
