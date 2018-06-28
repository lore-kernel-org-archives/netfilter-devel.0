From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: preserve sock reference when
 scrubbing the skb.
Date: Thu, 28 Jun 2018 14:53:09 -0700
Message-ID: <CAM_iQpVh8=sCiuSVkr4NRHWtxXGah95AOg91cy8AJfAXtU7Hkw@mail.gmail.com>
References: <20180627133426.3858-1-fbl@redhat.com> <CAM_iQpXnfc8uA10EK2X7B=vB_uWayeGw=M5F-_uygu7aPvCjRw@mail.gmail.com>
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
In-Reply-To: <CAM_iQpXnfc8uA10EK2X7B=vB_uWayeGw=M5F-_uygu7aPvCjRw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 27, 2018 at 12:39 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Let me rephrase why I don't like this patchset:
>
> 1. Let's forget about TSQ for a moment, skb_orphan() before leaving
> the stack is not just reasonable but also aligning to network isolation
> design. You can't claim skb_orphan() is broken from beginning, it is
> designed in this way and it is intentional.
>
> 2. Now, let's consider the current TSQ behavior (without any patch):
>
> 2a. For packets leaving the host or just leaving the stack to another
> netns, there is no difference, and this should be expected from user's
> point of view, because I don't need to think about its destination to
> decide how I should configure tcp_limit_output_bytes.
>
> 2b. The hidden pipeline behind TSQ is well defined, that is, any
> queues in between L4 and L2, most importantly qdisc. I can easily
> predict the number of queues my packets will go through with a
> given configuration. This also aligns with 2a.
>
> 2c. Isolation is respected as it should. TCP sockets in this netns
> won't be influenced by any factor in another netns.
>
> Now with your patchset:
>
> 2a. There is an apparent difference for packets leaving the host
> and for packets just leaving this stack.
>
> 2b. You extend the pipeline to another netns's L3, which means
> the number of queues is now unpredictable.
>
> 2c. Isolation is now slightly broken, the other netns could influence
> the source netns.
>
> I don't see you have any good argument on any of these 3 points.

No one finishes reading this.
I will send a revert with quote of the above.
