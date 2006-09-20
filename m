From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/39]: PPTP conntrack: fix header definitions
Date: Wed, 20 Sep 2006 10:24:30 +0200 (MEST)
Message-ID: <20060920082521.14636.74078.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: fix header definitions

Fix a few header definitions to match RFC2637. Most importantly the
PptpOutCallRequest header included an invalid padding field and a
size check was disabled because of this.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d6d938738d5bea57063ead3a04405f0f729b99c3
tree 2dcab7d71b72f13f1940be0b8c7fa902dace45f6
parent 079c04abd728cd903f44bb1db0a0e835cf23e8b5
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:55 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:55 +0200

 include/linux/netfilter_ipv4/ip_conntrack_pptp.h |    9 +++++----
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c    |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
index 0d35623..620bf06 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
@@ -107,8 +107,7 @@ #define PPTP_BEARER_CAP_DIGITAL		0x2
 
 struct PptpStartSessionRequest {
 	__be16	protocolVersion;
-	__u8	reserved1;
-	__u8	reserved2;
+	__u16	reserved1;
 	__be32	framingCapability;
 	__be32	bearerCapability;
 	__be16	maxChannels;
@@ -143,6 +142,8 @@ #define PPTP_STOP_LOCAL_SHUTDOWN	3
 
 struct PptpStopSessionRequest {
 	__u8	reason;
+	__u8	reserved1;
+	__u16	reserved2;
 };
 
 /* PptpStopSessionResultCode */
@@ -152,6 +153,7 @@ #define PPTP_STOP_GENERAL_ERROR		2
 struct PptpStopSessionReply {
 	__u8	resultCode;
 	__u8	generalErrorCode;
+	__u16	reserved1;
 };
 
 struct PptpEchoRequest {
@@ -188,9 +190,8 @@ struct PptpOutCallRequest {
 	__be32	framingType;
 	__be16	packetWindow;
 	__be16	packetProcDelay;
-	__u16	reserved1;
 	__be16	phoneNumberLength;
-	__u16	reserved2;
+	__u16	reserved1;
 	__u8	phoneNumber[64];
 	__u8	subAddress[64];
 };
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 0510ee5..1a8da90 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -569,7 +569,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	case PPTP_OUT_CALL_REQUEST:
 		if (reqlen < sizeof(_pptpReq.ocreq)) {
 			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			/* FIXME: break; */
+			break;
 		}
 
 		/* client initiating connection to server */
