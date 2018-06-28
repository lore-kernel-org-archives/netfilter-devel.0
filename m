From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Thu, 28 Jun 2018 16:18:47 -0700
Message-ID: <CAM_iQpW6B+4eUO6tKVpbHoBZhYmjTijXzWCFzf5JCodL386tZw@mail.gmail.com>
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
> XPS breaks because the queue mapping stored in the socket is not
> available, so another random queue might be selected when the stack
> needs to transmit something like a TCP ACK, or TCP Retransmissions.
> That causes packet re-ordering and/or performance issues.

Now let me look at the XPS part, a key question first:

By queue mapping stored in socket, you mean sk_tx_queue_get(),
which is only called in __netdev_pick_tx(), and of course even before
hitting qdisc layer.

However, veth device orphans the skb inside its veth_xmit(),
(dev_forward_skb()), which is after going through qdisc layer.

So, how could the skb_orphan() called _after_ XPS break XPS?

We are talking about a simple netns-to-netns case, so XPS won't
be hit again once leaves it.

Another _dumb_ question:

veth is virtual device, it has literally no queues, I know technically
there is a queue for installing qdisc.

So, why does even queue mapping matters here???
