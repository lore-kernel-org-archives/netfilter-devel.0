From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/05]: ip_tables: compat error way cleanup
Date: Mon, 30 Oct 2006 19:19:00 +0100 (MET)
Message-ID: <20061030181857.32038.43247.sendpatchset@localhost.localdomain>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_tables: compat error way cleanup

This patch adds forgotten compat_flush_offset() call to error way of
translate_compat_table().  May lead to table corruption on the next
compat_do_replace().

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Dmitry Mishin <dim@openvz.org>
Acked-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2e3d7fd325d9327881f17aec50619caaf1aeab00
tree a2f9d2588fbe0740bab2df52a45a44539a9b6488
parent b59a94e9119db15b4d28869997f615f236081e58
author Vasily Averin <vvs@openvz.org> Mon, 30 Oct 2006 16:28:51 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 30 Oct 2006 16:28:51 +0100

 net/ipv4/netfilter/ip_tables.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e2c7f6e..0f4835c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1725,6 +1725,7 @@ free_newinfo:
 out:
 	return ret;
 out_unlock:
+	compat_flush_offsets();
 	xt_compat_unlock(AF_INET);
 	goto out;
 }
