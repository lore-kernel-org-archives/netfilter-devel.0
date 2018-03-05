From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipt_ah: return boolean instead of integer
Date: Mon, 5 Mar 2018 23:10:27 +0100
Message-ID: <20180305221027.vmailsqb5gkvxmcg@salvia>
References: <20180213142557.GA9008@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180213142557.GA9008@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Feb 13, 2018 at 08:25:57AM -0600, Gustavo A. R. Silva wrote:
> Return statements in functions returning bool should use
> true/false instead of 1/0.
> 
> This issue was detected with the help of Coccinelle.

This one didn't get in time for the previous merge window.

Now applied, thanks.
