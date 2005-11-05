From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 1/2] nf_conntrack: remove nf_conntrack stat proc file when
	cleaning up
Date: Sat, 5 Nov 2005 12:49:06 +0100
Message-ID: <200511051249.06265@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ywJbD1W+lTmYj5s"
Cc: Harald Welte <laforge@netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_ywJbD1W+lTmYj5s
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  nf_conntrack does not properly remove /proc/net/stat/nf_conntrack when 
cleaning up. The attached patch seems to solve (at least in nfsim).

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_ywJbD1W+lTmYj5s
Content-Type: text/x-diff; charset="us-ascii";
	name="02-nf_conntrack-remove_stat_proc_file.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="02-nf_conntrack-remove_stat_proc_file.patch"

[NETFILTER] Remove nf_conntrack stat proc file when cleaning up

Fix nf_conntrack statistics proc file removal. Looks like the old bug
was forward-ported from ip_conntrack. :-]

Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>

---
commit d9c38734c90540ea7c8fb5eb11ff77c05d6dbb40
tree 17fd2f4b3de0ef4b9dc52dc8cbe35924c7482f25
parent a3d662dd415a847d60097d17d6f634429b886b8f
author KOVACS Krisztian <hidden@balabit.hu> Fri, 04 Nov 2005 11:35:48 +0100
committer KOVACS Krisztian <hidden@balabit.hu> Fri, 04 Nov 2005 11:35:48 +0100

 net/netfilter/nf_conntrack_standalone.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d2ea098..3dd65fe 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -694,7 +694,7 @@ static int init_or_cleanup(int init)
  cleanup_proc_stat:
 #endif
 #ifdef CONFIG_PROC_FS
-	proc_net_remove("nf_conntrack_stat");
+	remove_proc_entry("nf_conntrack", proc_net_stat);
  cleanup_proc_exp:
 	proc_net_remove("nf_conntrack_expect");
  cleanup_proc:

--Boundary-00=_ywJbD1W+lTmYj5s--
