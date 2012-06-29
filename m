From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/5] netfilter fixes for 3.5-rc4
Date: Fri, 29 Jun 2012 16:37:25 -0700 (PDT)
Message-ID: <20120629.163725.1244778955999448557.davem@davemloft.net>
References: <1340984255-738-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1340984255-738-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: pablo@netfilter.org
Date: Fri, 29 Jun 2012 17:37:30 +0200

> * One refcount leak fix in IPVS IPv6 support from Eric Dumazet.
> 
> * One fix for interface comparison in ipset hash-netiface sets
>   from Florian Westphal.
> 
> * One fix for a missing rcu_read_unlock in nfnetlink from
>   Tomasz Bursztyka.
> 
> * One fix for a kernel crash if IPSET_CMD_NONE is set to ipset via
>   nfnetlink, again from Tomasz Bursztyka.
> 
> You can pull these changes from:
> 
> git://1984.lsi.us.es/nf master

Pulled, thanks Pablo.
