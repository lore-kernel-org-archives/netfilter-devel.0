From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: nf_nat_pptp: fix expectation removal
Date: Thu, 25 Jan 2007 01:21:58 +0100 (MET)
Message-ID: <20070125002158.1883.73281.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat_pptp: fix expectation removal

When removing the expectation for the opposite direction, the PPTP NAT
helper initializes the tuple for lookup with the addresses of the
opposite direction, which makes the lookup fail.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3cb4aaf49a15b7dd30fe3ef882fa22f0255a3679
tree f5e8179acac4065f5e5917007e6a0e6d9343cc30
parent 7093c7d9fd00eff7cc3edba17fc8f8e1e6644da7
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:05:28 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 25 Jan 2007 01:17:16 +0100

 net/ipv4/netfilter/nf_nat_pptp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 0ae45b7..5df4fca 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -72,9 +72,9 @@ static void pptp_nat_expected(struct nf_
 		DEBUGP("we are PAC->PNS\n");
 		/* build tuple for PNS->PAC */
 		t.src.l3num = AF_INET;
-		t.src.u3.ip = master->tuplehash[exp->dir].tuple.src.u3.ip;
+		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
 		t.src.u.gre.key = nat_pptp_info->pns_call_id;
-		t.dst.u3.ip = master->tuplehash[exp->dir].tuple.dst.u3.ip;
+		t.dst.u3.ip = master->tuplehash[!exp->dir].tuple.dst.u3.ip;
 		t.dst.u.gre.key = nat_pptp_info->pac_call_id;
 		t.dst.protonum = IPPROTO_GRE;
 	}
