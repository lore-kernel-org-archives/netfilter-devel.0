From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ip6_tables: remove redundant assignment to e
Date: Mon, 6 Nov 2017 14:18:51 +0100
Message-ID: <20171106131851.GA2552@salvia>
References: <20171017120200.19994-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171017120200.19994-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 17, 2017 at 01:02:00PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The assignment to variable e is redundant since the same assignment
> occurs just a few lines later, hence it can be removed.  Cleans up
> clang warning: warning: Value stored to 'e' is never read

Seems like net/ipv4/netfilter/ip_tables.c also has exactly the same
redundant assignment, see mark_source_chains() there.

If we can fix this all iptables spots in one go, the best. Please,
also check arp_tables and ebtables.

Thanks!
