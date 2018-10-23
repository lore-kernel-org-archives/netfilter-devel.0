From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/8] Netfilter fixes for net
Date: Mon, 22 Oct 2018 20:21:50 -0700 (PDT)
Message-ID: <20181022.202150.910836050780634329.davem@davemloft.net>
References: <20181022200724.25806-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181022200724.25806-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 22 Oct 2018 22:07:16 +0200

> The following patchset contains Netfilter fixes for your net tree:
> 
> 1) rbtree lookup from control plane returns the left-hand side element
>    of the range when the interval end flag is set on.
> 
> 2) osf extension is not supported from the input path, reject this from
>    the control plane, from Fernando Fernandez Mancera.
> 
> 3) xt_TEE is leaving output interface unset due to a recent incorrect
>    netns rework, from Taehee Yoo.
> 
> 4) xt_TEE allows to select an interface which does not belong to this
>    netnamespace, from Taehee Yoo.
> 
> 5) Zero private extension area in nft_compat, just like we do in x_tables,
>    otherwise we leak kernel memory to userspace.
> 
> 6) Missing .checkentry and .destroy entries in new DNAT extensions breaks
>    it since we never load nf_conntrack dependencies, from Paolo Abeni.
> 
> 7) Do not remove flowtable hook from netns exit path, the netdevice handler
>    already deals with this, also from Taehee Yoo.
> 
> 8) Only cleanup flowtable entries that reside in this netnamespace, also
>    from Taehee Yoo.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled.
