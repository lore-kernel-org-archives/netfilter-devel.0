From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 4/4] kill unnecessary ntohs() for payload length
Date: Sat, 08 Oct 2005 20:18:57 +0900 (JST)
Message-ID: <200510081118.j98BIw2g018235@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Oct__8_20_18_57_2005_561)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Sat_Oct__8_20_18_57_2005_561)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Probably I forgot delete it when replaced tot_len with generic calculation.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Oct__8_20_18_57_2005_561)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-ntohs.patch"

[NETFILTER] kill unnecessary ntohs() for payload length of packet

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit ce0da494f68d60107ae8b302e1a51c8dd6c1d4df
tree 1cc8783292a8c7ac611b495c562c8310b4a0c16f
parent a2e91360ab67898da19d503a21ce2b425951bc7a
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:29:20 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:29:20 +0900

 net/netfilter/nf_conntrack_core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1276,8 +1276,7 @@ void __nf_ct_refresh_acct(struct nf_conn
 	if (do_acct) {
 		ct->counters[CTINFO2DIR(ctinfo)].packets++;
 		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
-				ntohs(skb->len - (unsigned int)(skb->nh.raw
-								- skb->data));
+			skb->len - (unsigned int)(skb->nh.raw - skb->data);
 	if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
 	    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
 		event |= IPCT_COUNTER_FILLING;

----Next_Part(Sat_Oct__8_20_18_57_2005_561)----
