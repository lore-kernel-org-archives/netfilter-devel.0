From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/05]: Fix crash in ip_nat_pptp
Date: Tue, 10 Jan 2006 01:38:39 +0100
Message-ID: <20060110003839.9105.55210.sendpatchset@localhost.localdomain>
References: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix crash in ip_nat_pptp

When an inbound PPTP_IN_CALL_REQUEST packet is received the
PPTP NAT helper uses a NULL pointer in pointer arithmentic to
calculate the offset in the packet which needs to be mangled
and corrupts random memory or crashes.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6c97b3d460f11d5223f16d02d5369f278a621866
tree dd785c80d0fcc79e2f665686a61f33d06c6e365a
parent 9d179ec0f5dc92411afd56e51010bbb57fa17b57
author Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 20:59:45 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 20:59:45 +0100

 net/ipv4/netfilter/ip_nat_helper_pptp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index e546203..8ad7b36 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -315,7 +315,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 	case PPTP_IN_CALL_REQUEST:
 		/* only need to nat in case PAC is behind NAT box */
-		break;
+		return NF_ACCEPT;
 	case PPTP_WAN_ERROR_NOTIFY:
 		pcid = &pptpReq->wanerr.peersCallID;
 		break;
