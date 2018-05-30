From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Missing skb->dst with flow offloading
Date: Wed, 30 May 2018 20:30:03 +0200
Message-ID: <CAHmME9qmurA1DJ=VaAnwu78OgHM5DQg7iZpoR+oh2s7pHs+inA@mail.gmail.com>
References: <CAHmME9que7BqU9sJcmtSpBoHTs8=kybvDZAT_Ai151qZQOCscA@mail.gmail.com>
 <20180530180547.kn4cikprj7drhlc3@salvia>
 <CAHmME9p-Wdsd7=BaQJSnPKyPc+xyQkdMLGUz48O5b7yVwAmHzg@mail.gmail.com>
 <20180530182442.wbgke26kaoau2du2@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
 Jaap Buurman <jaapbuurman@gmail.com>, openwrt-devel@lists.openwrt.org,
 WireGuard mailing list <wireguard@lists.zx2c4.com>,
 Felix Fietkau <nbd@nbd.name>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <wireguard-bounces@lists.zx2c4.com>
In-Reply-To: <20180530182442.wbgke26kaoau2du2@salvia>
List-Unsubscribe: <https://lists.zx2c4.com/mailman/options/wireguard>,
 <mailto:wireguard-request@lists.zx2c4.com?subject=unsubscribe>
List-Archive: <http://lists.zx2c4.com/pipermail/wireguard/>
List-Post: <mailto:wireguard@lists.zx2c4.com>
List-Help: <mailto:wireguard-request@lists.zx2c4.com?subject=help>
List-Subscribe: <https://lists.zx2c4.com/mailman/listinfo/wireguard>,
 <mailto:wireguard-request@lists.zx2c4.com?subject=subscribe>
Errors-To: wireguard-bounces@lists.zx2c4.com
Sender: "WireGuard" <wireguard-bounces@lists.zx2c4.com>
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 30, 2018 at 8:24 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> May it crash the kernel because it's assuming is set? If so, then
> I'd appreciate if you send us a patch to

I suspect it won't crash, but the pmtu might wind up wrong / not calculated.

> Please, use the nf-next.git tree to patch nf_flow_offload_ip_hook()
> and nf_flow_offload_ip6_hook(), it's rather late, we'll request a
> -stable submission for this if needed.

Given the above, I'll submit a patch, though I don't suppose it will
be necessary for -stable.
