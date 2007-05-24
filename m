From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/07]: nf_conntrack_ftp: fix newline sequence number
	update
Date: Fri, 25 May 2007 00:02:07 +0200 (MEST)
Message-ID: <20070524215835.14308.87748.sendpatchset@localhost.localdomain>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ftp: fix newline sequence number update

When trying to locate the oldest entry in the history of newline character
sequence numbers, the sequence number of the current entry is incorrectly
compared with the index of the oldest sequence number instead of the number
itself.

Additionally it is not made sure that the current sequence number really
is after the oldest known one.

Based on report by YU, Haitao <yuhaitao@tsinghua.org.cn>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5e09b4a295e2aed7cb6fe60f86bafba4d8e77836
tree fb2d6e90d04c155578a5fe3321f9b2297426bdee
parent 0076b2cfaee8fa7109d6c923144b88f0032ffb8b
author Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:57 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:57 +0200

 net/netfilter/nf_conntrack_ftp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a186799..3357642 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -335,15 +335,17 @@ static void update_nl_seq(u32 nl_seq, struct nf_ct_ftp_master *info, int dir,
 		if (info->seq_aft_nl[dir][i] == nl_seq)
 			return;
 
-		if (oldest == info->seq_aft_nl_num[dir]
-		    || before(info->seq_aft_nl[dir][i], oldest))
+		if (oldest == info->seq_aft_nl_num[dir] ||
+		    before(info->seq_aft_nl[dir][i],
+		    	   info->seq_aft_nl[dir][oldest]))
 			oldest = i;
 	}
 
 	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
 		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
-	} else if (oldest != NUM_SEQ_TO_REMEMBER) {
+	} else if (oldest != NUM_SEQ_TO_REMEMBER &&
+		   after(nl_seq, info->seq_aft_nl[dir][oldest])) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
 		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
 	}
