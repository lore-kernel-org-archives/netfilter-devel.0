From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/33]: nf_conntrack_ftp: fix missing helper mask
	initilization
Date: Wed, 29 Nov 2006 03:09:02 +0100 (MET)
Message-ID: <20061129020901.21082.54599.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ftp: fix missing helper mask initilization

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7aeb0641e3f08db8639b8fd67723d9b24907063d
tree dc2516c0bd1ffbf60a62f5e4d6597ca9c1c34b47
parent 5a564daecd5e2cf14dfc657b5fcdb91218324e90
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:17 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:12:50 +0100

 net/netfilter/nf_conntrack_ftp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 10836fc..05cb78c 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -586,6 +586,7 @@ static int __init nf_conntrack_ftp_init(
 		for (j = 0; j < 2; j++) {
 			ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
 			ftp[i][j].tuple.dst.protonum = IPPROTO_TCP;
+			ftp[i][j].mask.src.l3num = 0xFFFF;
 			ftp[i][j].mask.src.u.tcp.port = 0xFFFF;
 			ftp[i][j].mask.dst.protonum = 0xFF;
 			ftp[i][j].max_expected = 1;
