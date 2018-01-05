From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Netfilter fixes for net
Date: Fri, 05 Jan 2018 10:33:22 -0500 (EST)
Message-ID: <20180105.103322.514160736119722152.davem@davemloft.net>
References: <20180105150825.18460-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180105150825.18460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri,  5 Jan 2018 16:08:22 +0100

> The following patchset contains Netfilter fixes for your net tree,
> they are:
> 
> 1) Fix chain filtering when dumping rules via nf_tables_dump_rules().
> 
> 2) Fix accidental change in NF_CT_STATE_UNTRACKED_BIT through uapi,
>    introduced when removing the untracked conntrack object, from
>    Florian Westphal.
> 
> 3) Fix potential nul-dereference when releasing dump filter in
>    nf_tables_dump_obj_done(), patch from Hangbin Liu.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
