From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/20]: nf_conntrack: mark helpers __read_mostly
Date: Fri, 29 Jun 2007 02:45:18 +0200 (MEST)
Message-ID: <20070629004417.25566.79781.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: mark helpers __read_mostly

Most are __read_mostly already, this changes the remaining ones.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5c63a5d17f6f9e49fcdfa80e1b86c281fa496e34
tree d87f7396f142c07ee49fa9e237db80143ffa3e9c
parent 8e5b66513e419d6d9a2ce3afb200096b66e65d57
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:57 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:57 +0200

 net/netfilter/nf_conntrack_ftp.c  |    4 ++--
 net/netfilter/nf_conntrack_sane.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 198330b..cd9c2d0 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -518,8 +518,8 @@ out_update_nl:
 	return ret;
 }
 
-static struct nf_conntrack_helper ftp[MAX_PORTS][2];
-static char ftp_names[MAX_PORTS][2][sizeof("ftp-65535")];
+static struct nf_conntrack_helper ftp[MAX_PORTS][2] __read_mostly;
+static char ftp_names[MAX_PORTS][2][sizeof("ftp-65535")] __read_mostly;
 
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index edd10df..627eda7 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -166,8 +166,8 @@ out:
 	return ret;
 }
 
-static struct nf_conntrack_helper sane[MAX_PORTS][2];
-static char sane_names[MAX_PORTS][2][sizeof("sane-65535")];
+static struct nf_conntrack_helper sane[MAX_PORTS][2] __read_mostly;
+static char sane_names[MAX_PORTS][2][sizeof("sane-65535")] __read_mostly;
 
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
