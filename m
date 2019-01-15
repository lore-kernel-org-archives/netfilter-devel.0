From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: nft_meta: Add NFT_META_I/OIFKIND meta type
Date: Tue, 15 Jan 2019 19:03:00 +0100
Message-ID: <20190115180300.plsfkbxqxj5cxsau@breakpoint.cc>
References: <1547565584-16842-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547565584-16842-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> nft add rule firewall rules-all meta iifkind vrf counter accept

Looks good to me.

Only comment (unrelated to this patch):
could you make nft parser enforce quoted string (meta iifkind "vrf")?

Thanks!
