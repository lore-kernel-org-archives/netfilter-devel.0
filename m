From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Tue, 26 Jun 2018 14:48:47 -0700
Message-ID: <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com> <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Flavio Leitner <fbl@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 25, 2018 at 11:41 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 06/25/2018 09:15 PM, Cong Wang wrote:
> > On Mon, Jun 25, 2018 at 8:59 AM Flavio Leitner <fbl@redhat.com> wrote:
> >>
> >> The sock reference is lost when scrubbing the packet and that breaks
> >> TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
> >> performance impacts of about 50% in a single TCP stream when crossing
> >> network namespaces.
> >>
> >> XPS breaks because the queue mapping stored in the socket is not
> >> available, so another random queue might be selected when the stack
> >> needs to transmit something like a TCP ACK, or TCP Retransmissions.
> >> That causes packet re-ordering and/or performance issues.
> >>
> >> TSQ breaks because it orphans the packet while it is still in the
> >> host, so packets are queued contributing to the buffer bloat problem.
> >
> > Why should TSQ in one stack care about buffer bloat in another stack?
> >
> > Actually, I think the current behavior is correct, once the packet leaves
> > its current stack (or netns), it should relief the backpressure on TCP
> > socket in this stack, whether it will be queued in another stack is beyond
> > its concern. This breaks the isolation between networking stacks.
> >
>
> We discussed about this during netconf Cong, nobody was against this planned removal.

I agreed to keep skb->sk, but didn't realize it actually impacts TSQ too.


>
> When a packet is attached to a socket, we should keep the association as much as possible.

As much as possible within one stack, I agree. I still don't understand
why we should keep it across the stack boundary.

>
> Only when a new association needs to be done, skb_orphan() needs to be called.
>
> Doing this skb_orphan() too soon breaks back pressure in general, this is bad, since a socket
> can evades SO_SNDBUF limits.

Right before leaving the stack is not too soon, it is the latest
actually, for veth case.
