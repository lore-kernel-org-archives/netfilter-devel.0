From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/14]: nf_conntrack: fix incorrect memset() size in FTP
	helper
Date: Fri,  3 Feb 2006 14:44:12 +0100 (MET)
Message-ID: <20060203134412.2141.64227.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix incorrect memset() size in FTP helper

This memset() is executing with a bad size. According to Yasuyuki Kozakai,
this memset() can be deleted, as 'ftp' is declared in global area.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 37c30c251f15cb0a38cd4065e178f11b6ed5c145
tree b90f3490836911084280f7fbe7f77d6ebc6bdc83
parent 94b31e7f3e367691f07b3497b64562d31a0b2e29
author Samir Bellabes <sbellabes@mandriva.com> Fri, 03 Feb 2006 12:42:07 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:42:07 +0100

 net/netfilter/nf_conntrack_ftp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index ab0c920..6f210f3 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -657,8 +657,6 @@ static int __init init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		memset(&ftp[i], 0, sizeof(struct nf_conntrack_helper));
-
 		ftp[i][0].tuple.src.l3num = PF_INET;
 		ftp[i][1].tuple.src.l3num = PF_INET6;
 		for (j = 0; j < 2; j++) {
