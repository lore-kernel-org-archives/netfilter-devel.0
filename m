From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Missing skb->dst with flow offloading
Date: Wed, 30 May 2018 02:01:05 +0200
Message-ID: <CAHmME9que7BqU9sJcmtSpBoHTs8=kybvDZAT_Ai151qZQOCscA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
 Jaap Buurman <jaapbuurman@gmail.com>, openwrt-devel@lists.openwrt.org,
 WireGuard mailing list <wireguard@lists.zx2c4.com>,
 Felix Fietkau <nbd@nbd.name>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <wireguard-bounces@lists.zx2c4.com>
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

Some OpenWRT people have reported to me that there's a crash when
enabling flow offloading, because I rely on skb_dst(skb) being
non-null in ndo_start_xmit. The fix in my code for this is very
simple:

- mtu = dst_mtu(skb_dst(skb));
+ dst = skb_dst(skb);
+ mtu = dst ? dst_mtu(dst) : dev->mtu;

I can make this change, but I wanted to be certain first that omitting
the dst in the skb is intentional on your part. (If so, there might be
other drivers to fix as well.) In tracing this, it looks like a packet
that's forwarded from a flow offloaded interface to a virtual
interface gets diverted immediately via neigh_xmit, where it is then
passed to a virtual interface via dev_queue_xmit. I can't see anywhere
along this path a call to skb_dst_set. Perhaps this is intended, as
flow offloading is supposed to skip the routing table? Or is there an
oversight in the new flow offloading code?

I'd appreciate your input, so that I can make the appropriate change
-- or not -- to my code.

Regards,
Jason
