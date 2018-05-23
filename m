From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet
 classifier
Date: Wed, 23 May 2018 16:41:52 -0400 (EDT)
Message-ID: <20180523.164152.387997944739062215.davem@davemloft.net>
References: <152699745846.21931.4558451708304709296.stgit@alrua-kau>
        <20180523.144442.864194409238516747.davem@davemloft.net>
        <87in7exg3d.fsf@toke.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: toke@toke.dk
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87in7exg3d.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>
Date: Wed, 23 May 2018 22:38:30 +0200

> How would this work?

On egress the core networking flow dissector records what you need
somewhere in SKB or wherever.  You later retrieve it at egress time
after NAT has occurred.

> It's about making sure the per-host fairness works when NATing, so
> we can distribute bandwidth between the hosts on the local LAN
> regardless of how many flows they open.

Ok, understood.

> But it's not unreasonable to expect people who do NAT in eBPF to
> also set skb->tc_classid if they want pre-nat host fairness, is it?

And core networking can do it as well.

Please remove this conntrack dependency, I don't think it is necessary
and it is very short sighted.
