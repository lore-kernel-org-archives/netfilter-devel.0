From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Mon, 25 Jun 2018 21:15:34 -0700
Message-ID: <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180625155610.30802-1-fbl@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 25, 2018 at 8:59 AM Flavio Leitner <fbl@redhat.com> wrote:
>
> The sock reference is lost when scrubbing the packet and that breaks
> TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
> performance impacts of about 50% in a single TCP stream when crossing
> network namespaces.
>
> XPS breaks because the queue mapping stored in the socket is not
> available, so another random queue might be selected when the stack
> needs to transmit something like a TCP ACK, or TCP Retransmissions.
> That causes packet re-ordering and/or performance issues.
>
> TSQ breaks because it orphans the packet while it is still in the
> host, so packets are queued contributing to the buffer bloat problem.

Why should TSQ in one stack care about buffer bloat in another stack?

Actually, I think the current behavior is correct, once the packet leaves
its current stack (or netns), it should relief the backpressure on TCP
socket in this stack, whether it will be queued in another stack is beyond
its concern. This breaks the isolation between networking stacks.
