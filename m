From: Flavio Leitner <fbl@redhat.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Wed, 27 Jun 2018 09:31:55 -0300
Message-ID: <20180627123155.GW19565@plex.lan>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan>
 <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
 <20180626233302.GU19565@plex.lan>
 <CAM_iQpVmbuVK+pfhad7HrQtaSxFbe7K=59_34f0BwxoP_=W0VQ@mail.gmail.com>
 <20180627003925.GV19565@plex.lan>
 <CAM_iQpWxHb8VrHUQAEgOQ0YsSVt5MMZvGvAQVuA-JGcfjc=ubg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpWxHb8VrHUQAEgOQ0YsSVt5MMZvGvAQVuA-JGcfjc=ubg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 26, 2018 at 06:28:27PM -0700, Cong Wang wrote:
> On Tue, Jun 26, 2018 at 5:39 PM Flavio Leitner <fbl@redhat.com> wrote:
> >
> > On Tue, Jun 26, 2018 at 05:29:51PM -0700, Cong Wang wrote:
> > > On Tue, Jun 26, 2018 at 4:33 PM Flavio Leitner <fbl@redhat.com> wrote:
> > > >
> > > > It is still isolated, the sk carries the netns info and it is
> > > > orphaned when it re-enters the stack.
> > >
> > > Then what difference does your patch make?
> >
> > Don't forget it is fixing two issues.
> 
> Sure. I am only talking about TSQ from the very beginning.
> Let me rephrase my above question:
> What difference does your patch make to TSQ?

It avoids burstiness.

> > > Before your patch:
> > > veth orphans skb in its xmit
> > >
> > > After your patch:
> > > RX orphans it when re-entering stack (as you claimed, I don't know)
> >
> > ip_rcv, and equivalents.
> 
> ip_rcv() is L3, we enter a stack from L1. So your above claim is incorrect. :)

Maybe you found a problem, could you please point me to where in
between L1 to L3 the socket is relevant?


> > > And for veth pair:
> > > xmit from one side is RX for the other side
> > > So, where is the queueing? Where is the buffer bloat? GRO list??
> >
> > CPU backlog.
> 
> Yeah, but this is never targeted by TSQ:
> 
>         tcp_limit_output_bytes limits the number of bytes on qdisc
>         or device to reduce artificial RTT/cwnd and reduce bufferbloat.
> 
> which means you have to update Documentation/networking/ip-sysctl.txt
> too.

How it is never targeted? Whole point is to avoid queueing traffic.
Would you be okay if I include this chunk?

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ce8fbf5aa63c..f4c042be0216 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -733,11 +733,11 @@ tcp_limit_output_bytes - INTEGER
 	Controls TCP Small Queue limit per tcp socket.
 	TCP bulk sender tends to increase packets in flight until it
 	gets losses notifications. With SNDBUF autotuning, this can
-	result in a large amount of packets queued in qdisc/device
-	on the local machine, hurting latency of other flows, for
-	typical pfifo_fast qdiscs.
-	tcp_limit_output_bytes limits the number of bytes on qdisc
-	or device to reduce artificial RTT/cwnd and reduce bufferbloat.
+	result in a large amount of packets queued on the local machine
+	(e.g.: qdiscs, CPU backlog, or device) hurting latency of other
+	flows, for typical pfifo_fast qdiscs.  tcp_limit_output_bytes
+	limits the number of bytes on qdisc or device to reduce artificial
+	RTT/cwnd and reduce bufferbloat.
 	Default: 262144
 
 tcp_challenge_ack_limit - INTEGER


-- 
Flavio
