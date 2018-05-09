From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix memory leak on error exit
 return
Date: Wed, 9 May 2018 14:32:03 +0200
Message-ID: <20180509123203.ppangv6gdzppj3iv@salvia>
References: <20180509122256.16859-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180509122256.16859-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 09, 2018 at 01:22:56PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the -EBUSY error return path is not free'ing resources
> allocated earlier, leaving a memory leak. Fix this by exiting via the
> error exit label err5 that performs the necessary resource clean
> up.
> 
> Detected by CoverityScan, CID#1432975 ("Resource leak")

Applied, thanks.
