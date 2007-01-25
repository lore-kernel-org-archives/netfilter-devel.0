From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: nf_conntrack_pptp: fix NAT setup of expected GRE
	connections
Date: Thu, 25 Jan 2007 01:22:00 +0100 (MET)
Message-ID: <20070125002159.1883.31976.sendpatchset@localhost.localdomain>
References: <20070125002156.1883.33845.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070125002156.1883.33845.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_pptp: fix NAT setup of expected GRE connections

When an expected connection arrives, the NAT helper should be called to
set up NAT similar to the master connection. The PPTP conntrack helper
incorrectly checks whether the _expected_ connection has NAT setup before
calling the NAT helper (which is never the case), instead of checkeing
whether the _master_ connection is NATed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 279422af9b3aa7a2646f6a0c73d2add4aa43e77b
tree 50be0d46d88950d02ccd409c949d550b1c759adc
parent 3cb4aaf49a15b7dd30fe3ef882fa22f0255a3679
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:08:09 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 25 Jan 2007 01:17:16 +0100

 net/netfilter/nf_conntrack_pptp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f0ff00e..c59df3b 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -113,7 +113,7 @@ static void pptp_expectfn(struct nf_conn
 
 	rcu_read_lock();
 	nf_nat_pptp_expectfn = rcu_dereference(nf_nat_pptp_hook_expectfn);
-	if (nf_nat_pptp_expectfn && ct->status & IPS_NAT_MASK)
+	if (nf_nat_pptp_expectfn && ct->master->status & IPS_NAT_MASK)
 		nf_nat_pptp_expectfn(ct, exp);
 	else {
 		struct nf_conntrack_tuple inv_t;
