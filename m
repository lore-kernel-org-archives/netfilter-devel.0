From: dsahern@kernel.org
Subject: [PATCH net-next 0/3] net: wean netfilter from fib_nh
Date: Thu, 20 Sep 2018 13:50:46 -0700
Message-ID: <20180920205049.15143-1-dsahern@kernel.org>
Cc: pablo@netfilter.org, fw@strlen.de, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Two netfilter modules reference fib_nh. In both cases the code is
only checking if a nexthop in a fib_info uses a specific device.
Both instances essentially duplicate code from __fib_validate_source,
so move that code into a helper and flip the netfilter modules to
use it.

David Ahern (3):
  net/ipv4: Move device validation to helper
  netfilter: rpfilter: Convert rpfilter_lookup_reverse to new dev helper
  netfilter: nft_fib: Convert nft_fib4_eval to new dev helper

 include/net/ip_fib.h              |  1 +
 net/ipv4/fib_frontend.c           | 44 ++++++++++++++++++++++++---------------
 net/ipv4/netfilter/ipt_rpfilter.c | 17 +--------------
 net/ipv4/netfilter/nft_fib_ipv4.c | 27 ++++++------------------
 4 files changed, 35 insertions(+), 54 deletions(-)

-- 
2.11.0
