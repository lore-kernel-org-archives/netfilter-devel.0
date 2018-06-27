From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Tue, 26 Jun 2018 19:32:32 -0700
Message-ID: <da3d006d-de11-f308-2a99-98a43c06fbb5@gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan>
 <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
 <20180626233302.GU19565@plex.lan>
 <CAM_iQpVmbuVK+pfhad7HrQtaSxFbe7K=59_34f0BwxoP_=W0VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>,
        Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpVmbuVK+pfhad7HrQtaSxFbe7K=59_34f0BwxoP_=W0VQ@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/26/2018 05:29 PM, Cong Wang wrote:
> On Tue, Jun 26, 2018 at 4:33 PM Flavio Leitner <fbl@redhat.com> wrote:
>>
>> It is still isolated, the sk carries the netns info and it is
>> orphaned when it re-enters the stack.
> 
> Then what difference does your patch make?
> 
> Before your patch:
> veth orphans skb in its xmit
> 
> After your patch:
> RX orphans it when re-entering stack (as you claimed, I don't know)
> 
> And for veth pair:
> xmit from one side is RX for the other side
> 
> So, where is the queueing? Where is the buffer bloat? GRO list??
> 

By re-entering the stack, Flavio probably meant storing this skb in
a socket receive queue, or anything that should already modify skb->destructor
(and thus call skb_orphan() before the modification)

If skb sits in some qdisc, like fq on ipvlan master device, we do not want skb->sk to be scrubbed,
just because ipvlan slave and master might be in different netns.
