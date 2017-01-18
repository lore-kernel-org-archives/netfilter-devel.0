From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipt_CLUSTERIP: fix build error without procfs
Date: Wed, 18 Jan 2017 20:57:43 +0100
Message-ID: <20170118195743.GA14797@salvia>
References: <20170113154204.2737978-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Xin Long <lucien.xin@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170113154204.2737978-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 13, 2017 at 04:41:03PM +0100, Arnd Bergmann wrote:
> We can't access c->pde if CONFIG_PROC_FS is disabled:
> 
> net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_config_find_get':
> net/ipv4/netfilter/ipt_CLUSTERIP.c:147:9: error: 'struct clusterip_config' has no member named 'pde'
> 
> This moves the check inside of another #ifdef.
> 
> Fixes: 6c5d5cfbe3c5 ("netfilter: ipt_CLUSTERIP: check duplicate config when initializing")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks Arnd.
