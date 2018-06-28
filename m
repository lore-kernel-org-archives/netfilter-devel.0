From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Thu, 28 Jun 2018 14:51:03 -0700
Message-ID: <CAM_iQpUy06Jrnx=2sG8HyGcKFhnoofoUAQqfUHzYmAO_LQ-11A@mail.gmail.com>
References: <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan> <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
 <20180626233302.GU19565@plex.lan> <CAM_iQpVmbuVK+pfhad7HrQtaSxFbe7K=59_34f0BwxoP_=W0VQ@mail.gmail.com>
 <20180627003925.GV19565@plex.lan> <CAM_iQpWxHb8VrHUQAEgOQ0YsSVt5MMZvGvAQVuA-JGcfjc=ubg@mail.gmail.com>
 <20180627123155.GW19565@plex.lan> <CAM_iQpWOxCk0GYPEAwrdrPg91mhyHR==pzhRGF3fS9+pF493xA@mail.gmail.com>
 <20180627201937.GZ19565@plex.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627201937.GZ19565@plex.lan>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 27, 2018 at 1:19 PM Flavio Leitner <fbl@redhat.com> wrote:
>
> On Wed, Jun 27, 2018 at 12:06:16PM -0700, Cong Wang wrote:
> > On Wed, Jun 27, 2018 at 5:32 AM Flavio Leitner <fbl@redhat.com> wrote:
> > >
> > > On Tue, Jun 26, 2018 at 06:28:27PM -0700, Cong Wang wrote:
> > > > On Tue, Jun 26, 2018 at 5:39 PM Flavio Leitner <fbl@redhat.com> wrote:
> > > > >
> > > > > On Tue, Jun 26, 2018 at 05:29:51PM -0700, Cong Wang wrote:
> > > > > > On Tue, Jun 26, 2018 at 4:33 PM Flavio Leitner <fbl@redhat.com> wrote:
> > > > > > >
> > > > > > > It is still isolated, the sk carries the netns info and it is
> > > > > > > orphaned when it re-enters the stack.
> > > > > >
> > > > > > Then what difference does your patch make?
> > > > >
> > > > > Don't forget it is fixing two issues.
> > > >
> > > > Sure. I am only talking about TSQ from the very beginning.
> > > > Let me rephrase my above question:
> > > > What difference does your patch make to TSQ?
> > >
> > > It avoids burstiness.
> >
> > Never even mentioned in changelog or in your patch. :-/
>
> It's part of queueing and helping the bufferbloat problem in the
> commit message.

Please don't add all queues in this scope. Are you really
going to put all queues in networking into your "bufferbloat" claim?
Seriously? Please get it defined, seriously. You really need to
read into the other reply from me, none of you or David even
seriously finish reading it.


>
> > > > > > Before your patch:
> > > > > > veth orphans skb in its xmit
> > > > > >
> > > > > > After your patch:
> > > > > > RX orphans it when re-entering stack (as you claimed, I don't know)
> > > > >
> > > > > ip_rcv, and equivalents.
> > > >
> > > > ip_rcv() is L3, we enter a stack from L1. So your above claim is incorrect. :)
> > >
> > > Maybe you found a problem, could you please point me to where in
> > > between L1 to L3 the socket is relevant?
> >
> > Of course, ingress qdisc is in L2. Do I need to say more? This
> > is where we can re-route the packets, for example, redirecting it to
> > yet another netns. This is in fact what we use in production, not anything
> > that only in my imagination.
> >
> > You really have to think about why you allow a different netns influence
> > another netns by holding the skb to throttle the source TCP socket.
>
> Maybe I wasn't clear and you didn't understand the question. Please find
> a spot where the preserved socket is used incorrectly.


It's sad you still don't get what I mean, I never complain you leak skb->sk,
I complain you break TSQ. Dragging discussion into skb->sk doesn't
even help.


>
> > > > which means you have to update Documentation/networking/ip-sysctl.txt
> > > > too.
> > >
> > > How it is never targeted? Whole point is to avoid queueing traffic.
> >
> > What queues? You really need to define it, seriously.
> >
> >
> > > Would you be okay if I include this chunk?
> >
> > No, still lack of an explanation why it comes across netns for
> > a good reason.
>
> Because it doesn't. Since you talk more about veth, let's pick it
> as an example. The TX is nothing more than add to the CPU backlog,


That's RX, assume "CPU backlog" here still means softnet_data.


> right? That is netns agnostic. The same for processing that queue
> which will push the skb anyways and will call skb_orphan().


Once it leaves TX, it leaves the stack. skb_orphan() called
in L3 (as you claimed) is already in yet another stack.


>
> How can one netns avoid/delay the skb_orphan()? And even if does
> that, what gain will you have to allow queuing of more and more
> packets in the CPU backlog? It is stalled.

Please read the other reply from me, you don't even understand
what a boundary of a stack is.
