From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] netfilter: nft_meta: Add NFT_META_I/OIFKIND meta type
Date: Thu, 24 Jan 2019 14:59:53 +0100
Message-ID: <20190124135953.cps24owg5b6aplgl@breakpoint.cc>
References: <1547596431-31824-1-git-send-email-wenxu@ucloud.cn>
 <20190118142430.rsnru4hyrbsodobf@salvia>
 <20190118143208.42q5ifmidcvtphtt@breakpoint.cc>
 <20190118143503.3h2tv4fujl4w25mz@salvia>
 <de38b79c-4e94-16bd-5389-9b0fc224f7eb@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: wenxu <wenxu@ucloud.cn>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de38b79c-4e94-16bd-5389-9b0fc224f7eb@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

wenxu <wenxu@ucloud.cn> wrote:
> Hi all,
> Are there any other idear for this patch?  Maye should modify  IFNAMSIZ to MODULE_NAME_LEN

i think its fine as-is.
