From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: preserve sock reference when
 scrubbing the skb.
Date: Fri, 29 Jun 2018 17:15:55 -0700
Message-ID: <CAM_iQpWVG+VfQfa3=FQYMuimVhwTcW9nD5DbNH3ES5uLEE3ZFg@mail.gmail.com>
References: <20180627133426.3858-1-fbl@redhat.com> <CAM_iQpXnfc8uA10EK2X7B=vB_uWayeGw=M5F-_uygu7aPvCjRw@mail.gmail.com>
 <CAM_iQpVh8=sCiuSVkr4NRHWtxXGah95AOg91cy8AJfAXtU7Hkw@mail.gmail.com> <20180629.112235.970317820691624358.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Flavio Leitner <fbl@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180629.112235.970317820691624358.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 28, 2018 at 7:22 PM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Thu, 28 Jun 2018 14:53:09 -0700
>
> > I will send a revert with quote of the above.
>
> And it will go to /dev/null as far as I am concerned.  I read it the
> first time, so posting it again will not change my opinion of what you
> have to say.

David, you claim you read it, now tell me, where is "cgroups" or "cpu"
from?

This is the link of my reply you quoted:
https://marc.info/?l=linux-netdev&m=153013948711582&w=2

I did mention cgroups to Eric because of isolation, the softnet_data
is per-CPU, and CPU is not isolated by netns apparently, therefore
sd->input_pkt_queue can't be totally isolated for netns without cpuset.

But this is never the reason why I dislike it, this is why I never even
mentioned it in the link above.

>
> Cong, you really need to calm down and understand that people perhaps
> simply fundamentally disagree with you.

1. Eric's "forwarding to eth0" is missing, never brought up until in his
private reply. Without this information, XPS makes no sense at all in
this patchset. For the record, I provide a different solution for Eric.

2. No one responses to:
https://marc.info/?l=linux-netdev&m=153013948711582&w=2
I never expect you agree with me on all of them, but no one
gives me any response to my concerns.

3. I will write a blog post to draw you some pictures, since it
is so hard to understand the isolation...
