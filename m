From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
 not
Date: Wed, 14 Sep 2005 04:52:08 +0200
Message-ID: <43279058.1080200@trash.net>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>	<20050912.151120.104514011.davem@davemloft.net>	<87br2xap9o.fsf@aka.i.naked.iki.fi>	<877jdl9r1u.fsf@aka.i.naked.iki.fi>
	<4326FF69.9060004@trash.net> <873bo8akvk.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000808050808060500050208"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nuutti Kotivuori <naked@iki.fi>
In-Reply-To: <873bo8akvk.fsf@aka.i.naked.iki.fi>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000808050808060500050208
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Nuutti Kotivuori wrote:
> Patrick McHardy wrote:
> 
>>What kind of packet is this? And what kernel version are you
>>running? Until recently ip_conntrack did some fiddling with skb->sk
>>which could lead to a packet on the output path with skb->sk set but
>>no reference taken.
> 
> This happens on Red Hat Enterprise Linux 4, with a 2.6.9 kernel (with
> a gazillion of Red Hat patches in it, latest ones being from 2.6.11)
> and the ip_queue patch that adds the bottom-half disabling. I will
> know for sure tomorrow, but it seems that it doesn't appear on vanilla
> 2.6.13.1 or without SMP.

Hmm .. I don't want to spend time fixing bugs already fixed, so it
would be good if you could confirm that the bug still exists in the
current vanilla kernel.

> It is very hard to know which packet specifically triggers this. The
> machine is under heavy load in general, a lot of packets are handled
> via a QUEUE target, and some packets are captured via packet socket.

It happens when reinjecting the packet, adding some debug code to
ipq_issue_verdict should work.

> I will post more details tomorrow, but if you could point me towards
> the changes in ip_conntrack that affected this, it would be very
> helpful. I could check if they are in the Red Hat kernel and if not,
> patch them manually and see if it makes a difference. The problem is
> now reproduciable in a couple hours, so it shouldn't be too hard.

I've attached the patch.

--------------000808050808060500050208
Content-Type: text/plain;
 name="X"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="X"

[NETFILTER]: Do not be clever about SKB ownership in ip_ct_gather_frags().

Just do an skb_orphan() and be done with it.
Based upon discussions with Herbert Xu on netdev.

Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 8be58932ca596972e4953ae980d8bc286857cae8
tree 44ee4e92a652bdbc3f3f368bc8f253ce9539a13a
parent d9fa0f392b20b2b8e3df379c44194492a2446c6e
author David S. Miller <davem@davemloft.net> Thu, 19 May 2005 12:36:33 -0700
committer David S. Miller <davem@davemloft.net> Thu, 19 May 2005 12:36:33 -0700

 net/ipv4/netfilter/ip_conntrack_core.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -940,37 +940,25 @@ void ip_ct_refresh_acct(struct ip_conntr
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
-	struct sock *sk = skb->sk;
 #ifdef CONFIG_NETFILTER_DEBUG
 	unsigned int olddebug = skb->nf_debug;
 #endif
 
-	if (sk) {
-		sock_hold(sk);
-		skb_orphan(skb);
-	}
+	skb_orphan(skb);
 
 	local_bh_disable(); 
 	skb = ip_defrag(skb, user);
 	local_bh_enable();
 
-	if (!skb) {
-		if (sk)
-			sock_put(sk);
-		return skb;
-	}
-
-	if (sk) {
-		skb_set_owner_w(skb, sk);
-		sock_put(sk);
-	}
-
-	ip_send_check(skb->nh.iph);
-	skb->nfcache |= NFC_ALTERED;
+	if (skb) {
+		ip_send_check(skb->nh.iph);
+		skb->nfcache |= NFC_ALTERED;
 #ifdef CONFIG_NETFILTER_DEBUG
-	/* Packet path as if nothing had happened. */
-	skb->nf_debug = olddebug;
+		/* Packet path as if nothing had happened. */
+		skb->nf_debug = olddebug;
 #endif
+	}
+
 	return skb;
 }
 

--------------000808050808060500050208--
