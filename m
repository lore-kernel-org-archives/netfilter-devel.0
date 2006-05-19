From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 5/*]: nfnetlink_log: fix byteorder confusion
Date: Fri, 19 May 2006 03:21:54 +0200
Message-ID: <446D1DB2.5000604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: nfnetlink_log: fix byteorder confusion

flags is a u16, so use htons instead of htonl. Also avoid double
conversion.

Noticed by Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ad1dcdc1f150f613ff8625fed88ed5c1d089d09a
tree fa34bb52998bd56144639dfe6b2c286b114ae59a
parent f372e5df6ab4cd1e1498489562af2095fb5aec7c
author Patrick McHardy <kaber@trash.net> Fri, 19 May 2006 03:12:08 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 19 May 2006 03:12:08 +0200

 net/netfilter/nfnetlink_log.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c60273c..61cdda4 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -321,7 +321,7 @@ static int
 nfulnl_set_flags(struct nfulnl_instance *inst, u_int16_t flags)
 {
 	spin_lock_bh(&inst->lock);
-	inst->flags = ntohs(flags);
+	inst->flags = flags;
 	spin_unlock_bh(&inst->lock);
 
 	return 0;
@@ -902,7 +902,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 	if (nfula[NFULA_CFG_FLAGS-1]) {
 		u_int16_t flags =
 			*(u_int16_t *)NFA_DATA(nfula[NFULA_CFG_FLAGS-1]);
-		nfulnl_set_flags(inst, ntohl(flags));
+		nfulnl_set_flags(inst, ntohs(flags));
 	}
 
 out_put:
