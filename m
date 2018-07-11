From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v19 0/8] sched: Add Common Applications Kept Enhanced (cake) qdisc
Date: Wed, 11 Jul 2018 22:40:44 +0200
Message-ID: <87o9fdbj5f.fsf@toke.dk>
References: <153089141290.14813.1010951705929696896.stgit@alrua-x1> <20180710.225648.251006161729517659.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, gamanakis@gmail.com, peteheist@gmail.com,
        ycheng@google.com, ncardwell@google.com, dave.taht@gmail.com,
        netfilter-devel@vger.kernel.org, cake@lists.bufferbloat.net
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180710.225648.251006161729517659.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Date: Fri, 06 Jul 2018 17:37:19 +0200
>
>> This patch series adds the CAKE qdisc, and has been split up to ease
>> review.
>>=20
>> I have attempted to split out each configurable feature into its own pat=
ch.
>> The first commit adds the base shaper and packet scheduler, while
>> subsequent commits add the optional features. The full userspace API and
>> most data structures are included in this commit, but options not
>> understood in the base version will be ignored.
>>=20
>> The result of applying the entire series is identical to the out of tree
>> version that have seen extensive testing in previous deployments, most
>> notably as an out of tree patch to OpenWrt. However, note that I have on=
ly
>> compile tested the individual patches; so the whole series should be
>> considered as a unit.
>
> Ok, I decided to apply this even though there are still bits I'm not
> %100 happy with.

Yay, awesome, thanks! :)

> I don't like the netfilter dependency at all.
>
> You can get the NAT addresses in other ways as I've tried to suggest
> in the past. Your scheme absolutely does not work with act_nat in the
> packet scheduler, not any NAT done by XDP/eBPF programs.

Just to reiterate why we didn't go with your suggestion of recording the
pre-NAT IP in the flow dissector as the packet comes in:

- It only works on egress; on ingress (with an ifb), packets hit the
  qdisc before NAT, so we need the stateful lookup in CAKE for this
  case, which is a common deployment scenario.

- It's not needed for act_nat (for 1-to-1 NAT, hashing on the post-NAT
  IP is fine), and it won't work for XDP (which would change the packets
  before the flow dissector sees them). This means that custom NAT
  solutions in TC BPF hooks are the only ones that would benefit; and
  they can just set the classifier to achieve the same thing.

Now, I'm absolutely not opposed to having this as a fallback egress-only
mechanism. I might even be convinced to write it myself if someone
demonstrates that they really need it :)

-Toke
