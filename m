From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/9] Netfilter fixes for net
Date: Sat, 29 Dec 2018 14:33:06 -0800 (PST)
Message-ID: <20181229.143306.868630962421278322.davem@davemloft.net>
References: <20181229125803.7415-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181229125803.7415-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 29 Dec 2018 13:57:54 +0100

> The following patchset contains Netfilter fixes for net, specifically
> fixes for the nf_conncount infrastructure which is causing troubles
> since 5c789e131cbb9 ("netfilter: nf_conncount: Add list lock and gc
> worker, and RCU for init tree search"). Patches aim to simplify this
> infrastructure while fixing up the problems:
 ...
> And one patch that falls within the miscelanea category in this batch:
> 
> 9) Missing error path for nla_nest_start(), from Kangjie Lu.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
