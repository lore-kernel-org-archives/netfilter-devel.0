From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net v2 0/2] fix glitch in IPVS /proc handlers
Date: Tue, 31 Jul 2018 18:28:22 +0200
Message-ID: <20180731162822.egqgbh6rbekoqvqk@verge.net.au>
References: <20180731160333.12215-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Matteo Croce <mcroce@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731160333.12215-1-mcroce@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 31, 2018 at 06:03:31PM +0200, Matteo Croce wrote:
> Fix a bug which shows negative values in IPVS /proc handlers.
> Also add an helper function to calculate a time delta
> 
> Matteo Croce (2):
>   jiffies: add utility function to calculate delta in ms
>   ipvs: don't show negative times in ip_vs_conn

Acked-by: Simon Horman <horms@verge.net.au>

Pablo, please consider taking these via the nf tree.
