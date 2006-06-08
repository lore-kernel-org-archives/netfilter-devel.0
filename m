From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.18 2/3]: recent match: missing refcnt initialization
Date: Thu, 08 Jun 2006 09:11:59 +0200
Message-ID: <4487CDBF.6050101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: recent match: missing refcnt initialization

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 10263005af5814396b8263c1c2a4367d49548e13
tree a73003fe82e7b4546359d86f684b90b78a6aa504
parent 6812aa38ac35d6e819058d2273a6a7de091a2604
author Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 16:49:58 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 16:49:58 +0200

 net/ipv4/netfilter/ipt_recent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 9b09e48..61a2139 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -262,6 +262,7 @@ ipt_recent_checkentry(const char *tablen
 		    GFP_KERNEL);
 	if (t == NULL)
 		goto out;
+	t->refcnt = 1;
 	strcpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
 	for (i = 0; i < ip_list_hash_size; i++)
