From: Flavio Leitner <fbl@redhat.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Tue, 26 Jun 2018 19:03:00 -0300
Message-ID: <20180626220300.GT19565@plex.lan>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
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
In-Reply-To: <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 26, 2018 at 02:48:47PM -0700, Cong Wang wrote:
> On Mon, Jun 25, 2018 at 11:41 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > When a packet is attached to a socket, we should keep the association as much as possible.
> 
> As much as possible within one stack, I agree. I still don't understand
> why we should keep it across the stack boundary.
> 
> > Only when a new association needs to be done, skb_orphan() needs to be called.
> >
> > Doing this skb_orphan() too soon breaks back pressure in general, this is bad, since a socket
> > can evades SO_SNDBUF limits.
> 
> Right before leaving the stack is not too soon, it is the latest
> actually, for veth case.

Depends on how you view things - it's the same host/stack sharing the
same resources, so why should we not keep it?

-- 
Flavio
