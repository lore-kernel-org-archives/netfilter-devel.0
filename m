From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][V2] netfilter: remove redundant assignment to e
Date: Mon, 13 Nov 2017 13:43:56 +0100
Message-ID: <20171113124356.GA7770@salvia>
References: <20171107100801.10056-1-colin.king@canonical.com>
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
In-Reply-To: <20171107100801.10056-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 07, 2017 at 10:08:01AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The assignment to variable e is redundant since the same assignment
> occurs just a few lines later, hence it can be removed.  Cleans up
> clang warning for arp_tables, ip_tables and ip6_tables:

Applied, thanks Colin.
