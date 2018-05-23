From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet classifier
Date: Wed, 23 May 2018 23:05:16 +0200
Message-ID: <87bmd6xeur.fsf@toke.dk>
References: <152699745846.21931.4558451708304709296.stgit@alrua-kau> <20180523.144442.864194409238516747.davem@davemloft.net> <87in7exg3d.fsf@toke.dk> <20180523.164152.387997944739062215.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523.164152.387997944739062215.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Date: Wed, 23 May 2018 22:38:30 +0200
>
>> How would this work?
>
> On egress the core networking flow dissector records what you need
> somewhere in SKB or wherever.  You later retrieve it at egress time
> after NAT has occurred.

Ah, right, that could work. Is there any particular field in sk_buff
we should stomp on for this purpose, or would you prefer a new one?
Looking through it, the only obvious one that comes to mind is, well,
skb->_nfct :)

If we wanted to avoid bloating sk_buff, we could add a union with that,
fill it in the flow dissector, and just let conntrack overwrite it if
active; then detect which is which in Cake, and read the data we need
from _nfct if conntrack is active, and from what the flow dissector
stored otherwise.

Is that too many hoops to jump through to avoid adding an extra field?

-Toke
