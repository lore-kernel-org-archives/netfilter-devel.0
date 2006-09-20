From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/39]: ip_tables: revision support for compat code
Date: Wed, 20 Sep 2006 10:24:14 +0200 (MEST)
Message-ID: <20060920082506.14636.60236.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_tables: revision support for compat code

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 26b5f5e93fbd2a19bf304b01e7e2eece398ba3a2
tree 3d190beda0a0fc29b4741b9cbc663a097b7590fc
parent 6f432129cbce18fb8d5de208e49552dcc473b4be
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:36:28 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:36:28 +0200

 net/ipv4/netfilter/ip_tables.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3d5d4a4..673581d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1994,6 +1994,8 @@ compat_get_entries(struct compat_ipt_get
 	return ret;
 }
 
+static int do_ipt_get_ctl(struct sock *, int, void __user *, int *);
+
 static int
 compat_do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
@@ -2007,8 +2009,7 @@ compat_do_ipt_get_ctl(struct sock *sk, i
 		ret = compat_get_entries(user, len);
 		break;
 	default:
-		duprintf("compat_do_ipt_get_ctl: unknown request %i\n", cmd);
-		ret = -EINVAL;
+		ret = do_ipt_get_ctl(sk, cmd, user, len);
 	}
 	return ret;
 }
