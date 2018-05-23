From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet classifier
Date: Thu, 24 May 2018 00:40:47 +0200
Message-ID: <878t8axafk.fsf@toke.dk>
References: <87in7exg3d.fsf@toke.dk> <20180523.164152.387997944739062215.davem@davemloft.net> <87bmd6xeur.fsf@toke.dk> <20180523.172008.1067759293733489715.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523.172008.1067759293733489715.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Date: Wed, 23 May 2018 23:05:16 +0200
>
>> Ah, right, that could work. Is there any particular field in sk_buff
>> we should stomp on for this purpose, or would you prefer a new one?
>> Looking through it, the only obvious one that comes to mind is, well,
>> skb->_nfct :)
>>=20
>> If we wanted to avoid bloating sk_buff, we could add a union with that,
>> fill it in the flow dissector, and just let conntrack overwrite it if
>> active; then detect which is which in Cake, and read the data we need
>> from _nfct if conntrack is active, and from what the flow dissector
>> stored otherwise.
>>=20
>> Is that too many hoops to jump through to avoid adding an extra field?
>
> Space is precious in sk_buff, so yes avoid adding new members at all
> costs.
>
> How much info do you need exactly?

We use a u32 hash (from flow_hash_from_keys()) on the source address.
Ideally we'd want that; but we could get away with less if we are
willing to accept more hash collisions; we just need to map the source
address into a hash bucket. We currently have 1024 of those, so 10 bits
would suffice if we just drop the set-associative hashing for source
hosts.

Or maybe 16 bits to be on the safe side? It really is a pretty
straight-forward tradeoff between space and collision probability.


Hmm, and we still have an issue with ingress filtering (where cake is
running on an ifb interface). That runs pre-NAT in the conntrack case,
and we can't do the RX trick. Here we do the lookup manually in
conntrack (and this part is actually what brings in most of the
dependencies). Any neat tricks up your sleeve for this case? :)

-Toke
