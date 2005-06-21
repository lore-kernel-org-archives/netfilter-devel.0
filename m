From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 8/7]: Drop conntrack reference in
	ip_call_ra_chain()/ip_mr_input()
Date: Tue, 21 Jun 2005 17:45:09 +0200
Message-ID: <42B83605.5020902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080808060900080006010101"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------080808060900080006010101
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Drop reference before handing packets to raw_rcv to avoid module
unload problems.



--------------080808060900080006010101
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.diff"

[NETFILTER]: Drop conntrack reference in ip_call_ra_chain()/ip_mr_input()

Drop reference before handing the packets to raw_rcv()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 043f4df110b0be9f82a5ddaeede9be7f7ae4c894
tree 52e36aa9adea79ec2201a881abc327aeb870f837
parent d7edb3501fc521edf0d856d30fd6bad8019ed369
author Patrick McHardy <kaber@trash.net> Tue, 21 Jun 2005 17:43:58
committer Patrick McHardy <kaber@trash.net> Tue, 21 Jun 2005 17:43:58

 net/ipv4/ip_input.c |    1 +
 net/ipv4/ipmr.c     |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -184,6 +184,7 @@ int ip_call_ra_chain(struct sk_buff *skb
 					raw_rcv(last, skb2);
 			}
 			last = sk;
+			nf_reset(skb);
 		}
 	}
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1350,6 +1350,7 @@ int ip_mr_input(struct sk_buff *skb)
 			     */
 			    read_lock(&mrt_lock);
 			    if (mroute_socket) {
+				    nf_reset(skb);
 				    raw_rcv(mroute_socket, skb);
 				    read_unlock(&mrt_lock);
 				    return 0;

--------------080808060900080006010101--
