From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Missing skb->dst with flow offloading
Date: Wed, 30 May 2018 20:14:42 +0200
Message-ID: <CAHmME9p-Wdsd7=BaQJSnPKyPc+xyQkdMLGUz48O5b7yVwAmHzg@mail.gmail.com>
References: <CAHmME9que7BqU9sJcmtSpBoHTs8=kybvDZAT_Ai151qZQOCscA@mail.gmail.com>
 <20180530180547.kn4cikprj7drhlc3@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
 Jaap Buurman <jaapbuurman@gmail.com>, openwrt-devel@lists.openwrt.org,
 WireGuard mailing list <wireguard@lists.zx2c4.com>,
 Felix Fietkau <nbd@nbd.name>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <wireguard-bounces@lists.zx2c4.com>
In-Reply-To: <20180530180547.kn4cikprj7drhlc3@salvia>
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

Hey Pablo,

On Wed, May 30, 2018 at 8:05 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If there a more drivers in-tree that need this, we may add
> skb_dst_set_noref() calls to _hook function in the flowtable codebase.

Can I, then, take that as an implicit acknowledgement that this
observed behavior on OpenWRT is to be expected with the current state
of events, and that I should patch my driver accordingly?

As one example of this in tree, take a look at vxlan -- it's using it
for the mtu/pmtu exactly as WireGuard does.

Regards,
Jason
