From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nft_meta: Add NFT_META_L3MASTER meta type
Date: Tue, 15 Jan 2019 12:17:38 +0100
Message-ID: <20190115111738.luy6pmhkvbb42dio@breakpoint.cc>
References: <1547529039-26786-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, dsahern@gmail.com, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547529039-26786-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> so with this patch userspace can add the 'don't re-do entire ruleset for vrf' policy
> itself like the following
> 
> nft add rule firewall rules-all meta l3master true counter accept

I wonder if we need to support this also for output interface, and if
this should be specific to vrf or not.

Example:

meta iifl3master exists accept
meta oifl3master exists accept
or
meta iifkind "vrf" accept
meta oifkind "vrf" accept

(the latter could e.g. place rtnl_op ".kind" in the register)

Not sure if that would ever be useful beyond vrf.
