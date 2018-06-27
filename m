From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Wed, 27 Jun 2018 11:59:59 -0700
Message-ID: <CAM_iQpUnyVHPb96TTNeNo0Ydu9D9s4HqVMwr-YX822euSPXngw@mail.gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com> <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com> <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan> <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
 <aae3fa15-598b-342d-20c7-23ed4b9faf84@gmail.com> <CAM_iQpUOvavz580tJHCXhAR6AMprmFvakqiaiVMYe7NLFvFJ0Q@mail.gmail.com>
 <d1818974-5445-4dc2-1c3c-2b67d2826d6f@gmail.com>
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
In-Reply-To: <d1818974-5445-4dc2-1c3c-2b67d2826d6f@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 26, 2018 at 7:35 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 06/26/2018 05:44 PM, Cong Wang wrote:
>
> > With this, a netns could totally throttle a TCP socket in a different
> > netns by holding the packets infinitely (e.g. putting them in a loop).
> > This is where the isolation breaks.
> >
>
> That is fine, really. Admin error -> Working as intended.

The point is never it is an error or not, the point is one netns could
influence another one with this change.

>
> The current scrubbing is simply wrong, not documented, and added by someone
> who had absolutely not intended all the side effects.
>

IIRC, this skb_orphan() was introduced much earlier than TSQ, probably
from the beginning of veth.

Leaving the stack should be effectively equivalent to leaving the host,
from the view of network isolation.
