From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_{match|target}
Date: Thu, 25 Jan 2018 12:33:10 +0100
Message-ID: <20180125113310.zkhizswlqtt2m5yd@salvia>
References: <1516834188.3715.35.camel@gmail.com>
 <20180124231952.GC14192@breakpoint.cc>
 <20180124235056.ahubcyqostttvtbx@salvia>
 <20180125001336.ilboagwlcpck54ip@salvia>
 <1516842969.3715.41.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netdev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516842969.3715.41.camel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 24, 2018 at 05:16:09PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It looks like syzbot found its way into netfilter territory.
> 
> Issue here is that @name comes from user space and might
> not be null terminated.
> 
> Out-of-bound reads happen, KASAN is not happy.
> 
> v2 added similar fix for xt_request_find_target(),
> as Florian advised.

Applied, thanks Eric.
