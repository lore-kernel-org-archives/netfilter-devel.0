From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK] convert nfmark and conntrack mark to 32bit in
 nf_conntrack
Date: Mon, 08 Aug 2005 17:40:46 +0900 (JST)
Message-ID: <200508080840.j788ekQd011697@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Aug__8_17_40_46_2005_493)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Mon_Aug__8_17_40_46_2005_493)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

This patch follows ip_conntrack change that converts nfmark and conntrack-mark
to be 32bits even on 64bit architectures, as discussed at netconf'05.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_Aug__8_17_40_46_2005_493)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-mark.patch"

[NETFILTER]: convert nfmark and conntrack mark to 32bit in nf_conntrack

This patch follows ip_conntrack change that converts nfmark and conntrack-mark
to be 32bits even on 64bit architectures, as discussed at netconf'05.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit e2549f67dccab385cec329cf16d4002773c3b88b
tree d3a4c51110eb26abdd6f09375d97c5a8c16afc84
parent 745bb895699402a7031588faa4f260afc656f4dd
author <kozakai@alprut.(none)> Mon, 08 Aug 2005 11:20:07 +0900
committer <kozakai@alprut.(none)> Mon, 08 Aug 2005 11:20:07 +0900

 include/linux/netfilter/nf_conntrack.h  |    2 +-
 net/netfilter/nf_conntrack_standalone.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilter/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -104,7 +104,7 @@ struct nf_conn
 	union nf_conntrack_proto proto;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	unsigned long mark;
+	u_int32_t mark;
 #endif
 
 	/* These members are dynamically allocated. */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -209,7 +209,7 @@ static int ct_seq_show(struct seq_file *
 			return -ENOSPC;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%lu ", conntrack->mark))
+	if (seq_printf(s, "mark=%u ", conntrack->mark))
 		return -ENOSPC;
 #endif
 

----Next_Part(Mon_Aug__8_17_40_46_2005_493)----
