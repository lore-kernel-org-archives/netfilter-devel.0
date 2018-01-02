From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: add nf_queue_entry forward declaration
Date: Tue, 2 Jan 2018 12:11:50 +0100
Message-ID: <20180102111150.rbhvv2nujqibcbrb@salvia>
References: <20180102101644.200962-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180102101644.200962-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 02, 2018 at 11:16:23AM +0100, Arnd Bergmann wrote:
> The newly added callback pointers cause a warning for some configurations:
> 
> In file included from net/ipv6/af_inet6.c:45:0:
> include/linux/netfilter_ipv6.h:38:51: error: 'struct nf_queue_entry' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
> 
> Adding a forward declaration for the type avoids the warnings.

Applied, thanks Arnd.
