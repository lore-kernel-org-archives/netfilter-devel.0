From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Wed, 27 Jun 2018 12:33:19 -0700
Message-ID: <096ada36-8e05-c330-e5b3-3f6fcc77aea2@gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan>
 <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
 <aae3fa15-598b-342d-20c7-23ed4b9faf84@gmail.com>
 <CAM_iQpUOvavz580tJHCXhAR6AMprmFvakqiaiVMYe7NLFvFJ0Q@mail.gmail.com>
 <d1818974-5445-4dc2-1c3c-2b67d2826d6f@gmail.com>
 <CAM_iQpUnyVHPb96TTNeNo0Ydu9D9s4HqVMwr-YX822euSPXngw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Flavio Leitner <fbl@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpUnyVHPb96TTNeNo0Ydu9D9s4HqVMwr-YX822euSPXngw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/27/2018 11:59 AM, Cong Wang wrote:

> 
> IIRC, this skb_orphan() was introduced much earlier than TSQ, probably
> from the beginning of veth.

Sigh

SO_SNDBUF was invented years ago before veth.

You focus on TSQ while it is only one of the many things that are broken.

> 
> Leaving the stack should be effectively equivalent to leaving the host,
> from the view of network isolation.
> 


Having a UDP socket being able to burn a cpu and fill a qdisc is a major bug.

Bu default (blocking send() syscalls) the following loop should
block the thread if socket sk_wmem_alloc hits sk_sndbuf, this is
the beauty of backpressure.

while (1)
    send(fd, ...);  

With skb_orphan(), sk_wmem_alloc will stay around 0, so the loop will burn a cpu
and fill a qdisc, eventually breaking "network isolation", since other sockets
might be unable to send a single packet.

If you have a concrete case where the skb_orphan() is needed, then you will have
to add a parameter to let the admin opt-in for this.
