From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: SIP conntrack: fix out of bounds memory access
Date: Tue, 30 Jan 2007 19:16:31 +0100 (MET)
Message-ID: <20070130181630.25041.87766.sendpatchset@localhost.localdomain>
References: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
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

[NETFILTER]: SIP conntrack: fix out of bounds memory access

When checking for an @-sign in skp_epaddr_len, make sure not to
run over the packet boundaries.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9c13a2e187957e0656eb458ca1251bd1b79aebaa
tree 327ef498d7b592cf4e90c2ea5b38c0e8c0cab1d9
parent b54e6be6e7cc6a9dc5ec5d8876a9d04b552795e5
author Patrick McHardy <kaber@trash.net> Sun, 28 Jan 2007 00:33:53 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 28 Jan 2007 00:33:53 +0100

 net/ipv4/netfilter/ip_conntrack_sip.c |    2 +-
 net/netfilter/nf_conntrack_sip.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index 571d27e..11c588a 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -292,7 +292,7 @@ static int skp_epaddr_len(const char *dp
 		dptr++;
 	}
 
-	if (*dptr == '@') {
+	if (dptr <= limit && *dptr == '@') {
 		dptr++;
 		(*shift)++;
 	} else
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c93fb37..9dec115 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -312,7 +312,7 @@ static int skp_epaddr_len(struct nf_conn
 		dptr++;
 	}
 
-	if (*dptr == '@') {
+	if (dptr <= limit && *dptr == '@') {
 		dptr++;
 		(*shift)++;
 	} else
