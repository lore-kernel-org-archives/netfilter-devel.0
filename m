From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Missing skb->dst with flow offloading
Date: Wed, 30 May 2018 20:05:47 +0200
Message-ID: <20180530180547.kn4cikprj7drhlc3@salvia>
References: <CAHmME9que7BqU9sJcmtSpBoHTs8=kybvDZAT_Ai151qZQOCscA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        Jaap Buurman <jaapbuurman@gmail.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9que7BqU9sJcmtSpBoHTs8=kybvDZAT_Ai151qZQOCscA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jason,

On Wed, May 30, 2018 at 02:01:05AM +0200, Jason A. Donenfeld wrote:
> Hey Pablo,
> 
> Some OpenWRT people have reported to me that there's a crash when
> enabling flow offloading, because I rely on skb_dst(skb) being
> non-null in ndo_start_xmit. The fix in my code for this is very
> simple:
> 
> - mtu = dst_mtu(skb_dst(skb));
> + dst = skb_dst(skb);
> + mtu = dst ? dst_mtu(dst) : dev->mtu;
> 
> I can make this change, but I wanted to be certain first that omitting
> the dst in the skb is intentional on your part. (If so, there might be
> other drivers to fix as well.) In tracing this, it looks like a packet
> that's forwarded from a flow offloaded interface to a virtual
> interface gets diverted immediately via neigh_xmit, where it is then
> passed to a virtual interface via dev_queue_xmit. I can't see anywhere
> along this path a call to skb_dst_set. Perhaps this is intended, as
> flow offloading is supposed to skip the routing table? Or is there an
> oversight in the new flow offloading code?
> 
> I'd appreciate your input, so that I can make the appropriate change
> -- or not -- to my code.

If there a more drivers in-tree that need this, we may add
skb_dst_set_noref() calls to _hook function in the flowtable codebase.
