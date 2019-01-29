From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 06/33] netfilter: nf_tables: Support RULE_ID reference in
 new rule
Date: Tue, 29 Jan 2019 09:09:15 +0100
Message-ID: <20190129080915.gaojievkxsycnmyh@breakpoint.cc>
References: <20190128235750.18412-1-pablo@netfilter.org>
 <20190128235750.18412-7-pablo@netfilter.org>
 <CAM_iQpWg0s8yaJskGyTko=S0GmfbXa4T--WTHA9gJ8xk0LAikQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpWg0s8yaJskGyTko=S0GmfbXa4T--WTHA9gJ8xk0LAikQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > Note that NFTA_RULE_POSITION takes precedence over
> > NFTA_RULE_POSITION_ID, so if the former is present, the latter is
> > ignored.
> 
> It looks like you forgot to add NFTA_RULE_POSITION_ID into
> nft_rule_policy[]?

Classic...

Thanks for spotting this, I'll send a patch.
