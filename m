From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: build warning after merge of the netfilter-next tree
Date: Tue, 2 Jan 2018 16:30:01 +0100
Message-ID: <20180102153001.34ot5wwfwbgdkumy@salvia>
References: <20180102121451.3f8f792d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180102121451.3f8f792d@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Stephen,

On Tue, Jan 02, 2018 at 12:14:51PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the netfilter-next tree, today's linux-next build (arm
> multi_v7_defconfig) produced this warning:
> 
> In file included from net/ipv6/af_inet6.c:45:0:
> include/linux/netfilter_ipv6.h:38:51: warning: 'struct nf_queue_entry' declared inside parameter list
>   int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
>                                                    ^

Arnd sent a fix for this, thanks for reporting!

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/
