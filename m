From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 06/33] netfilter: nf_tables: Support RULE_ID reference in
 new rule
Date: Mon, 28 Jan 2019 21:24:46 -0800
Message-ID: <CAM_iQpWg0s8yaJskGyTko=S0GmfbXa4T--WTHA9gJ8xk0LAikQ@mail.gmail.com>
References: <20190128235750.18412-1-pablo@netfilter.org> <20190128235750.18412-7-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-7-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 28, 2019 at 4:00 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> From: Phil Sutter <phil@nwl.cc>
>
> To allow for a batch to contain rules in arbitrary ordering, introduce
> NFTA_RULE_POSITION_ID attribute which works just like NFTA_RULE_POSITION
> but contains the ID of another rule within the same batch. This helps
> iptables-nft-restore handling dumps with mixed insert/append commands
> correctly.
>
> Note that NFTA_RULE_POSITION takes precedence over
> NFTA_RULE_POSITION_ID, so if the former is present, the latter is
> ignored.

It looks like you forgot to add NFTA_RULE_POSITION_ID into
nft_rule_policy[]?
