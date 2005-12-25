From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/1] libnetfilter_conntrack: fix dumping IPv6 connections
Date: Sun, 25 Dec 2005 16:37:01 +0900 (JST)
Message-ID: <200512250737.jBP7b2hO014874@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
Content-Disposition: inline; filename="03-print-ipv6.patch"
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

[LIBNETFILTER_CONNTRACK] fix dumping IPv6 connections

This fixes the pointer in buffer to store string of destination IPv6 address.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit bba29364ec6e748f13d3716b4ac6a106129db77b
tree 408da04573587211aba8daecba4bfeaf5ca22d3a
parent 0e9369e5c20fb9fe185ec792a75d65909faa8bb5
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 24 Dec 2005 04:56:19 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 24 Dec 2005 04:56:19 +0900

 l3extensions/libnetfilter_conntrack_ipv6.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/l3extensions/libnetfilter_conntrack_ipv6.c b/l3extensions/libnetfilter_conntrack_ipv6.c
index a2a694f..023a5af 100644
--- a/l3extensions/libnetfilter_conntrack_ipv6.c
+++ b/l3extensions/libnetfilter_conntrack_ipv6.c
@@ -50,7 +50,7 @@ static int print_proto(char *buf, struct
 	inet_ntop(AF_INET6, &src, tmp, sizeof(tmp));
 	size = sprintf(buf, "src=%s ", tmp);
 	inet_ntop(AF_INET6, &dst, tmp, sizeof(tmp));
-	size += sprintf(buf, "dst=%s ", tmp);
+	size += sprintf(buf + size, "dst=%s ", tmp);
 
 	return size;
 }
