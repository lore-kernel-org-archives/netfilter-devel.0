From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: preserve sock reference when scrubbing the
 skb.
Date: Tue, 26 Jun 2018 06:06:36 -0700
Message-ID: <afa1296b-9c3a-a60c-da69-76c3fd031bbe@gmail.com>
References: <20180625155610.30802-1-fbl@redhat.com>
 <CAM_iQpX_X4hhSSrhMZavLibobp6tgMEa_26T6j4QvACKg-HPvw@mail.gmail.com>
 <48e15faf-f935-0166-e1db-18f7286e7264@gmail.com>
 <20180626123805.GK19565@plex.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: Flavio Leitner <fbl@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180626123805.GK19565@plex.lan>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/26/2018 05:38 AM, Flavio Leitner wrote:
> On Mon, Jun 25, 2018 at 11:41:05PM -0700, Eric Dumazet wrote:
>> I am not sure why the patch is so complex, I would have simply
>> removed the skb_orphan().
> 
> All the rest is fixing netfilter to consider the namespaces before
> doing any actions.  For instance, it would be possible to dump GID/UID
> of the process originating the packet in a foreign net namespace.
> 
> Another example is matching if it has a socket or not. I don't think
> it's correct to match on a socket that is on a foreign netns.
> 
> So, you're right that removing the skb_orphan() is the only thing
> required to fix both issues, but then what about the above examples?
> 

Please split the work in two parts.

1) Preparation, with clear commit log :)

2) Removal of skb_orphan()

Thanks !
