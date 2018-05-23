From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet
 classifier
Date: Wed, 23 May 2018 17:20:08 -0400 (EDT)
Message-ID: <20180523.172008.1067759293733489715.davem@davemloft.net>
References: <87in7exg3d.fsf@toke.dk>
        <20180523.164152.387997944739062215.davem@davemloft.net>
        <87bmd6xeur.fsf@toke.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: toke@toke.dk
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87bmd6xeur.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>
Date: Wed, 23 May 2018 23:05:16 +0200

> Ah, right, that could work. Is there any particular field in sk_buff
> we should stomp on for this purpose, or would you prefer a new one?
> Looking through it, the only obvious one that comes to mind is, well,
> skb->_nfct :)
> 
> If we wanted to avoid bloating sk_buff, we could add a union with that,
> fill it in the flow dissector, and just let conntrack overwrite it if
> active; then detect which is which in Cake, and read the data we need
> from _nfct if conntrack is active, and from what the flow dissector
> stored otherwise.
> 
> Is that too many hoops to jump through to avoid adding an extra field?

Space is precious in sk_buff, so yes avoid adding new members at all
costs.

How much info do you need exactly?
