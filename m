From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Tue, 26 Jun 2018 16:53:55 -0700
Message-ID: <aae3fa15-598b-342d-20c7-23ed4b9faf84@gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <CAM_iQpU0jp=wvutGbSLzVYX5qQeW0W8ARvR=-gp4MYJqWeee_A@mail.gmail.com>
 <20180626220300.GT19565@plex.lan>
 <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>,
        Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpU8E5OuXx87Dm+jbqwbkkwETNF_RZh-VnUkF5seFPvv_A@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/26/2018 03:47 PM, Cong Wang wrote:
> 
> You need to justify why you want to break the TSQ's scope here,
> which is obviously not compatible with netns design.

You have to explain why you do not want us to fix this buggy behavior.

Right now TSQ (and more generally back pressure) is broken by this skb_orphan()

So we want to restore TSQ (and back pressure)

TSQ scope never mentioned netns.
We (TCP stack TSQ handler) want to be notified when this packet leaves the host,
even if it had to traverse multiple netns (for whatever reasons).

_If_ a packet is locally 'consumed' (like on loopback device, or veth pair),
then the skb_orphan() will automatically be done.

If you have a case where this skb_orphan() is needed, please add it at the needed place.
