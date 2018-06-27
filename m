From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Tue, 26 Jun 2018 17:44:49 -0700
Message-ID: <CAM_iQpUOvavz580tJHCXhAR6AMprmFvakqiaiVMYe7NLFvFJ0Q@mail.gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com> <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com> <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan> <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
 <aae3fa15-598b-342d-20c7-23ed4b9faf84@gmail.com>
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
In-Reply-To: <aae3fa15-598b-342d-20c7-23ed4b9faf84@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 26, 2018 at 4:53 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 06/26/2018 03:47 PM, Cong Wang wrote:
> >
> > You need to justify why you want to break the TSQ's scope here,
> > which is obviously not compatible with netns design.
>
> You have to explain why you do not want us to fix this buggy behavior.
>
> Right now TSQ (and more generally back pressure) is broken by this skb_orphan()
>
> So we want to restore TSQ (and back pressure)
>
> TSQ scope never mentioned netns.

Conceptually, it is limiting the pipeline from L4 to L2 within one stack, now
you are extending it to NS1 (L4...L2)...NS2 (L2...L4) which could across
multiple stacks and _in theory_ could be infinitely long.

And TSQ setting is per-netns:

2180 static bool tcp_small_queue_check(struct sock *sk, const struct
sk_buff *skb,
2181                                   unsigned int factor)
2182 {
2183         unsigned int limit;
2184
2185         limit = max(2 * skb->truesize, sk->sk_pacing_rate >>
sk->sk_pacing_shift);
2186         limit = min_t(u32, limit,
2187                       sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
2188         limit <<= factor;

Should I expect to increase sysctl_tcp_limit_output_bytes based on the
number of stacks it crosses?

> We (TCP stack TSQ handler) want to be notified when this packet leaves the host,
> even if it had to traverse multiple netns (for whatever reasons).
>
> _If_ a packet is locally 'consumed' (like on loopback device, or veth pair),
> then the skb_orphan() will automatically be done.
>
> If you have a case where this skb_orphan() is needed, please add it at the needed place.


With this, a netns could totally throttle a TCP socket in a different
netns by holding the packets infinitely (e.g. putting them in a loop).
This is where the isolation breaks.
