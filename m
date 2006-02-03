From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/14]: Fix missing src port initialization in tftp
	expectation mask
Date: Fri,  3 Feb 2006 14:44:09 +0100 (MET)
Message-ID: <20060203134409.2141.21676.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix missing src port initialization in tftp expectation mask

Reported by David Ahern <dahern@avaya.com>, netfilter bugzilla #426.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c84c986a5028347c036a1915a3320c51dd3be4a6
tree 702216309d0c48492f77f47ce2717671143eb876
parent 27a0e70cdd3fdf3988c94739ad75f6fc5d89c326
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:39:41 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:39:41 +0100

 net/ipv4/netfilter/ip_conntrack_tftp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip_conntrack_tftp.c
index d3c5a37..4ba4463 100644
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c
@@ -71,6 +71,7 @@ static int tftp_help(struct sk_buff **ps
 
 		exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 		exp->mask.src.ip = 0xffffffff;
+		exp->mask.src.u.udp.port = 0;
 		exp->mask.dst.ip = 0xffffffff;
 		exp->mask.dst.u.udp.port = 0xffff;
 		exp->mask.dst.protonum = 0xff;
