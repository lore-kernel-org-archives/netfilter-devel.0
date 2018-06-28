From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] Netfilter fixes for net
Date: Thu, 28 Jun 2018 13:33:04 +0900 (KST)
Message-ID: <20180628.133304.905068642429205190.davem@davemloft.net>
References: <20180627152223.3633-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627152223.3633-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 27 Jun 2018 17:22:17 +0200

> The following patchset contains Netfilter fixes for your net tree:
> 
> 1) Missing netlink attribute validation in nf_queue, uncovered by KASAN,
>    from Eric Dumazet.
> 
> 2) Use pointer to sysctl table, save us 192 bytes of memory per netns.
>    Also from Eric.
> 
> 3) Possible use-after-free when removing conntrack helper modules due
>    to missing synchronize RCU call. From Taehee Yoo.
> 
> 4) Fix corner case in systcl writes to nf_log that lead to appending
>    data to uninitialized buffer, from Jann Horn.
> 
> 5) Jann Horn says we may indefinitely block other users of nf_log_mutex
>    if a userspace access in proc_dostring() blocked e.g. due to a
>    userfaultfd.
> 
> 6) Fix garbage collection race for unconfirmed conntrack entries,
>    from Florian Westphal.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
