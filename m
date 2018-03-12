From: Joe Perches <joe@perches.com>
Subject: [PATCH] net: drivers/net: Remove unnecessary skb_copy_expand OOM messages
Date: Mon, 12 Mar 2018 08:07:12 -0700
Message-ID: <782fa75ab2e443d275f19d97f2f3a073b6074517.1520867179.git.joe@perches.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

skb_copy_expand without __GFP_NOWARN already does a dump_stack
on OOM so these messages are redundant.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 1 -
 drivers/net/usb/lg-vl600.c              | 6 +-----
 drivers/net/wimax/i2400m/usb-rx.c       | 3 ---
 drivers/net/wireless/ti/wl1251/tx.c     | 4 +---
 drivers/usb/gadget/function/f_eem.c     | 1 -
 net/mac80211/rx.c                       | 5 +----
 net/netfilter/nfnetlink_queue.c         | 5 +----
 7 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 9c236298fe21..5803cd6db406 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -705,7 +705,6 @@ qcaspi_netdev_xmit(struct sk_buff *skb, struct net_device *dev)
 		tskb = skb_copy_expand(skb, QCAFRM_HEADER_LEN,
 				       QCAFRM_FOOTER_LEN + pad_len, GFP_ATOMIC);
 		if (!tskb) {
-			netdev_dbg(qca->net_dev, "could not allocate tx_buff\n");
 			qca->stats.out_of_mem++;
 			return NETDEV_TX_BUSY;
 		}
diff --git a/drivers/net/usb/lg-vl600.c b/drivers/net/usb/lg-vl600.c
index dbabd7ca5268..257916f172cd 100644
--- a/drivers/net/usb/lg-vl600.c
+++ b/drivers/net/usb/lg-vl600.c
@@ -157,12 +157,8 @@ static int vl600_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 		s->current_rx_buf = skb_copy_expand(skb, 0,
 				le32_to_cpup(&frame->len), GFP_ATOMIC);
-		if (!s->current_rx_buf) {
-			netif_err(dev, ifup, dev->net, "Reserving %i bytes "
-					"for packet assembly failed.\n",
-					le32_to_cpup(&frame->len));
+		if (!s->current_rx_buf)
 			dev->net->stats.rx_errors++;
-		}
 
 		return 0;
 	}
diff --git a/drivers/net/wimax/i2400m/usb-rx.c b/drivers/net/wimax/i2400m/usb-rx.c
index b78ee676e102..5b64bda7d9e7 100644
--- a/drivers/net/wimax/i2400m/usb-rx.c
+++ b/drivers/net/wimax/i2400m/usb-rx.c
@@ -263,9 +263,6 @@ struct sk_buff *i2400mu_rx(struct i2400mu *i2400mu, struct sk_buff *rx_skb)
 		new_skb = skb_copy_expand(rx_skb, 0, rx_size - rx_skb->len,
 					  GFP_KERNEL);
 		if (new_skb == NULL) {
-			if (printk_ratelimit())
-				dev_err(dev, "RX: Can't reallocate skb to %d; "
-					"RX dropped\n", rx_size);
 			kfree_skb(rx_skb);
 			rx_skb = NULL;
 			goto out;	/* drop it...*/
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index de2fa6705574..12ed14ebc307 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -221,10 +221,8 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 			struct sk_buff *newskb = skb_copy_expand(skb, 0, 3,
 								 GFP_KERNEL);
 
-			if (unlikely(newskb == NULL)) {
-				wl1251_error("Can't allocate skb!");
+			if (unlikely(newskb == NULL))
 				return -EINVAL;
-			}
 
 			tx_hdr = (struct tx_double_buffer_desc *) newskb->data;
 
diff --git a/drivers/usb/gadget/function/f_eem.c b/drivers/usb/gadget/function/f_eem.c
index 37557651b600..c13befa31110 100644
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -507,7 +507,6 @@ static int eem_unwrap(struct gether *port,
 						0,
 						GFP_ATOMIC);
 			if (unlikely(!skb3)) {
-				DBG(cdev, "unable to realign EEM packet\n");
 				dev_kfree_skb_any(skb2);
 				continue;
 			}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d01743234cf6..9c898a3688c6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2549,11 +2549,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	fwd_skb = skb_copy_expand(skb, local->tx_headroom +
 				       sdata->encrypt_headroom, 0, GFP_ATOMIC);
-	if (!fwd_skb) {
-		net_info_ratelimited("%s: failed to clone mesh frame\n",
-				    sdata->name);
+	if (!fwd_skb)
 		goto out;
-	}
 
 	fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
 	fwd_hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_RETRY);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 59e2833c17f1..9f572ed56208 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -833,11 +833,8 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
 		if (diff > skb_tailroom(e->skb)) {
 			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
 					       diff, GFP_ATOMIC);
-			if (!nskb) {
-				printk(KERN_WARNING "nf_queue: OOM "
-				      "in mangle, dropping packet\n");
+			if (!nskb)
 				return -ENOMEM;
-			}
 			kfree_skb(e->skb);
 			e->skb = nskb;
 		}
-- 
2.15.0
