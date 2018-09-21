From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] net: wean netfilter from fib_nh
Date: Thu, 20 Sep 2018 20:02:08 -0700 (PDT)
Message-ID: <20180920.200208.1568858977478629095.davem@davemloft.net>
References: <20180920205049.15143-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, fw@strlen.de, dsahern@gmail.com
To: dsahern@kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920205049.15143-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: dsahern@kernel.org
Date: Thu, 20 Sep 2018 13:50:46 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Two netfilter modules reference fib_nh. In both cases the code is
> only checking if a nexthop in a fib_info uses a specific device.
> Both instances essentially duplicate code from __fib_validate_source,
> so move that code into a helper and flip the netfilter modules to
> use it.

Series applied, thanks David.
