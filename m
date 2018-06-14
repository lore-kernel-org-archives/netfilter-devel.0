From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 16:55:49 -0700 (PDT)
Message-ID: <20180614.165549.1790121217625223670.davem@davemloft.net>
References: <20180614141947.3580-1-pablo@netfilter.org>
        <20180614.101831.465275975690050595.davem@davemloft.net>
        <66634ba7-3d72-644a-9d26-d9644c540619@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com
To: f.fainelli@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <66634ba7-3d72-644a-9d26-d9644c540619@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 14 Jun 2018 11:14:37 -0700

> On those platforms there are a number of things that just literally
> kill the routing performance: small I and D caches, small or not L2,
> limited bandwidth DRAM, huge call depths, big struct sk_buff layout,
> you name it.

Another reason to work on a 64-bit MIPS eBPF JIT.

We have a model, and game plan for this kind of application.  And it's
XDP and eBPF with JITs.

We are fully commited to this approach, and I see anything else that
tries to slip in and approach some sub-part of the problem as a
complete distraction and a step backwards.

All of the effort on this work could have been spent filling in the
missing pieces you mention.

And guess what?  Then millions of possibilities would have been
openned up, rather than just this one special case.

So, I ask, please see the larger picture.

Thank you.
