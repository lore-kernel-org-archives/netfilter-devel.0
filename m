From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Netfilter fixes for net
Date: Mon, 11 Feb 2019 10:43:07 -0800 (PST)
Message-ID: <20190211.104307.685457577050727077.davem@davemloft.net>
References: <20190211165319.17965-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211165319.17965-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 11 Feb 2019 17:53:17 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Out-of-bound access to packet data from the snmp nat helper,
>    from Jann Horn.
> 
> 2) ICMP(v6) error packets are set as related traffic by conntrack,
>    update protocol number before calling nf_nat_ipv4_manip_pkt()
>    to use ICMP(v6) rather than the original protocol number,
>    from Florian Westphal.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
