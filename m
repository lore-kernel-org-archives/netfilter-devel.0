From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/50]: nf_nat_sip: only perform RTP DNAT if SIP session
	was SNATed
Date: Sat,  7 Jul 2007 14:23:15 +0200 (MEST)
Message-ID: <20070707122230.1589.61447.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat_sip: only perform RTP DNAT if SIP session was SNATed

DNAT of the the RTP session is only necessary if the SIP session has been SNATed.

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 162018a88b4545a9a8be5b4720ae913ecd519928
tree 9ba954d980c0073734b2144a9205c6295a8c7b4e
parent cb17d98047a9f0843ff4f04b2b563def0a154ea3
author Jerome Borsboom <j.borsboom@erasmusmc.nl> Sat, 07 Jul 2007 12:15:19 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:19 +0200

 net/ipv4/netfilter/nf_nat_sip.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index fac97cf..a32d746 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -260,7 +260,11 @@ static unsigned int ip_nat_sdp(struct sk_buff **pskb,
 	DEBUGP("ip_nat_sdp():\n");
 
 	/* Connection will come from reply */
-	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+	if (ct->tuplehash[dir].tuple.src.u3.ip ==
+	    ct->tuplehash[!dir].tuple.dst.u3.ip)
+		newip = exp->tuple.dst.u3.ip;
+	else
+		newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 
 	exp->saved_ip = exp->tuple.dst.u3.ip;
 	exp->tuple.dst.u3.ip = newip;
