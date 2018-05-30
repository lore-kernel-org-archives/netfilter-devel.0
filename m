From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Missing skb->dst with flow offloading
Date: Wed, 30 May 2018 20:24:42 +0200
Message-ID: <20180530182442.wbgke26kaoau2du2@salvia>
References: <CAHmME9que7BqU9sJcmtSpBoHTs8=kybvDZAT_Ai151qZQOCscA@mail.gmail.com>
 <20180530180547.kn4cikprj7drhlc3@salvia>
 <CAHmME9p-Wdsd7=BaQJSnPKyPc+xyQkdMLGUz48O5b7yVwAmHzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        Jaap Buurman <jaapbuurman@gmail.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9p-Wdsd7=BaQJSnPKyPc+xyQkdMLGUz48O5b7yVwAmHzg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 30, 2018 at 08:14:42PM +0200, Jason A. Donenfeld wrote:
> Hey Pablo,
> 
> On Wed, May 30, 2018 at 8:05 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If there a more drivers in-tree that need this, we may add
> > skb_dst_set_noref() calls to _hook function in the flowtable codebase.
> 
> Can I, then, take that as an implicit acknowledgement that this
> observed behavior on OpenWRT is to be expected with the current state
> of events, and that I should patch my driver accordingly?
> 
> As one example of this in tree, take a look at vxlan -- it's using it
> for the mtu/pmtu exactly as WireGuard does.

May it crash the kernel because it's assuming is set? If so, then
I'd appreciate if you send us a patch to
netfilter-devel@vger.kernel.org.

Please, use the nf-next.git tree to patch nf_flow_offload_ip_hook()
and nf_flow_offload_ip6_hook(), it's rather late, we'll request a
-stable submission for this if needed.

Thanks.
