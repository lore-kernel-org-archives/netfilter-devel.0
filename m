From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/22]: nfnetlink: remove unused includes in nfnetlink.c
Date: Wed, 14 Mar 2007 09:50:35 +0100 (MET)
Message-ID: <20070314085020.15282.64439.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: remove unused includes in nfnetlink.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b826bdd775fb219458b886e3fc41491019af0d67
tree e355d5cc9d828eb93b11211e047b56e849c01229
parent bc5959a6bd9a56d1ea0e31344bde2b4f119d8b4c
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 08 Mar 2007 18:25:49 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:31:19 +0100

 net/netfilter/nfnetlink.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 0b0a966..6dd6654 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -30,9 +30,7 @@ #include <asm/system.h>
 #include <net/sock.h>
 #include <net/netlink.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
 
-#include <linux/netfilter.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 
