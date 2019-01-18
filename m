From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] netfilter: nft_meta: Add NFT_META_I/OIFKIND meta type
Date: Fri, 18 Jan 2019 15:32:08 +0100
Message-ID: <20190118143208.42q5ifmidcvtphtt@breakpoint.cc>
References: <1547596431-31824-1-git-send-email-wenxu@ucloud.cn>
 <20190118142430.rsnru4hyrbsodobf@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wenxu@ucloud.cn, fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190118142430.rsnru4hyrbsodobf@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	case NFT_META_IIFKIND:
> > +		if (in == NULL || in->rtnl_link_ops == NULL)
> > +			goto err;
> > +		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
> 
> It seems kind can be arbitrarily large, no limitation in its length.

Its limited to 60 or 56 bytes it seems:
char kind[MODULE_NAME_LEN];

nla_strlcpy(kind, linfo[IFLA_INFO_KIND], sizeof(kind));

(linkinfo_to_kind_ops in rtnetlink.c).

> Thinking...
> 
> There is no other way to identify a vft device rather than this
> string? The only l3mdev that exists if vrf, right?

There is, I suggested this more generic approach, as it would allow
to create rules that match on the kind of device used (vrf, ppp, etc.).

If you think its too generic, ok.
