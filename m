From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter/x_tables: do not fail xt_alloc_table_info too
 easilly
Date: Thu, 16 Aug 2018 18:41:10 +0200
Message-ID: <20180816164110.g2dedcm7nh75zjms@salvia>
References: <20180807195400.23687-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Vlastimil Babka <vbabka@suse.cz>,
        Georgi Nikolov <gnikolov@icdsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>
To: Michal Hocko <mhocko@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807195400.23687-1-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 07, 2018 at 09:54:00PM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc()
> in xt_alloc_table_info()") has unintentionally fortified
> xt_alloc_table_info allocation when __GFP_RETRY has been dropped from
> the vmalloc fallback. Later on there was a syzbot report that this
> can lead to OOM killer invocations when tables are too large and
> 0537250fdc6c ("netfilter: x_tables: make allocation less aggressive")
> has been merged to restore the original behavior. Georgi Nikolov however
> noticed that he is not able to install his iptables anymore so this can
> be seen as a regression.
> 
> The primary argument for 0537250fdc6c was that this allocation path
> shouldn't really trigger the OOM killer and kill innocent tasks. On the
> other hand the interface requires root and as such should allow what the
> admin asks for. Root inside a namespaces makes this more complicated
> because those might be not trusted in general. If they are not then such
> namespaces should be restricted anyway. Therefore drop the __GFP_NORETRY
> and replace it by __GFP_ACCOUNT to enfore memcg constrains on it.

Applied, thanks.
