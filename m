From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/08]: Missing check for CAP_NET_ADMIN in iptables
	compat layer
Date: Fri, 17 Nov 2006 06:35:41 +0100 (MET)
Message-ID: <20061117053541.10231.82376.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_tables: missing check for CAP_NET_ADMIN in compat layer

The 32bit compatibility layer has no CAP_NET_ADMIN check in
compat_do_ipt_get_ctl, which for example allows to list the current
iptables rules even without having that capability (the non-compat
version requires it). Other capabilities might be required to exploit
the bug (eg. CAP_NET_RAW to get the nfnetlink socket?), so a plain user
can't exploit it, but a setup actually using the posix capability system
might very well hit such a constellation of granted capabilities.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 4410392a8258fd972fc08a336278b14c82b2774f
tree 567261d003b2a8fb08c2d89d0d708dd06f357f49
parent b4d854665eafe32b48e0eecadb91a73f6eea0055
author Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:22:07 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:22:07 +0100

 net/ipv4/netfilter/ip_tables.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 048514f..c64340b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1994,6 +1994,9 @@ compat_do_ipt_get_ctl(struct sock *sk, i
 {
 	int ret;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case IPT_SO_GET_INFO:
 		ret = get_info(user, len, 1);
