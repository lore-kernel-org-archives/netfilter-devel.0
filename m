From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next 0/3] net: wean netfilter from fib_nh
Date: Thu, 20 Sep 2018 22:53:30 +0200
Message-ID: <20180920205330.a6alwd6pz7xul3a7@breakpoint.cc>
References: <20180920205049.15143-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, fw@strlen.de, David Ahern <dsahern@gmail.com>
To: dsahern@kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920205049.15143-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

dsahern@kernel.org <dsahern@kernel.org> wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Two netfilter modules reference fib_nh. In both cases the code is
> only checking if a nexthop in a fib_info uses a specific device.
> Both instances essentially duplicate code from __fib_validate_source,
> so move that code into a helper and flip the netfilter modules to
> use it.

Lokks good to me, thanks David.
