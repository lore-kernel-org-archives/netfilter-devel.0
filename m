From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/08]: ip_tables: compat error way cleanup
Date: Fri, 17 Nov 2006 06:35:42 +0100 (MET)
Message-ID: <20061117053542.10231.61123.sendpatchset@localhost.localdomain>
References: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
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
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit efb1447a67abac93048ad7af0c59cd9b5a9177a6
tree 9d56a6e758a3ad0e617f2527ac4b4efdeba5b64a
parent 4410392a8258fd972fc08a336278b14c82b2774f
author Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:22:39 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:22:39 +0100

 net/ipv4/netfilter/ip_tables.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c64340b..c2ba077 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1775,6 +1775,7 @@ free_newinfo:
 out:
 	return ret;
 out_unlock:
+	compat_flush_offsets();
 	xt_compat_unlock(AF_INET);
 	goto out;
 }
