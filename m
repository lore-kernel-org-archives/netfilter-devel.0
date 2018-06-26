From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Mon, 25 Jun 2018 23:41:05 -0700
Message-ID: <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>,
        Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/25/2018 09:15 PM, Cong Wang wrote:
> On Mon, Jun 25, 2018 at 8:59 AM Flavio Leitner <fbl@redhat.com> wrote:
>>
>> The sock reference is lost when scrubbing the packet and that breaks
>> TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
>> performance impacts of about 50% in a single TCP stream when crossing
>> network namespaces.
>>
>> XPS breaks because the queue mapping stored in the socket is not
>> available, so another random queue might be selected when the stack
>> needs to transmit something like a TCP ACK, or TCP Retransmissions.
>> That causes packet re-ordering and/or performance issues.
>>
>> TSQ breaks because it orphans the packet while it is still in the
>> host, so packets are queued contributing to the buffer bloat problem.
> 
> Why should TSQ in one stack care about buffer bloat in another stack?
> 
> Actually, I think the current behavior is correct, once the packet leaves
> its current stack (or netns), it should relief the backpressure on TCP
> socket in this stack, whether it will be queued in another stack is beyond
> its concern. This breaks the isolation between networking stacks.
> 

We discussed about this during netconf Cong, nobody was against this planned removal.

When a packet is attached to a socket, we should keep the association as much as possible.

Only when a new association needs to be done, skb_orphan() needs to be called.

Doing this skb_orphan() too soon breaks back pressure in general, this is bad, since a socket
can evades SO_SNDBUF limits.

I am not sure why the patch is so complex, I would have simply removed the skb_orphan().
