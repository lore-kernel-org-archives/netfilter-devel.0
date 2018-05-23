From: David Miller <davem@davemloft.net>
Subject: Re: [Cake] [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to
 packet classifier
Date: Wed, 23 May 2018 16:39:10 -0400 (EDT)
Message-ID: <20180523.163910.2061435036559770900.davem@davemloft.net>
References: <91739F64-20B7-4C56-A7A3-AB8C71B9437C@gmail.com>
        <20180523.160403.20551254565100734.davem@davemloft.net>
        <370B23D9-E929-4A73-BB7C-C1BE4A01C7E6@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: toke@toke.dk, cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: chromatix99@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <370B23D9-E929-4A73-BB7C-C1BE4A01C7E6@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jonathan Morton <chromatix99@gmail.com>
Date: Wed, 23 May 2018 23:33:04 +0300

> Now I'm *really* confused.
> 
> Are you saying that the user has to set up their own conntrack
> mechanism using extra userspace commands?  Because complicating the
> setup process that way runs directly counter to Cake's design
> philosophy.

I mean not anything filtering or firewall related.

We have a full flow dissector in the networking core, which often runs
on every RX packet anyways.  Record what we need and use it on egress
after NAT has occurred.
