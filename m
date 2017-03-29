From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/8] Netfilter fixes for net
Date: Wed, 29 Mar 2017 14:39:15 -0700 (PDT)
Message-ID: <20170329.143915.150518467844727871.davem@davemloft.net>
References: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 29 Mar 2017 14:14:02 +0200

> Hi David,
> 
> The following patchset contains a rather large update with Netfilter
> fixes, specifically targeted to incorrect RCU usage in several spots and
> the userspace conntrack helper infrastructure (nfnetlink_cthelper),
> more specifically they are:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
