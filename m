From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 1/4]: Fix HW checksum handling in ip_queue/ip6_queue
Date: Fri, 26 Aug 2005 18:45:22 +0200
Message-ID: <430F4722.80808@trash.net>
References: <4309166D.9010706@trash.net>
	<20050826111137.GS4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030504090806060908020808"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050826111137.GS4226@rama.de.gnumonks.org>
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
--------------030504090806060908020808
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> I think we're going to need the same fix for nfnetlink_queue, too.  I'm
> not sure whether I could just copy+paste your code into the respective
> section of the code, or whether there are some other issues that need to
> be thought of, like "Is skb->ip_summed valid for non-ip-packets?".
> 
> Please advise or propose a patch, thanks!

The same fix is fine for nfnetlink_queue, protocols that don't support
HW checksumming ip_summed is set to CHECKSUM_NONE and the fix does
nothing.


--------------030504090806060908020808
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix HW checksum handling in nfnetlink_queue

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fd32f6a1bad85e74e72ac603bce19da767b5928f
tree c69f2224f141fbb6085f9576a7b67a833f9a3d80
parent c233e993bb49e007b667659243f344172768a6c8
author Patrick McHardy <kaber@trash.net> Fri, 26 Aug 2005 18:43:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 26 Aug 2005 18:43:17 +0200

 net/netfilter/nfnetlink_queue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -382,6 +382,12 @@ nfqnl_build_packet_message(struct nfqnl_
 		break;
 	
 	case NFQNL_COPY_PACKET:
+		if (entry->skb->ip_summed == CHECKSUM_HW &&
+		    (*errp = skb_checksum_help(entry->skb,
+		                               entry->info->outdev == NULL))) {
+			spin_unlock_bh(&queue->lock);
+			return NULL;
+		}
 		if (queue->copy_range == 0 
 		    || queue->copy_range > entry->skb->len)
 			data_len = entry->skb->len;
@@ -647,7 +653,7 @@ nfqnl_mangle(void *data, int data_len, s
 	if (!skb_make_writable(&e->skb, data_len))
 		return -ENOMEM;
 	memcpy(e->skb->data, data, data_len);
-
+	e->skb->ip_summed = CHECKSUM_NONE;
 	return 0;
 }
 

--------------030504090806060908020808--
