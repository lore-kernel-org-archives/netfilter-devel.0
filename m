From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH next 17/30] arp: Introduce arp_xmit_finish
Date: Tue, 15 Sep 2015 20:04:05 -0500
Message-ID: <1442365458-16349-17-git-send-email-ebiederm@xmission.com>
References: <87mvwn18my.fsf@x220.int.ebiederm.org>
Cc: netfilter-devel@vger.kernel.org, <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87mvwn18my.fsf@x220.int.ebiederm.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The function dev_queue_xmit_skb_sk is unncessary and very confusing.
Introduce arp_xmit_finish to remove the need for dev_queue_xmit_skb_sk,
and have arp_xmit_finish call dev_queue_xmit.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/ipv4/arp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 30409b75e925..3632e98eb0f9 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -621,6 +621,11 @@ out:
 }
 EXPORT_SYMBOL(arp_create);
 
+static int arp_xmit_finish(struct sock *sk, struct sk_buff *skb)
+{
+	return dev_queue_xmit(skb);
+}
+
 /*
  *	Send an arp packet.
  */
@@ -628,7 +633,7 @@ void arp_xmit(struct sk_buff *skb)
 {
 	/* Send it off, maybe filter it using firewalling first.  */
 	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT, NULL, skb,
-		NULL, skb->dev, dev_queue_xmit_sk);
+		NULL, skb->dev, arp_xmit_finish);
 }
 EXPORT_SYMBOL(arp_xmit);
 
-- 
2.2.1
