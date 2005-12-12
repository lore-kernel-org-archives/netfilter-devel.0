From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: ip_nat_tftp: Fix expectation NAT
Date: Mon, 12 Dec 2005 08:32:31 +0100
Message-ID: <439D278F.9010802@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000606050902090802020203"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------000606050902090802020203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

a small patch to fix TFTP SNAT. Please apply to your 2.6.15 tree
unless it's already out :)


--------------000606050902090802020203
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ip_nat_tftp: Fix expectation NAT

When a TFTP client is SNATed so that the port is also changed, the
port is never changed back for the expected connection.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8c0bf4aae720eeec4fea59aad4b93258441be231
tree 48a8a73103df0a89bebefdb20a3baacd913b4ecf
parent 67121172f9753f38689651b613a4850e0e75876f
author Marcus Sundberg <marcus@ingate.com> Mon, 12 Dec 2005 08:06:56 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Dec 2005 08:06:56 +0100

 net/ipv4/netfilter/ip_nat_tftp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_tftp.c b/net/ipv4/netfilter/ip_nat_tftp.c
index 2215317..43c3bd7 100644
--- a/net/ipv4/netfilter/ip_nat_tftp.c
+++ b/net/ipv4/netfilter/ip_nat_tftp.c
@@ -42,7 +42,10 @@ static unsigned int help(struct sk_buff 
 			 enum ip_conntrack_info ctinfo,
 			 struct ip_conntrack_expect *exp)
 {
-	exp->saved_proto.udp.port = exp->tuple.dst.u.tcp.port;
+	struct ip_conntrack *ct = exp->master;
+
+	exp->saved_proto.udp.port
+		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = ip_nat_follow_master;
 	if (ip_conntrack_expect_related(exp) != 0)

--------------000606050902090802020203--
