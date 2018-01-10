From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: improve flow table Kconfig
 dependencies
Date: Wed, 10 Jan 2018 18:22:41 +0100
Message-ID: <20180110172241.6efco44hsm5mwyja@salvia>
References: <20180110171143.2528510-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110171143.2528510-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 10, 2018 at 06:10:59PM +0100, Arnd Bergmann wrote:
> The newly added NF_FLOW_TABLE options cause some build failures in
> randconfig kernels:

Applied, thanks Arnd.
