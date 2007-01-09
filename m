From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: nf_nat: fix hanging connections when loading the
	NAT module
Date: Tue,  9 Jan 2007 17:29:56 +0100 (MET)
Message-ID: <20070109162956.6229.17261.sendpatchset@localhost.localdomain>
References: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: fix hanging connections when loading the NAT module

When loading the NAT module, existing connection tracking entries don't
have room for NAT information allocated and packets are dropped, causing
hanging connections. They really should be entered into the NAT table
as NULL mappings, but the current allocation scheme doesn't allow this.

For now simply accept those packets to avoid the hanging connections.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 36e2c322ad2424a161b8a2a89c251dc9c71764bb
tree e70f4a11972c8dbe079fef2c75a73e8266c95940
parent 21f6325bc6e8e439cafcdc8d114d3c72743374a3
author Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 14:00:45 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 14:00:45 +0100

 net/ipv4/netfilter/nf_nat_standalone.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 730a7a4..00d6dea 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -123,7 +123,7 @@ nf_nat_fn(unsigned int hooknum,
 
 	nat = nfct_nat(ct);
 	if (!nat)
-		return NF_DROP;
+		return NF_ACCEPT;
 
 	switch (ctinfo) {
 	case IP_CT_RELATED:
