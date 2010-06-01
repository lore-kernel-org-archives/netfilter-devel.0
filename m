From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] netfilter: netfilter fixes
Date: Mon, 31 May 2010 23:45:11 -0700 (PDT)
Message-ID: <20100531.234511.241910061.davem@davemloft.net>
References: <1275322487-19026-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1275322487-19026-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: kaber@trash.net
Date: Mon, 31 May 2010 18:14:45 +0200

> the following two patches fix two problems with the recent introduction of
> a seperately allocated jumpstack for xtables rulesets:
> 
> - a memory leak when registering new tables, from Xiaotian Feng
> 
> - performance degradation caused by not using per-CPU allocations
>   for the jumpstack, from Eric
> 
> Please apply or pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Pulled, thanks Patrick.
