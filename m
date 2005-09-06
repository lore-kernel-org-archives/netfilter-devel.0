From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 8/8]: Missing unlock in TCP connection tracking error
 path
Date: Tue, 06 Sep 2005 19:55:52 +0200
Message-ID: <431DD828.2050207@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="08.diff"
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

[NETFILTER]: Missing unlock in TCP connection tracking error path

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 74429d5859618a299a503db33160f27b37956bc5
tree ef0f565b47798d08ffd517c05ec6da4bdbed2acf
parent d6a220e261a31f34b644112192cc2d86278ee326
author Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 20:07:33 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 20:07:33 +0200

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -349,6 +349,7 @@ static int tcp_to_nfattr(struct sk_buff 
 	return 0;
 
 nfattr_failure:
+	read_unlock_bh(&tcp_lock);
 	return -1;
 }
 #endif
