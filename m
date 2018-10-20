From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/10] Netfilter updates for net-next
Date: Sat, 20 Oct 2018 12:33:00 -0700 (PDT)
Message-ID: <20181020.123300.1298272113544877395.davem@davemloft.net>
References: <20181020094317.16011-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 20 Oct 2018 11:43:07 +0200

> The following patchset contains Netfilter updates for your net-next tree:
> 
> 1) Use lockdep_is_held() in ipset_dereference_protected(), from Lance Roy.
> 
> 2) Remove unused variable in cttimeout, from YueHaibing.
> 
> 3) Add ttl option for nft_osf, from Fernando Fernandez Mancera.
> 
> 4) Use xfrm family to deal with IPv6-in-IPv4 packets from nft_xfrm,
>    from Florian Westphal.
> 
> 5) Simplify xt_osf_match_packet().
> 
> 6) Missing ct helper alias definition in snmp_trap helper, from Taehee Yoo.
> 
> 7) Remove unnecessary parameter in nf_flow_table_cleanup(), from Taehee Yoo.
> 
> 8) Remove unused variable definitions in nft_{dup,fwd}, from Weongyo Jeong.
> 
> 9) Remove empty net/netfilter/nfnetlink_log.h file, from Taehee Yoo.
> 
> 10) Revert xt_quota updates remain option due to problems in the listing
>     path for 32-bit arches, from Maze.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
