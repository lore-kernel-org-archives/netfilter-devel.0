From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/20]: nf_conntrack/nf_nat: add PPTP helper port
Date: Sat,  2 Dec 2006 15:50:01 +0100 (MET)
Message-ID: <20061202145306.1381.43785.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port

Add nf_conntrack port of the PPtP conntrack/NAT helper. Since there seems
to be no IPv6-capable PPtP implementation the helper only support IPv4.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d076bee62093db6576c9c2950be703fc1b74be64
tree d634792f8f1761c94243ff68071afc1770759c10
parent ce27c390f71686cd741496297293a29a494df3d7
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:19 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:19 +0100

 include/linux/netfilter/nf_conntrack_pptp.h      |  321 ++++++++++++
 include/linux/netfilter/nf_conntrack_proto_gre.h |  112 ++++
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h   |    2 
 include/net/netfilter/nf_conntrack.h             |    4 
 include/net/netfilter/nf_conntrack_helper.h      |    2 
 include/net/netfilter/nf_conntrack_tuple.h       |    6 
 net/ipv4/netfilter/Kconfig                       |   10 
 net/ipv4/netfilter/Makefile                      |    4 
 net/ipv4/netfilter/nf_nat_pptp.c                 |  315 +++++++++++
 net/ipv4/netfilter/nf_nat_proto_gre.c            |  179 ++++++
 net/netfilter/Kconfig                            |   23 +
 net/netfilter/Makefile                           |    2 
 net/netfilter/nf_conntrack_core.c                |    4 
 net/netfilter/nf_conntrack_pptp.c                |  607 ++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_gre.c           |  305 +++++++++++
 15 files changed, 1896 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
new file mode 100644
index 0000000..fb049ec
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -0,0 +1,321 @@
+/* PPTP constants and structs */
+#ifndef _NF_CONNTRACK_PPTP_H
+#define _NF_CONNTRACK_PPTP_H
+
+/* state of the control session */
+enum pptp_ctrlsess_state {
+	PPTP_SESSION_NONE,			/* no session present */
+	PPTP_SESSION_ERROR,			/* some session error */
+	PPTP_SESSION_STOPREQ,			/* stop_sess request seen */
+	PPTP_SESSION_REQUESTED,			/* start_sess request seen */
+	PPTP_SESSION_CONFIRMED,			/* session established */
+};
+
+/* state of the call inside the control session */
+enum pptp_ctrlcall_state {
+	PPTP_CALL_NONE,
+	PPTP_CALL_ERROR,
+	PPTP_CALL_OUT_REQ,
+	PPTP_CALL_OUT_CONF,
+	PPTP_CALL_IN_REQ,
+	PPTP_CALL_IN_REP,
+	PPTP_CALL_IN_CONF,
+	PPTP_CALL_CLEAR_REQ,
+};
+
+/* conntrack private data */
+struct nf_ct_pptp_master {
+	enum pptp_ctrlsess_state sstate;	/* session state */
+	enum pptp_ctrlcall_state cstate;	/* call state */
+	__be16 pac_call_id;			/* call id of PAC */
+	__be16 pns_call_id;			/* call id of PNS */
+
+	/* in pre-2.6.11 this used to be per-expect. Now it is per-conntrack
+	 * and therefore imposes a fixed limit on the number of maps */
+	struct nf_ct_gre_keymap *keymap[IP_CT_DIR_MAX];
+};
+
+struct nf_nat_pptp {
+	__be16 pns_call_id;			/* NAT'ed PNS call id */
+	__be16 pac_call_id;			/* NAT'ed PAC call id */
+};
+
+#ifdef __KERNEL__
+
+#define PPTP_CONTROL_PORT	1723
+
+#define PPTP_PACKET_CONTROL	1
+#define PPTP_PACKET_MGMT	2
+
+#define PPTP_MAGIC_COOKIE	0x1a2b3c4d
+
+struct pptp_pkt_hdr {
+	__u16	packetLength;
+	__be16	packetType;
+	__be32	magicCookie;
+};
+
+/* PptpControlMessageType values */
+#define PPTP_START_SESSION_REQUEST	1
+#define PPTP_START_SESSION_REPLY	2
+#define PPTP_STOP_SESSION_REQUEST	3
+#define PPTP_STOP_SESSION_REPLY		4
+#define PPTP_ECHO_REQUEST		5
+#define PPTP_ECHO_REPLY			6
+#define PPTP_OUT_CALL_REQUEST		7
+#define PPTP_OUT_CALL_REPLY		8
+#define PPTP_IN_CALL_REQUEST		9
+#define PPTP_IN_CALL_REPLY		10
+#define PPTP_IN_CALL_CONNECT		11
+#define PPTP_CALL_CLEAR_REQUEST		12
+#define PPTP_CALL_DISCONNECT_NOTIFY	13
+#define PPTP_WAN_ERROR_NOTIFY		14
+#define PPTP_SET_LINK_INFO		15
+
+#define PPTP_MSG_MAX			15
+
+/* PptpGeneralError values */
+#define PPTP_ERROR_CODE_NONE		0
+#define PPTP_NOT_CONNECTED		1
+#define PPTP_BAD_FORMAT			2
+#define PPTP_BAD_VALUE			3
+#define PPTP_NO_RESOURCE		4
+#define PPTP_BAD_CALLID			5
+#define PPTP_REMOVE_DEVICE_ERROR	6
+
+struct PptpControlHeader {
+	__be16	messageType;
+	__u16	reserved;
+};
+
+/* FramingCapability Bitmap Values */
+#define PPTP_FRAME_CAP_ASYNC		0x1
+#define PPTP_FRAME_CAP_SYNC		0x2
+
+/* BearerCapability Bitmap Values */
+#define PPTP_BEARER_CAP_ANALOG		0x1
+#define PPTP_BEARER_CAP_DIGITAL		0x2
+
+struct PptpStartSessionRequest {
+	__be16	protocolVersion;
+	__u16	reserved1;
+	__be32	framingCapability;
+	__be32	bearerCapability;
+	__be16	maxChannels;
+	__be16	firmwareRevision;
+	__u8	hostName[64];
+	__u8	vendorString[64];
+};
+
+/* PptpStartSessionResultCode Values */
+#define PPTP_START_OK			1
+#define PPTP_START_GENERAL_ERROR	2
+#define PPTP_START_ALREADY_CONNECTED	3
+#define PPTP_START_NOT_AUTHORIZED	4
+#define PPTP_START_UNKNOWN_PROTOCOL	5
+
+struct PptpStartSessionReply {
+	__be16	protocolVersion;
+	__u8	resultCode;
+	__u8	generalErrorCode;
+	__be32	framingCapability;
+	__be32	bearerCapability;
+	__be16	maxChannels;
+	__be16	firmwareRevision;
+	__u8	hostName[64];
+	__u8	vendorString[64];
+};
+
+/* PptpStopReasons */
+#define PPTP_STOP_NONE			1
+#define PPTP_STOP_PROTOCOL		2
+#define PPTP_STOP_LOCAL_SHUTDOWN	3
+
+struct PptpStopSessionRequest {
+	__u8	reason;
+	__u8	reserved1;
+	__u16	reserved2;
+};
+
+/* PptpStopSessionResultCode */
+#define PPTP_STOP_OK			1
+#define PPTP_STOP_GENERAL_ERROR		2
+
+struct PptpStopSessionReply {
+	__u8	resultCode;
+	__u8	generalErrorCode;
+	__u16	reserved1;
+};
+
+struct PptpEchoRequest {
+	__be32 identNumber;
+};
+
+/* PptpEchoReplyResultCode */
+#define PPTP_ECHO_OK			1
+#define PPTP_ECHO_GENERAL_ERROR		2
+
+struct PptpEchoReply {
+	__be32	identNumber;
+	__u8	resultCode;
+	__u8	generalErrorCode;
+	__u16	reserved;
+};
+
+/* PptpFramingType */
+#define PPTP_ASYNC_FRAMING		1
+#define PPTP_SYNC_FRAMING		2
+#define PPTP_DONT_CARE_FRAMING		3
+
+/* PptpCallBearerType */
+#define PPTP_ANALOG_TYPE		1
+#define PPTP_DIGITAL_TYPE		2
+#define PPTP_DONT_CARE_BEARER_TYPE	3
+
+struct PptpOutCallRequest {
+	__be16	callID;
+	__be16	callSerialNumber;
+	__be32	minBPS;
+	__be32	maxBPS;
+	__be32	bearerType;
+	__be32	framingType;
+	__be16	packetWindow;
+	__be16	packetProcDelay;
+	__be16	phoneNumberLength;
+	__u16	reserved1;
+	__u8	phoneNumber[64];
+	__u8	subAddress[64];
+};
+
+/* PptpCallResultCode */
+#define PPTP_OUTCALL_CONNECT		1
+#define PPTP_OUTCALL_GENERAL_ERROR	2
+#define PPTP_OUTCALL_NO_CARRIER		3
+#define PPTP_OUTCALL_BUSY		4
+#define PPTP_OUTCALL_NO_DIAL_TONE	5
+#define PPTP_OUTCALL_TIMEOUT		6
+#define PPTP_OUTCALL_DONT_ACCEPT	7
+
+struct PptpOutCallReply {
+	__be16	callID;
+	__be16	peersCallID;
+	__u8	resultCode;
+	__u8	generalErrorCode;
+	__be16	causeCode;
+	__be32	connectSpeed;
+	__be16	packetWindow;
+	__be16	packetProcDelay;
+	__be32	physChannelID;
+};
+
+struct PptpInCallRequest {
+	__be16	callID;
+	__be16	callSerialNumber;
+	__be32	callBearerType;
+	__be32	physChannelID;
+	__be16	dialedNumberLength;
+	__be16	dialingNumberLength;
+	__u8	dialedNumber[64];
+	__u8	dialingNumber[64];
+	__u8	subAddress[64];
+};
+
+/* PptpInCallResultCode */
+#define PPTP_INCALL_ACCEPT		1
+#define PPTP_INCALL_GENERAL_ERROR	2
+#define PPTP_INCALL_DONT_ACCEPT		3
+
+struct PptpInCallReply {
+	__be16	callID;
+	__be16	peersCallID;
+	__u8	resultCode;
+	__u8	generalErrorCode;
+	__be16	packetWindow;
+	__be16	packetProcDelay;
+	__u16	reserved;
+};
+
+struct PptpInCallConnected {
+	__be16	peersCallID;
+	__u16	reserved;
+	__be32	connectSpeed;
+	__be16	packetWindow;
+	__be16	packetProcDelay;
+	__be32	callFramingType;
+};
+
+struct PptpClearCallRequest {
+	__be16	callID;
+	__u16	reserved;
+};
+
+struct PptpCallDisconnectNotify {
+	__be16	callID;
+	__u8	resultCode;
+	__u8	generalErrorCode;
+	__be16	causeCode;
+	__u16	reserved;
+	__u8	callStatistics[128];
+};
+
+struct PptpWanErrorNotify {
+	__be16	peersCallID;
+	__u16	reserved;
+	__be32	crcErrors;
+	__be32	framingErrors;
+	__be32	hardwareOverRuns;
+	__be32	bufferOverRuns;
+	__be32	timeoutErrors;
+	__be32	alignmentErrors;
+};
+
+struct PptpSetLinkInfo {
+	__be16	peersCallID;
+	__u16	reserved;
+	__be32	sendAccm;
+	__be32	recvAccm;
+};
+
+union pptp_ctrl_union {
+	struct PptpStartSessionRequest	sreq;
+	struct PptpStartSessionReply	srep;
+	struct PptpStopSessionRequest	streq;
+	struct PptpStopSessionReply	strep;
+	struct PptpOutCallRequest	ocreq;
+	struct PptpOutCallReply		ocack;
+	struct PptpInCallRequest	icreq;
+	struct PptpInCallReply		icack;
+	struct PptpInCallConnected	iccon;
+	struct PptpClearCallRequest	clrreq;
+	struct PptpCallDisconnectNotify disc;
+	struct PptpWanErrorNotify	wanerr;
+	struct PptpSetLinkInfo		setlink;
+};
+
+/* crap needed for nf_conntrack_compat.h */
+struct nf_conn;
+struct nf_conntrack_expect;
+enum ip_conntrack_info;
+
+extern int
+(*nf_nat_pptp_hook_outbound)(struct sk_buff **pskb,
+			     struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			     struct PptpControlHeader *ctlh,
+			     union pptp_ctrl_union *pptpReq);
+
+extern int
+(*nf_nat_pptp_hook_inbound)(struct sk_buff **pskb,
+			    struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			    struct PptpControlHeader *ctlh,
+			    union pptp_ctrl_union *pptpReq);
+
+extern void
+(*nf_nat_pptp_hook_exp_gre)(struct nf_conntrack_expect *exp_orig,
+			    struct nf_conntrack_expect *exp_reply);
+
+extern void
+(*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
+			     struct nf_conntrack_expect *exp);
+
+#endif /* __KERNEL__ */
+#endif /* _NF_CONNTRACK_PPTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
new file mode 100644
index 0000000..4e6bbce
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -0,0 +1,112 @@
+#ifndef _CONNTRACK_PROTO_GRE_H
+#define _CONNTRACK_PROTO_GRE_H
+#include <asm/byteorder.h>
+
+/* GRE PROTOCOL HEADER */
+
+/* GRE Version field */
+#define GRE_VERSION_1701	0x0
+#define GRE_VERSION_PPTP	0x1
+
+/* GRE Protocol field */
+#define GRE_PROTOCOL_PPTP	0x880B
+
+/* GRE Flags */
+#define GRE_FLAG_C		0x80
+#define GRE_FLAG_R		0x40
+#define GRE_FLAG_K		0x20
+#define GRE_FLAG_S		0x10
+#define GRE_FLAG_A		0x80
+
+#define GRE_IS_C(f)	((f)&GRE_FLAG_C)
+#define GRE_IS_R(f)	((f)&GRE_FLAG_R)
+#define GRE_IS_K(f)	((f)&GRE_FLAG_K)
+#define GRE_IS_S(f)	((f)&GRE_FLAG_S)
+#define GRE_IS_A(f)	((f)&GRE_FLAG_A)
+
+/* GRE is a mess: Four different standards */
+struct gre_hdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u16	rec:3,
+		srr:1,
+		seq:1,
+		key:1,
+		routing:1,
+		csum:1,
+		version:3,
+		reserved:4,
+		ack:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u16	csum:1,
+		routing:1,
+		key:1,
+		seq:1,
+		srr:1,
+		rec:3,
+		ack:1,
+		reserved:4,
+		version:3;
+#else
+#error "Adjust your <asm/byteorder.h> defines"
+#endif
+	__be16	protocol;
+};
+
+/* modified GRE header for PPTP */
+struct gre_hdr_pptp {
+	__u8   flags;		/* bitfield */
+	__u8   version;		/* should be GRE_VERSION_PPTP */
+	__be16 protocol;	/* should be GRE_PROTOCOL_PPTP */
+	__be16 payload_len;	/* size of ppp payload, not inc. gre header */
+	__be16 call_id;		/* peer's call_id for this session */
+	__be32 seq;		/* sequence number.  Present if S==1 */
+	__be32 ack;		/* seq number of highest packet recieved by */
+				/*  sender in this session */
+};
+
+struct nf_ct_gre {
+	unsigned int stream_timeout;
+	unsigned int timeout;
+};
+
+#ifdef __KERNEL__
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+struct nf_conn;
+
+/* structure for original <-> reply keymap */
+struct nf_ct_gre_keymap {
+	struct list_head list;
+	struct nf_conntrack_tuple tuple;
+};
+
+/* add new tuple->key_reply pair to keymap */
+int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
+			 struct nf_conntrack_tuple *t);
+
+/* delete keymap entries */
+void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
+
+/* get pointer to gre key, if present */
+static inline __be32 *gre_key(struct gre_hdr *greh)
+{
+	if (!greh->key)
+		return NULL;
+	if (greh->csum || greh->routing)
+		return (__be32 *)(greh+sizeof(*greh)+4);
+	return (__be32 *)(greh+sizeof(*greh));
+}
+
+/* get pointer ot gre csum, if present */
+static inline __sum16 *gre_csum(struct gre_hdr *greh)
+{
+	if (!greh->csum)
+		return NULL;
+	return (__sum16 *)(greh+sizeof(*greh));
+}
+
+extern void nf_ct_gre_keymap_flush(void);
+extern void nf_nat_need_gre(void);
+
+#endif /* __KERNEL__ */
+#endif /* _CONNTRACK_PROTO_GRE_H */
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index a1c57ee..1401ccc 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -11,10 +11,12 @@ #define _NF_CONNTRACK_IPV4_H
 
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
 
 /* per conntrack: nat application helper private data */
 union nf_conntrack_nat_help {
         /* insert nat helper private data here */
+	struct nf_nat_pptp nat_pptp_info;
 };
 
 struct nf_conn_nat {
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 1646076..032b36a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -21,6 +21,7 @@ #include <asm/atomic.h>
 
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
+#include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <net/netfilter/ipv4/nf_conntrack_icmp.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
@@ -33,6 +34,7 @@ union nf_conntrack_proto {
 	struct ip_ct_tcp tcp;
 	struct ip_ct_icmp icmp;
 	struct nf_ct_icmpv6 icmpv6;
+	struct nf_ct_gre gre;
 };
 
 union nf_conntrack_expect_proto {
@@ -41,12 +43,14 @@ union nf_conntrack_expect_proto {
 
 /* Add protocol helper include file here */
 #include <linux/netfilter/nf_conntrack_ftp.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
 #include <linux/netfilter/nf_conntrack_h323.h>
 
 /* per conntrack: application helper private data */
 union nf_conntrack_help {
 	/* insert conntrack helper private data (master) here */
 	struct nf_ct_ftp_master ct_ftp_info;
+	struct nf_ct_pptp_master ct_pptp_info;
 	struct nf_ct_h323_master ct_h323_info;
 };
 
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index fbba9e8..8c72ac9 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -34,6 +34,8 @@ struct nf_conntrack_helper
 		    struct nf_conn *ct,
 		    enum ip_conntrack_info conntrackinfo);
 
+	void (*destroy)(struct nf_conn *ct);
+
 	int (*to_nfattr)(struct sk_buff *skb, const struct nf_conn *ct);
 };
 
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index c96a9c5..5d72b16 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -49,6 +49,9 @@ union nf_conntrack_man_proto
 	struct {
 		__be16 port;
 	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
 };
 
 /* The manipulable part of the tuple. */
@@ -84,6 +87,9 @@ struct nf_conntrack_tuple
 			struct {
 				__be16 port;
 			} sctp;
+			struct {
+				__be16 key;
+			} gre;
 		} u;
 
 		/* The protocol. */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 4555f72..c3327ac 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -484,6 +484,10 @@ #
 #           <expr> '&&' <expr>                   (6)
 #
 # (6) Returns the result of min(/expr/, /expr/).
+config NF_NAT_PROTO_GRE
+	tristate
+	depends on NF_NAT && NF_CT_PROTO_GRE
+
 config IP_NF_NAT_FTP
 	tristate
 	depends on IP_NF_IPTABLES && IP_NF_CONNTRACK && IP_NF_NAT
@@ -528,6 +532,12 @@ config IP_NF_NAT_PPTP
 	default IP_NF_NAT if IP_NF_PPTP=y
 	default m if IP_NF_PPTP=m
 
+config NF_NAT_PPTP
+	tristate
+	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	default NF_NAT && NF_CONNTRACK_PPTP
+	select NF_NAT_PROTO_GRE
+
 config IP_NF_NAT_H323
 	tristate
 	depends on IP_NF_IPTABLES!=n && IP_NF_CONNTRACK!=n && IP_NF_NAT!=n
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 56733c3..ef33ff2 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -54,6 +54,10 @@ obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_am
 obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
 obj-$(CONFIG_NF_NAT_H323) += nf_nat_h323.o
 obj-$(CONFIG_NF_NAT_IRC) += nf_nat_irc.o
+obj-$(CONFIG_NF_NAT_PPTP) += nf_nat_pptp.o
+
+# NAT protocols (nf_nat)
+obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
new file mode 100644
index 0000000..0ae45b7
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -0,0 +1,315 @@
+/*
+ * nf_nat_pptp.c
+ *
+ * NAT support for PPTP (Point to Point Tunneling Protocol).
+ * PPTP is a a protocol for creating virtual private networks.
+ * It is a specification defined by Microsoft and some vendors
+ * working with Microsoft.  PPTP is built on top of a modified
+ * version of the Internet Generic Routing Encapsulation Protocol.
+ * GRE is defined in RFC 1701 and RFC 1702.  Documentation of
+ * PPTP can be found in RFC 2637
+ *
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ *
+ * TODO: - NAT to a unique tuple, not to TCP source port
+ * 	   (needs netfilter tuple reservation)
+ */
+
+#include <linux/module.h>
+#include <linux/tcp.h>
+
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_proto_gre.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
+
+#define NF_NAT_PPTP_VERSION "3.0"
+
+#define REQ_CID(req, off)		(*(__be16 *)((char *)(req) + (off)))
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
+MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
+MODULE_ALIAS("ip_nat_pptp");
+
+#if 0
+extern const char *pptp_msg_name[];
+#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s: " format, __FILE__, \
+				       __FUNCTION__, ## args)
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static void pptp_nat_expected(struct nf_conn *ct,
+			      struct nf_conntrack_expect *exp)
+{
+	struct nf_conn *master = ct->master;
+	struct nf_conntrack_expect *other_exp;
+	struct nf_conntrack_tuple t;
+	struct nf_ct_pptp_master *ct_pptp_info;
+	struct nf_nat_pptp *nat_pptp_info;
+	struct ip_nat_range range;
+
+	ct_pptp_info = &nfct_help(master)->help.ct_pptp_info;
+	nat_pptp_info = &nfct_nat(master)->help.nat_pptp_info;
+
+	/* And here goes the grand finale of corrosion... */
+	if (exp->dir == IP_CT_DIR_ORIGINAL) {
+		DEBUGP("we are PNS->PAC\n");
+		/* therefore, build tuple for PAC->PNS */
+		t.src.l3num = AF_INET;
+		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
+		t.src.u.gre.key = ct_pptp_info->pac_call_id;
+		t.dst.u3.ip = master->tuplehash[!exp->dir].tuple.dst.u3.ip;
+		t.dst.u.gre.key = ct_pptp_info->pns_call_id;
+		t.dst.protonum = IPPROTO_GRE;
+	} else {
+		DEBUGP("we are PAC->PNS\n");
+		/* build tuple for PNS->PAC */
+		t.src.l3num = AF_INET;
+		t.src.u3.ip = master->tuplehash[exp->dir].tuple.src.u3.ip;
+		t.src.u.gre.key = nat_pptp_info->pns_call_id;
+		t.dst.u3.ip = master->tuplehash[exp->dir].tuple.dst.u3.ip;
+		t.dst.u.gre.key = nat_pptp_info->pac_call_id;
+		t.dst.protonum = IPPROTO_GRE;
+	}
+
+	DEBUGP("trying to unexpect other dir: ");
+	NF_CT_DUMP_TUPLE(&t);
+	other_exp = nf_conntrack_expect_find_get(&t);
+	if (other_exp) {
+		nf_conntrack_unexpect_related(other_exp);
+		nf_conntrack_expect_put(other_exp);
+		DEBUGP("success\n");
+	} else {
+		DEBUGP("not found!\n");
+	}
+
+	/* This must be a fresh one. */
+	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+
+	/* Change src to where master sends to */
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
+	if (exp->dir == IP_CT_DIR_ORIGINAL) {
+		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.min = range.max = exp->saved_proto;
+	}
+	/* hook doesn't matter, but it has to do source manip */
+	nf_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
+
+	/* For DST manip, map port here to where it's expected. */
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.src.u3.ip;
+	if (exp->dir == IP_CT_DIR_REPLY) {
+		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.min = range.max = exp->saved_proto;
+	}
+	/* hook doesn't matter, but it has to do destination manip */
+	nf_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
+}
+
+/* outbound packets == from PNS to PAC */
+static int
+pptp_outbound_pkt(struct sk_buff **pskb,
+		  struct nf_conn *ct,
+		  enum ip_conntrack_info ctinfo,
+		  struct PptpControlHeader *ctlh,
+		  union pptp_ctrl_union *pptpReq)
+
+{
+	struct nf_ct_pptp_master *ct_pptp_info;
+	struct nf_nat_pptp *nat_pptp_info;
+	u_int16_t msg;
+	__be16 new_callid;
+	unsigned int cid_off;
+
+	ct_pptp_info  = &nfct_help(ct)->help.ct_pptp_info;
+	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
+
+	new_callid = ct_pptp_info->pns_call_id;
+
+	switch (msg = ntohs(ctlh->messageType)) {
+	case PPTP_OUT_CALL_REQUEST:
+		cid_off = offsetof(union pptp_ctrl_union, ocreq.callID);
+		/* FIXME: ideally we would want to reserve a call ID
+		 * here.  current netfilter NAT core is not able to do
+		 * this :( For now we use TCP source port. This breaks
+		 * multiple calls within one control session */
+
+		/* save original call ID in nat_info */
+		nat_pptp_info->pns_call_id = ct_pptp_info->pns_call_id;
+
+		/* don't use tcph->source since we are at a DSTmanip
+		 * hook (e.g. PREROUTING) and pkt is not mangled yet */
+		new_callid = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
+
+		/* save new call ID in ct info */
+		ct_pptp_info->pns_call_id = new_callid;
+		break;
+	case PPTP_IN_CALL_REPLY:
+		cid_off = offsetof(union pptp_ctrl_union, icack.callID);
+		break;
+	case PPTP_CALL_CLEAR_REQUEST:
+		cid_off = offsetof(union pptp_ctrl_union, clrreq.callID);
+		break;
+	default:
+		DEBUGP("unknown outbound packet 0x%04x:%s\n", msg,
+		      (msg <= PPTP_MSG_MAX)?
+		      pptp_msg_name[msg]:pptp_msg_name[0]);
+		/* fall through */
+	case PPTP_SET_LINK_INFO:
+		/* only need to NAT in case PAC is behind NAT box */
+	case PPTP_START_SESSION_REQUEST:
+	case PPTP_START_SESSION_REPLY:
+	case PPTP_STOP_SESSION_REQUEST:
+	case PPTP_STOP_SESSION_REPLY:
+	case PPTP_ECHO_REQUEST:
+	case PPTP_ECHO_REPLY:
+		/* no need to alter packet */
+		return NF_ACCEPT;
+	}
+
+	/* only OUT_CALL_REQUEST, IN_CALL_REPLY, CALL_CLEAR_REQUEST pass
+	 * down to here */
+	DEBUGP("altering call id from 0x%04x to 0x%04x\n",
+		ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
+
+	/* mangle packet */
+	if (nf_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+	                             cid_off + sizeof(struct pptp_pkt_hdr) +
+	                             sizeof(struct PptpControlHeader),
+	                             sizeof(new_callid), (char *)&new_callid,
+	                             sizeof(new_callid)) == 0)
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+
+static void
+pptp_exp_gre(struct nf_conntrack_expect *expect_orig,
+	     struct nf_conntrack_expect *expect_reply)
+{
+	struct nf_conn *ct = expect_orig->master;
+	struct nf_ct_pptp_master *ct_pptp_info;
+	struct nf_nat_pptp *nat_pptp_info;
+
+	ct_pptp_info  = &nfct_help(ct)->help.ct_pptp_info;
+	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
+
+	/* save original PAC call ID in nat_info */
+	nat_pptp_info->pac_call_id = ct_pptp_info->pac_call_id;
+
+	/* alter expectation for PNS->PAC direction */
+	expect_orig->saved_proto.gre.key = ct_pptp_info->pns_call_id;
+	expect_orig->tuple.src.u.gre.key = nat_pptp_info->pns_call_id;
+	expect_orig->tuple.dst.u.gre.key = ct_pptp_info->pac_call_id;
+	expect_orig->dir = IP_CT_DIR_ORIGINAL;
+
+	/* alter expectation for PAC->PNS direction */
+	expect_reply->saved_proto.gre.key = nat_pptp_info->pns_call_id;
+	expect_reply->tuple.src.u.gre.key = nat_pptp_info->pac_call_id;
+	expect_reply->tuple.dst.u.gre.key = ct_pptp_info->pns_call_id;
+	expect_reply->dir = IP_CT_DIR_REPLY;
+}
+
+/* inbound packets == from PAC to PNS */
+static int
+pptp_inbound_pkt(struct sk_buff **pskb,
+		 struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo,
+		 struct PptpControlHeader *ctlh,
+		 union pptp_ctrl_union *pptpReq)
+{
+	struct nf_nat_pptp *nat_pptp_info;
+	u_int16_t msg;
+	__be16 new_pcid;
+	unsigned int pcid_off;
+
+	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
+	new_pcid = nat_pptp_info->pns_call_id;
+
+	switch (msg = ntohs(ctlh->messageType)) {
+	case PPTP_OUT_CALL_REPLY:
+		pcid_off = offsetof(union pptp_ctrl_union, ocack.peersCallID);
+		break;
+	case PPTP_IN_CALL_CONNECT:
+		pcid_off = offsetof(union pptp_ctrl_union, iccon.peersCallID);
+		break;
+	case PPTP_IN_CALL_REQUEST:
+		/* only need to nat in case PAC is behind NAT box */
+		return NF_ACCEPT;
+	case PPTP_WAN_ERROR_NOTIFY:
+		pcid_off = offsetof(union pptp_ctrl_union, wanerr.peersCallID);
+		break;
+	case PPTP_CALL_DISCONNECT_NOTIFY:
+		pcid_off = offsetof(union pptp_ctrl_union, disc.callID);
+		break;
+	case PPTP_SET_LINK_INFO:
+		pcid_off = offsetof(union pptp_ctrl_union, setlink.peersCallID);
+		break;
+	default:
+		DEBUGP("unknown inbound packet %s\n", (msg <= PPTP_MSG_MAX)?
+			pptp_msg_name[msg]:pptp_msg_name[0]);
+		/* fall through */
+	case PPTP_START_SESSION_REQUEST:
+	case PPTP_START_SESSION_REPLY:
+	case PPTP_STOP_SESSION_REQUEST:
+	case PPTP_STOP_SESSION_REPLY:
+	case PPTP_ECHO_REQUEST:
+	case PPTP_ECHO_REPLY:
+		/* no need to alter packet */
+		return NF_ACCEPT;
+	}
+
+	/* only OUT_CALL_REPLY, IN_CALL_CONNECT, IN_CALL_REQUEST,
+	 * WAN_ERROR_NOTIFY, CALL_DISCONNECT_NOTIFY pass down here */
+
+	/* mangle packet */
+	DEBUGP("altering peer call id from 0x%04x to 0x%04x\n",
+		ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
+
+	if (nf_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+	                             pcid_off + sizeof(struct pptp_pkt_hdr) +
+				     sizeof(struct PptpControlHeader),
+				     sizeof(new_pcid), (char *)&new_pcid,
+				     sizeof(new_pcid)) == 0)
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+
+static int __init nf_nat_helper_pptp_init(void)
+{
+	nf_nat_need_gre();
+
+	BUG_ON(rcu_dereference(nf_nat_pptp_hook_outbound));
+	rcu_assign_pointer(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
+
+	BUG_ON(rcu_dereference(nf_nat_pptp_hook_inbound));
+	rcu_assign_pointer(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
+
+	BUG_ON(rcu_dereference(nf_nat_pptp_hook_exp_gre));
+	rcu_assign_pointer(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
+
+	BUG_ON(rcu_dereference(nf_nat_pptp_hook_expectfn));
+	rcu_assign_pointer(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
+	return 0;
+}
+
+static void __exit nf_nat_helper_pptp_fini(void)
+{
+	rcu_assign_pointer(nf_nat_pptp_hook_expectfn, NULL);
+	rcu_assign_pointer(nf_nat_pptp_hook_exp_gre, NULL);
+	rcu_assign_pointer(nf_nat_pptp_hook_inbound, NULL);
+	rcu_assign_pointer(nf_nat_pptp_hook_outbound, NULL);
+	synchronize_rcu();
+}
+
+module_init(nf_nat_helper_pptp_init);
+module_exit(nf_nat_helper_pptp_fini);
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
new file mode 100644
index 0000000..d3de579
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -0,0 +1,179 @@
+/*
+ * nf_nat_proto_gre.c
+ *
+ * NAT protocol helper module for GRE.
+ *
+ * GRE is a generic encapsulation protocol, which is generally not very
+ * suited for NAT, as it has no protocol-specific part as port numbers.
+ *
+ * It has an optional key field, which may help us distinguishing two
+ * connections between the same two hosts.
+ *
+ * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784
+ *
+ * PPTP is built on top of a modified version of GRE, and has a mandatory
+ * field called "CallID", which serves us for the same purpose as the key
+ * field in plain GRE.
+ *
+ * Documentation about PPTP can be found in RFC 2637
+ *
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+#include <linux/netfilter/nf_conntrack_proto_gre.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
+MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
+
+#if 0
+#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s: " format, __FILE__, \
+				       __FUNCTION__, ## args)
+#else
+#define DEBUGP(x, args...)
+#endif
+
+/* is key in given range between min and max */
+static int
+gre_in_range(const struct nf_conntrack_tuple *tuple,
+	     enum nf_nat_manip_type maniptype,
+	     const union nf_conntrack_man_proto *min,
+	     const union nf_conntrack_man_proto *max)
+{
+	__be16 key;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		key = tuple->src.u.gre.key;
+	else
+		key = tuple->dst.u.gre.key;
+
+	return ntohs(key) >= ntohs(min->gre.key) &&
+	       ntohs(key) <= ntohs(max->gre.key);
+}
+
+/* generate unique tuple ... */
+static int
+gre_unique_tuple(struct nf_conntrack_tuple *tuple,
+		 const struct nf_nat_range *range,
+		 enum nf_nat_manip_type maniptype,
+		 const struct nf_conn *conntrack)
+{
+	static u_int16_t key;
+	__be16 *keyptr;
+	unsigned int min, i, range_size;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		keyptr = &tuple->src.u.gre.key;
+	else
+		keyptr = &tuple->dst.u.gre.key;
+
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
+		DEBUGP("%p: NATing GRE PPTP\n", conntrack);
+		min = 1;
+		range_size = 0xffff;
+	} else {
+		min = ntohs(range->min.gre.key);
+		range_size = ntohs(range->max.gre.key) - min + 1;
+	}
+
+	DEBUGP("min = %u, range_size = %u\n", min, range_size);
+
+	for (i = 0; i < range_size; i++, key++) {
+		*keyptr = htons(min + key % range_size);
+		if (!nf_nat_used_tuple(tuple, conntrack))
+			return 1;
+	}
+
+	DEBUGP("%p: no NAT mapping\n", conntrack);
+	return 0;
+}
+
+/* manipulate a GRE packet according to maniptype */
+static int
+gre_manip_pkt(struct sk_buff **pskb, unsigned int iphdroff,
+	      const struct nf_conntrack_tuple *tuple,
+	      enum nf_nat_manip_type maniptype)
+{
+	struct gre_hdr *greh;
+	struct gre_hdr_pptp *pgreh;
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	unsigned int hdroff = iphdroff + iph->ihl * 4;
+
+	/* pgreh includes two optional 32bit fields which are not required
+	 * to be there.  That's where the magic '8' comes from */
+	if (!skb_make_writable(pskb, hdroff + sizeof(*pgreh) - 8))
+		return 0;
+
+	greh = (void *)(*pskb)->data + hdroff;
+	pgreh = (struct gre_hdr_pptp *)greh;
+
+	/* we only have destination manip of a packet, since 'source key'
+	 * is not present in the packet itself */
+	if (maniptype != IP_NAT_MANIP_DST)
+		return 1;
+	switch (greh->version) {
+	case 0:
+		if (!greh->key) {
+			DEBUGP("can't nat GRE w/o key\n");
+			break;
+		}
+		if (greh->csum) {
+			/* FIXME: Never tested this code... */
+			nf_proto_csum_replace4(gre_csum(greh), *pskb,
+					       *(gre_key(greh)),
+					       tuple->dst.u.gre.key, 0);
+		}
+		*(gre_key(greh)) = tuple->dst.u.gre.key;
+		break;
+	case GRE_VERSION_PPTP:
+		DEBUGP("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
+		pgreh->call_id = tuple->dst.u.gre.key;
+		break;
+	default:
+		DEBUGP("can't nat unknown GRE version\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct nf_nat_protocol gre __read_mostly = {
+	.name			= "GRE",
+	.protonum		= IPPROTO_GRE,
+	.manip_pkt		= gre_manip_pkt,
+	.in_range		= gre_in_range,
+	.unique_tuple		= gre_unique_tuple,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
+	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
+#endif
+};
+
+int __init nf_nat_proto_gre_init(void)
+{
+	return nf_nat_protocol_register(&gre);
+}
+
+void __exit nf_nat_proto_gre_fini(void)
+{
+	nf_nat_protocol_unregister(&gre);
+}
+
+module_init(nf_nat_proto_gre_init);
+module_exit(nf_nat_proto_gre_fini);
+
+void nf_nat_need_gre(void)
+{
+	return;
+}
+EXPORT_SYMBOL_GPL(nf_nat_need_gre);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d1a365d..6b2eb26 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -120,6 +120,10 @@ config NF_CONNTRACK_EVENTS
 
 	  If unsure, say `N'.
 
+config NF_CT_PROTO_GRE
+	tristate
+	depends on EXPERIMENTAL && NF_CONNTRACK
+
 config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol on new connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
@@ -213,6 +217,25 @@ config NF_CONNTRACK_NETBIOS_NS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_PPTP
+	tristate "PPtP protocol support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	select NF_CT_PROTO_GRE
+	help
+	  This module adds support for PPTP (Point to Point Tunnelling
+	  Protocol, RFC2637) connection tracking and NAT.
+
+	  If you are running PPTP sessions over a stateful firewall or NAT
+	  box, you may want to enable this feature.
+
+	  Please note that not all PPTP modes of operation are supported yet.
+	  Specifically these limitations exist:
+	    - Blindy assumes that control connections are always established
+	      in PNS->PAC direction. This is a violation of RFC2637.
+	    - Only supports a single call within each session
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 67144b2..897bed4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -14,6 +14,7 @@ # connection tracking
 obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
 
 # SCTP protocol connection tracking
+obj-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
 obj-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
 
 # netlink interface for nf_conntrack
@@ -27,6 +28,7 @@ obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_con
 obj-$(CONFIG_NF_CONNTRACK_H323) += nf_conntrack_h323.o
 obj-$(CONFIG_NF_CONNTRACK_IRC) += nf_conntrack_irc.o
 obj-$(CONFIG_NF_CONNTRACK_NETBIOS_NS) += nf_conntrack_netbios_ns.o
+obj-$(CONFIG_NF_CONNTRACK_PPTP) += nf_conntrack_pptp.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index aa8beab..ed756c9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -300,6 +300,7 @@ static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
+	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
 
@@ -310,6 +311,9 @@ destroy_conntrack(struct nf_conntrack *n
 	nf_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
+	if (help && help->helper && help->helper->destroy)
+		help->helper->destroy(ct);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
new file mode 100644
index 0000000..f0ff00e
--- /dev/null
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -0,0 +1,607 @@
+/*
+ * Connection tracking support for PPTP (Point to Point Tunneling Protocol).
+ * PPTP is a a protocol for creating virtual private networks.
+ * It is a specification defined by Microsoft and some vendors
+ * working with Microsoft.  PPTP is built on top of a modified
+ * version of the Internet Generic Routing Encapsulation Protocol.
+ * GRE is defined in RFC 1701 and RFC 1702.  Documentation of
+ * PPTP can be found in RFC 2637
+ *
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ *
+ * Limitations:
+ * 	 - We blindly assume that control connections are always
+ * 	   established in PNS->PAC direction.  This is a violation
+ * 	   of RFFC2673
+ * 	 - We can only support one single call within each session
+ * TODO:
+ *	 - testing of incoming PPTP calls
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/tcp.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <linux/netfilter/nf_conntrack_proto_gre.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
+
+#define NF_CT_PPTP_VERSION "3.1"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
+MODULE_DESCRIPTION("Netfilter connection tracking helper module for PPTP");
+MODULE_ALIAS("ip_conntrack_pptp");
+
+static DEFINE_SPINLOCK(nf_pptp_lock);
+
+int
+(*nf_nat_pptp_hook_outbound)(struct sk_buff **pskb,
+			     struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			     struct PptpControlHeader *ctlh,
+			     union pptp_ctrl_union *pptpReq) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_outbound);
+
+int
+(*nf_nat_pptp_hook_inbound)(struct sk_buff **pskb,
+			    struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			    struct PptpControlHeader *ctlh,
+			    union pptp_ctrl_union *pptpReq) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_inbound);
+
+void
+(*nf_nat_pptp_hook_exp_gre)(struct nf_conntrack_expect *expect_orig,
+			    struct nf_conntrack_expect *expect_reply)
+			    __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_exp_gre);
+
+void
+(*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
+			     struct nf_conntrack_expect *exp) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
+
+#if 0
+/* PptpControlMessageType names */
+const char *pptp_msg_name[] = {
+	"UNKNOWN_MESSAGE",
+	"START_SESSION_REQUEST",
+	"START_SESSION_REPLY",
+	"STOP_SESSION_REQUEST",
+	"STOP_SESSION_REPLY",
+	"ECHO_REQUEST",
+	"ECHO_REPLY",
+	"OUT_CALL_REQUEST",
+	"OUT_CALL_REPLY",
+	"IN_CALL_REQUEST",
+	"IN_CALL_REPLY",
+	"IN_CALL_CONNECT",
+	"CALL_CLEAR_REQUEST",
+	"CALL_DISCONNECT_NOTIFY",
+	"WAN_ERROR_NOTIFY",
+	"SET_LINK_INFO"
+};
+EXPORT_SYMBOL(pptp_msg_name);
+#define DEBUGP(format, args...)	printk(KERN_DEBUG "%s:%s: " format, __FILE__, __FUNCTION__, ## args)
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#define SECS *HZ
+#define MINS * 60 SECS
+#define HOURS * 60 MINS
+
+#define PPTP_GRE_TIMEOUT 		(10 MINS)
+#define PPTP_GRE_STREAM_TIMEOUT 	(5 HOURS)
+
+static void pptp_expectfn(struct nf_conn *ct,
+			 struct nf_conntrack_expect *exp)
+{
+	typeof(nf_nat_pptp_hook_expectfn) nf_nat_pptp_expectfn;
+	DEBUGP("increasing timeouts\n");
+
+	/* increase timeout of GRE data channel conntrack entry */
+	ct->proto.gre.timeout	     = PPTP_GRE_TIMEOUT;
+	ct->proto.gre.stream_timeout = PPTP_GRE_STREAM_TIMEOUT;
+
+	/* Can you see how rusty this code is, compared with the pre-2.6.11
+	 * one? That's what happened to my shiny newnat of 2002 ;( -HW */
+
+	rcu_read_lock();
+	nf_nat_pptp_expectfn = rcu_dereference(nf_nat_pptp_hook_expectfn);
+	if (nf_nat_pptp_expectfn && ct->status & IPS_NAT_MASK)
+		nf_nat_pptp_expectfn(ct, exp);
+	else {
+		struct nf_conntrack_tuple inv_t;
+		struct nf_conntrack_expect *exp_other;
+
+		/* obviously this tuple inversion only works until you do NAT */
+		nf_ct_invert_tuplepr(&inv_t, &exp->tuple);
+		DEBUGP("trying to unexpect other dir: ");
+		NF_CT_DUMP_TUPLE(&inv_t);
+
+		exp_other = nf_conntrack_expect_find_get(&inv_t);
+		if (exp_other) {
+			/* delete other expectation.  */
+			DEBUGP("found\n");
+			nf_conntrack_unexpect_related(exp_other);
+			nf_conntrack_expect_put(exp_other);
+		} else {
+			DEBUGP("not found\n");
+		}
+	}
+	rcu_read_unlock();
+}
+
+static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_expect *exp;
+	struct nf_conn *sibling;
+
+	DEBUGP("trying to timeout ct or exp for tuple ");
+	NF_CT_DUMP_TUPLE(t);
+
+	h = nf_conntrack_find_get(t, NULL);
+	if (h)  {
+		sibling = nf_ct_tuplehash_to_ctrack(h);
+		DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
+		sibling->proto.gre.timeout	  = 0;
+		sibling->proto.gre.stream_timeout = 0;
+		if (del_timer(&sibling->timeout))
+			sibling->timeout.function((unsigned long)sibling);
+		nf_ct_put(sibling);
+		return 1;
+	} else {
+		exp = nf_conntrack_expect_find_get(t);
+		if (exp) {
+			DEBUGP("unexpect_related of expect %p\n", exp);
+			nf_conntrack_unexpect_related(exp);
+			nf_conntrack_expect_put(exp);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/* timeout GRE data connections */
+static void pptp_destroy_siblings(struct nf_conn *ct)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_tuple t;
+
+	nf_ct_gre_keymap_destroy(ct);
+
+	/* try original (pns->pac) tuple */
+	memcpy(&t, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(t));
+	t.dst.protonum = IPPROTO_GRE;
+	t.src.u.gre.key = help->help.ct_pptp_info.pns_call_id;
+	t.dst.u.gre.key = help->help.ct_pptp_info.pac_call_id;
+	if (!destroy_sibling_or_exp(&t))
+		DEBUGP("failed to timeout original pns->pac ct/exp\n");
+
+	/* try reply (pac->pns) tuple */
+	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
+	t.dst.protonum = IPPROTO_GRE;
+	t.src.u.gre.key = help->help.ct_pptp_info.pac_call_id;
+	t.dst.u.gre.key = help->help.ct_pptp_info.pns_call_id;
+	if (!destroy_sibling_or_exp(&t))
+		DEBUGP("failed to timeout reply pac->pns ct/exp\n");
+}
+
+/* expect GRE connections (PNS->PAC and PAC->PNS direction) */
+static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
+{
+	struct nf_conntrack_expect *exp_orig, *exp_reply;
+	enum ip_conntrack_dir dir;
+	int ret = 1;
+	typeof(nf_nat_pptp_hook_exp_gre) nf_nat_pptp_exp_gre;
+
+	exp_orig = nf_conntrack_expect_alloc(ct);
+	if (exp_orig == NULL)
+		goto out;
+
+	exp_reply = nf_conntrack_expect_alloc(ct);
+	if (exp_reply == NULL)
+		goto out_put_orig;
+
+	/* original direction, PNS->PAC */
+	dir = IP_CT_DIR_ORIGINAL;
+	nf_conntrack_expect_init(exp_orig, ct->tuplehash[dir].tuple.src.l3num,
+				 &ct->tuplehash[dir].tuple.src.u3,
+				 &ct->tuplehash[dir].tuple.dst.u3,
+				 IPPROTO_GRE, &peer_callid, &callid);
+	exp_orig->expectfn = pptp_expectfn;
+
+	/* reply direction, PAC->PNS */
+	dir = IP_CT_DIR_REPLY;
+	nf_conntrack_expect_init(exp_reply, ct->tuplehash[dir].tuple.src.l3num,
+				 &ct->tuplehash[dir].tuple.src.u3,
+				 &ct->tuplehash[dir].tuple.dst.u3,
+				 IPPROTO_GRE, &callid, &peer_callid);
+	exp_reply->expectfn = pptp_expectfn;
+
+	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
+	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
+		nf_nat_pptp_exp_gre(exp_orig, exp_reply);
+	if (nf_conntrack_expect_related(exp_orig) != 0)
+		goto out_put_both;
+	if (nf_conntrack_expect_related(exp_reply) != 0)
+		goto out_unexpect_orig;
+
+	/* Add GRE keymap entries */
+	if (nf_ct_gre_keymap_add(ct, IP_CT_DIR_ORIGINAL, &exp_orig->tuple) != 0)
+		goto out_unexpect_both;
+	if (nf_ct_gre_keymap_add(ct, IP_CT_DIR_REPLY, &exp_reply->tuple) != 0) {
+		nf_ct_gre_keymap_destroy(ct);
+		goto out_unexpect_both;
+	}
+	ret = 0;
+
+out_put_both:
+	nf_conntrack_expect_put(exp_reply);
+out_put_orig:
+	nf_conntrack_expect_put(exp_orig);
+out:
+	return ret;
+
+out_unexpect_both:
+	nf_conntrack_unexpect_related(exp_reply);
+out_unexpect_orig:
+	nf_conntrack_unexpect_related(exp_orig);
+	goto out_put_both;
+}
+
+static inline int
+pptp_inbound_pkt(struct sk_buff **pskb,
+		 struct PptpControlHeader *ctlh,
+		 union pptp_ctrl_union *pptpReq,
+		 unsigned int reqlen,
+		 struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo)
+{
+	struct nf_ct_pptp_master *info = &nfct_help(ct)->help.ct_pptp_info;
+	u_int16_t msg;
+	__be16 cid = 0, pcid = 0;
+	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
+
+	msg = ntohs(ctlh->messageType);
+	DEBUGP("inbound control message %s\n", pptp_msg_name[msg]);
+
+	switch (msg) {
+	case PPTP_START_SESSION_REPLY:
+		/* server confirms new control session */
+		if (info->sstate < PPTP_SESSION_REQUESTED)
+			goto invalid;
+		if (pptpReq->srep.resultCode == PPTP_START_OK)
+			info->sstate = PPTP_SESSION_CONFIRMED;
+		else
+			info->sstate = PPTP_SESSION_ERROR;
+		break;
+
+	case PPTP_STOP_SESSION_REPLY:
+		/* server confirms end of control session */
+		if (info->sstate > PPTP_SESSION_STOPREQ)
+			goto invalid;
+		if (pptpReq->strep.resultCode == PPTP_STOP_OK)
+			info->sstate = PPTP_SESSION_NONE;
+		else
+			info->sstate = PPTP_SESSION_ERROR;
+		break;
+
+	case PPTP_OUT_CALL_REPLY:
+		/* server accepted call, we now expect GRE frames */
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+		if (info->cstate != PPTP_CALL_OUT_REQ &&
+		    info->cstate != PPTP_CALL_OUT_CONF)
+			goto invalid;
+
+		cid = pptpReq->ocack.callID;
+		pcid = pptpReq->ocack.peersCallID;
+		if (info->pns_call_id != pcid)
+			goto invalid;
+		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
+			ntohs(cid), ntohs(pcid));
+
+		if (pptpReq->ocack.resultCode == PPTP_OUTCALL_CONNECT) {
+			info->cstate = PPTP_CALL_OUT_CONF;
+			info->pac_call_id = cid;
+			exp_gre(ct, cid, pcid);
+		} else
+			info->cstate = PPTP_CALL_NONE;
+		break;
+
+	case PPTP_IN_CALL_REQUEST:
+		/* server tells us about incoming call request */
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+
+		cid = pptpReq->icreq.callID;
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		info->cstate = PPTP_CALL_IN_REQ;
+		info->pac_call_id = cid;
+		break;
+
+	case PPTP_IN_CALL_CONNECT:
+		/* server tells us about incoming call established */
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+		if (info->cstate != PPTP_CALL_IN_REP &&
+		    info->cstate != PPTP_CALL_IN_CONF)
+			goto invalid;
+
+		pcid = pptpReq->iccon.peersCallID;
+		cid = info->pac_call_id;
+
+		if (info->pns_call_id != pcid)
+			goto invalid;
+
+		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		info->cstate = PPTP_CALL_IN_CONF;
+
+		/* we expect a GRE connection from PAC to PNS */
+		exp_gre(ct, cid, pcid);
+		break;
+
+	case PPTP_CALL_DISCONNECT_NOTIFY:
+		/* server confirms disconnect */
+		cid = pptpReq->disc.callID;
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		info->cstate = PPTP_CALL_NONE;
+
+		/* untrack this call id, unexpect GRE packets */
+		pptp_destroy_siblings(ct);
+		break;
+
+	case PPTP_WAN_ERROR_NOTIFY:
+	case PPTP_ECHO_REQUEST:
+	case PPTP_ECHO_REPLY:
+		/* I don't have to explain these ;) */
+		break;
+
+	default:
+		goto invalid;
+	}
+
+	nf_nat_pptp_inbound = rcu_dereference(nf_nat_pptp_hook_inbound);
+	if (nf_nat_pptp_inbound && ct->status & IPS_NAT_MASK)
+		return nf_nat_pptp_inbound(pskb, ct, ctinfo, ctlh, pptpReq);
+	return NF_ACCEPT;
+
+invalid:
+	DEBUGP("invalid %s: type=%d cid=%u pcid=%u "
+	       "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
+	       msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+	       msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
+	       ntohs(info->pns_call_id), ntohs(info->pac_call_id));
+	return NF_ACCEPT;
+}
+
+static inline int
+pptp_outbound_pkt(struct sk_buff **pskb,
+		  struct PptpControlHeader *ctlh,
+		  union pptp_ctrl_union *pptpReq,
+		  unsigned int reqlen,
+		  struct nf_conn *ct,
+		  enum ip_conntrack_info ctinfo)
+{
+	struct nf_ct_pptp_master *info = &nfct_help(ct)->help.ct_pptp_info;
+	u_int16_t msg;
+	__be16 cid = 0, pcid = 0;
+	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
+
+	msg = ntohs(ctlh->messageType);
+	DEBUGP("outbound control message %s\n", pptp_msg_name[msg]);
+
+	switch (msg) {
+	case PPTP_START_SESSION_REQUEST:
+		/* client requests for new control session */
+		if (info->sstate != PPTP_SESSION_NONE)
+			goto invalid;
+		info->sstate = PPTP_SESSION_REQUESTED;
+		break;
+
+	case PPTP_STOP_SESSION_REQUEST:
+		/* client requests end of control session */
+		info->sstate = PPTP_SESSION_STOPREQ;
+		break;
+
+	case PPTP_OUT_CALL_REQUEST:
+		/* client initiating connection to server */
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+		info->cstate = PPTP_CALL_OUT_REQ;
+		/* track PNS call id */
+		cid = pptpReq->ocreq.callID;
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		info->pns_call_id = cid;
+		break;
+
+	case PPTP_IN_CALL_REPLY:
+		/* client answers incoming call */
+		if (info->cstate != PPTP_CALL_IN_REQ &&
+		    info->cstate != PPTP_CALL_IN_REP)
+			goto invalid;
+
+		cid = pptpReq->icack.callID;
+		pcid = pptpReq->icack.peersCallID;
+		if (info->pac_call_id != pcid)
+			goto invalid;
+		DEBUGP("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
+		       ntohs(cid), ntohs(pcid));
+
+		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
+			/* part two of the three-way handshake */
+			info->cstate = PPTP_CALL_IN_REP;
+			info->pns_call_id = cid;
+		} else
+			info->cstate = PPTP_CALL_NONE;
+		break;
+
+	case PPTP_CALL_CLEAR_REQUEST:
+		/* client requests hangup of call */
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+		/* FUTURE: iterate over all calls and check if
+		 * call ID is valid.  We don't do this without newnat,
+		 * because we only know about last call */
+		info->cstate = PPTP_CALL_CLEAR_REQ;
+		break;
+
+	case PPTP_SET_LINK_INFO:
+	case PPTP_ECHO_REQUEST:
+	case PPTP_ECHO_REPLY:
+		/* I don't have to explain these ;) */
+		break;
+
+	default:
+		goto invalid;
+	}
+
+	nf_nat_pptp_outbound = rcu_dereference(nf_nat_pptp_hook_outbound);
+	if (nf_nat_pptp_outbound && ct->status & IPS_NAT_MASK)
+		return nf_nat_pptp_outbound(pskb, ct, ctinfo, ctlh, pptpReq);
+	return NF_ACCEPT;
+
+invalid:
+	DEBUGP("invalid %s: type=%d cid=%u pcid=%u "
+	       "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
+	       msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+	       msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
+	       ntohs(info->pns_call_id), ntohs(info->pac_call_id));
+	return NF_ACCEPT;
+}
+
+static const unsigned int pptp_msg_size[] = {
+	[PPTP_START_SESSION_REQUEST]  = sizeof(struct PptpStartSessionRequest),
+	[PPTP_START_SESSION_REPLY]    = sizeof(struct PptpStartSessionReply),
+	[PPTP_STOP_SESSION_REQUEST]   = sizeof(struct PptpStopSessionRequest),
+	[PPTP_STOP_SESSION_REPLY]     = sizeof(struct PptpStopSessionReply),
+	[PPTP_OUT_CALL_REQUEST]       = sizeof(struct PptpOutCallRequest),
+	[PPTP_OUT_CALL_REPLY]	      = sizeof(struct PptpOutCallReply),
+	[PPTP_IN_CALL_REQUEST]	      = sizeof(struct PptpInCallRequest),
+	[PPTP_IN_CALL_REPLY]	      = sizeof(struct PptpInCallReply),
+	[PPTP_IN_CALL_CONNECT]	      = sizeof(struct PptpInCallConnected),
+	[PPTP_CALL_CLEAR_REQUEST]     = sizeof(struct PptpClearCallRequest),
+	[PPTP_CALL_DISCONNECT_NOTIFY] = sizeof(struct PptpCallDisconnectNotify),
+	[PPTP_WAN_ERROR_NOTIFY]	      = sizeof(struct PptpWanErrorNotify),
+	[PPTP_SET_LINK_INFO]	      = sizeof(struct PptpSetLinkInfo),
+};
+
+/* track caller id inside control connection, call expect_related */
+static int
+conntrack_pptp_help(struct sk_buff **pskb, unsigned int protoff,
+		    struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+
+{
+	int dir = CTINFO2DIR(ctinfo);
+	struct nf_ct_pptp_master *info = &nfct_help(ct)->help.ct_pptp_info;
+	struct tcphdr _tcph, *tcph;
+	struct pptp_pkt_hdr _pptph, *pptph;
+	struct PptpControlHeader _ctlh, *ctlh;
+	union pptp_ctrl_union _pptpReq, *pptpReq;
+	unsigned int tcplen = (*pskb)->len - protoff;
+	unsigned int datalen, reqlen, nexthdr_off;
+	int oldsstate, oldcstate;
+	int ret;
+	u_int16_t msg;
+
+	/* don't do any tracking before tcp handshake complete */
+	if (ctinfo != IP_CT_ESTABLISHED &&
+	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY)
+		return NF_ACCEPT;
+
+	nexthdr_off = protoff;
+	tcph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_tcph), &_tcph);
+	BUG_ON(!tcph);
+	nexthdr_off += tcph->doff * 4;
+ 	datalen = tcplen - tcph->doff * 4;
+
+	pptph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_pptph), &_pptph);
+	if (!pptph) {
+		DEBUGP("no full PPTP header, can't track\n");
+		return NF_ACCEPT;
+	}
+	nexthdr_off += sizeof(_pptph);
+	datalen -= sizeof(_pptph);
+
+	/* if it's not a control message we can't do anything with it */
+	if (ntohs(pptph->packetType) != PPTP_PACKET_CONTROL ||
+	    ntohl(pptph->magicCookie) != PPTP_MAGIC_COOKIE) {
+		DEBUGP("not a control packet\n");
+		return NF_ACCEPT;
+	}
+
+	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
+	if (!ctlh)
+		return NF_ACCEPT;
+	nexthdr_off += sizeof(_ctlh);
+	datalen -= sizeof(_ctlh);
+
+	reqlen = datalen;
+	msg = ntohs(ctlh->messageType);
+	if (msg > 0 && msg <= PPTP_MSG_MAX && reqlen < pptp_msg_size[msg])
+		return NF_ACCEPT;
+	if (reqlen > sizeof(*pptpReq))
+		reqlen = sizeof(*pptpReq);
+
+	pptpReq = skb_header_pointer(*pskb, nexthdr_off, reqlen, &_pptpReq);
+	if (!pptpReq)
+		return NF_ACCEPT;
+
+	oldsstate = info->sstate;
+	oldcstate = info->cstate;
+
+	spin_lock_bh(&nf_pptp_lock);
+
+	/* FIXME: We just blindly assume that the control connection is always
+	 * established from PNS->PAC.  However, RFC makes no guarantee */
+	if (dir == IP_CT_DIR_ORIGINAL)
+		/* client -> server (PNS -> PAC) */
+		ret = pptp_outbound_pkt(pskb, ctlh, pptpReq, reqlen, ct,
+					ctinfo);
+	else
+		/* server -> client (PAC -> PNS) */
+		ret = pptp_inbound_pkt(pskb, ctlh, pptpReq, reqlen, ct,
+				       ctinfo);
+	DEBUGP("sstate: %d->%d, cstate: %d->%d\n",
+		oldsstate, info->sstate, oldcstate, info->cstate);
+	spin_unlock_bh(&nf_pptp_lock);
+
+	return ret;
+}
+
+/* control protocol helper */
+static struct nf_conntrack_helper pptp __read_mostly = {
+	.name			= "pptp",
+	.me			= THIS_MODULE,
+	.max_expected		= 2,
+	.timeout		= 5 * 60,
+	.tuple.src.l3num	= AF_INET,
+	.tuple.src.u.tcp.port	= __constant_htons(PPTP_CONTROL_PORT),
+	.tuple.dst.protonum	= IPPROTO_TCP,
+	.mask.src.l3num		= 0xffff,
+	.mask.src.u.tcp.port	= __constant_htons(0xffff),
+	.mask.dst.protonum	= 0xff,
+	.help			= conntrack_pptp_help,
+	.destroy		= pptp_destroy_siblings,
+};
+
+static int __init nf_conntrack_pptp_init(void)
+{
+	return nf_conntrack_helper_register(&pptp);
+}
+
+static void __exit nf_conntrack_pptp_fini(void)
+{
+	nf_conntrack_helper_unregister(&pptp);
+	nf_ct_gre_keymap_flush();
+}
+
+module_init(nf_conntrack_pptp_init);
+module_exit(nf_conntrack_pptp_fini);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
new file mode 100644
index 0000000..ac193ce
--- /dev/null
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -0,0 +1,305 @@
+/*
+ * ip_conntrack_proto_gre.c - Version 3.0
+ *
+ * Connection tracking protocol helper module for GRE.
+ *
+ * GRE is a generic encapsulation protocol, which is generally not very
+ * suited for NAT, as it has no protocol-specific part as port numbers.
+ *
+ * It has an optional key field, which may help us distinguishing two
+ * connections between the same two hosts.
+ *
+ * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784
+ *
+ * PPTP is built on top of a modified version of GRE, and has a mandatory
+ * field called "CallID", which serves us for the same purpose as the key
+ * field in plain GRE.
+ *
+ * Documentation about PPTP can be found in RFC 2637
+ *
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include <linux/in.h>
+#include <linux/skbuff.h>
+
+#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <linux/netfilter/nf_conntrack_proto_gre.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
+
+#define GRE_TIMEOUT		(30 * HZ)
+#define GRE_STREAM_TIMEOUT	(180 * HZ)
+
+#if 0
+#define DEBUGP(format, args...)	printk(KERN_DEBUG "%s:%s: " format, __FILE__, __FUNCTION__, ## args)
+#else
+#define DEBUGP(x, args...)
+#endif
+
+static DEFINE_RWLOCK(nf_ct_gre_lock);
+static LIST_HEAD(gre_keymap_list);
+
+void nf_ct_gre_keymap_flush(void)
+{
+	struct list_head *pos, *n;
+
+	write_lock_bh(&nf_ct_gre_lock);
+	list_for_each_safe(pos, n, &gre_keymap_list) {
+		list_del(pos);
+		kfree(pos);
+	}
+	write_unlock_bh(&nf_ct_gre_lock);
+}
+EXPORT_SYMBOL(nf_ct_gre_keymap_flush);
+
+static inline int gre_key_cmpfn(const struct nf_ct_gre_keymap *km,
+				const struct nf_conntrack_tuple *t)
+{
+	return km->tuple.src.l3num == t->src.l3num &&
+	       !memcmp(&km->tuple.src.u3, &t->src.u3, sizeof(t->src.u3)) &&
+	       !memcmp(&km->tuple.dst.u3, &t->dst.u3, sizeof(t->dst.u3)) &&
+	       km->tuple.dst.protonum == t->dst.protonum &&
+	       km->tuple.dst.u.all == t->dst.u.all;
+}
+
+/* look up the source key for a given tuple */
+static __be16 gre_keymap_lookup(struct nf_conntrack_tuple *t)
+{
+	struct nf_ct_gre_keymap *km;
+	__be16 key = 0;
+
+	read_lock_bh(&nf_ct_gre_lock);
+	list_for_each_entry(km, &gre_keymap_list, list) {
+		if (gre_key_cmpfn(km, t)) {
+			key = km->tuple.src.u.gre.key;
+			break;
+		}
+	}
+	read_unlock_bh(&nf_ct_gre_lock);
+
+	DEBUGP("lookup src key 0x%x for ", key);
+	NF_CT_DUMP_TUPLE(t);
+
+	return key;
+}
+
+/* add a single keymap entry, associate with specified master ct */
+int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
+			 struct nf_conntrack_tuple *t)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_ct_gre_keymap **kmp, *km;
+
+	BUG_ON(strcmp(help->helper->name, "pptp"));
+	kmp = &help->help.ct_pptp_info.keymap[dir];
+	if (*kmp) {
+		/* check whether it's a retransmission */
+		list_for_each_entry(km, &gre_keymap_list, list) {
+			if (gre_key_cmpfn(km, t) && km == *kmp)
+				return 0;
+		}
+		DEBUGP("trying to override keymap_%s for ct %p\n",
+			dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
+		return -EEXIST;
+	}
+
+	km = kmalloc(sizeof(*km), GFP_ATOMIC);
+	if (!km)
+		return -ENOMEM;
+	memcpy(&km->tuple, t, sizeof(*t));
+	*kmp = km;
+
+	DEBUGP("adding new entry %p: ", km);
+	NF_CT_DUMP_TUPLE(&km->tuple);
+
+	write_lock_bh(&nf_ct_gre_lock);
+	list_add_tail(&km->list, &gre_keymap_list);
+	write_unlock_bh(&nf_ct_gre_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_add);
+
+/* destroy the keymap entries associated with specified master ct */
+void nf_ct_gre_keymap_destroy(struct nf_conn *ct)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	enum ip_conntrack_dir dir;
+
+	DEBUGP("entering for ct %p\n", ct);
+	BUG_ON(strcmp(help->helper->name, "pptp"));
+
+	write_lock_bh(&nf_ct_gre_lock);
+	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
+		if (help->help.ct_pptp_info.keymap[dir]) {
+			DEBUGP("removing %p from list\n",
+				help->help.ct_pptp_info.keymap[dir]);
+			list_del(&help->help.ct_pptp_info.keymap[dir]->list);
+			kfree(help->help.ct_pptp_info.keymap[dir]);
+			help->help.ct_pptp_info.keymap[dir] = NULL;
+		}
+	}
+	write_unlock_bh(&nf_ct_gre_lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_destroy);
+
+/* PUBLIC CONNTRACK PROTO HELPER FUNCTIONS */
+
+/* invert gre part of tuple */
+static int gre_invert_tuple(struct nf_conntrack_tuple *tuple,
+			    const struct nf_conntrack_tuple *orig)
+{
+	tuple->dst.u.gre.key = orig->src.u.gre.key;
+	tuple->src.u.gre.key = orig->dst.u.gre.key;
+	return 1;
+}
+
+/* gre hdr info to tuple */
+static int gre_pkt_to_tuple(const struct sk_buff *skb,
+			   unsigned int dataoff,
+			   struct nf_conntrack_tuple *tuple)
+{
+	struct gre_hdr_pptp _pgrehdr, *pgrehdr;
+	__be16 srckey;
+	struct gre_hdr _grehdr, *grehdr;
+
+	/* first only delinearize old RFC1701 GRE header */
+	grehdr = skb_header_pointer(skb, dataoff, sizeof(_grehdr), &_grehdr);
+	if (!grehdr || grehdr->version != GRE_VERSION_PPTP) {
+		/* try to behave like "nf_conntrack_proto_generic" */
+		tuple->src.u.all = 0;
+		tuple->dst.u.all = 0;
+		return 1;
+	}
+
+	/* PPTP header is variable length, only need up to the call_id field */
+	pgrehdr = skb_header_pointer(skb, dataoff, 8, &_pgrehdr);
+	if (!pgrehdr)
+		return 1;
+
+	if (ntohs(grehdr->protocol) != GRE_PROTOCOL_PPTP) {
+		DEBUGP("GRE_VERSION_PPTP but unknown proto\n");
+		return 0;
+	}
+
+	tuple->dst.u.gre.key = pgrehdr->call_id;
+	srckey = gre_keymap_lookup(tuple);
+	tuple->src.u.gre.key = srckey;
+
+	return 1;
+}
+
+/* print gre part of tuple */
+static int gre_print_tuple(struct seq_file *s,
+			   const struct nf_conntrack_tuple *tuple)
+{
+	return seq_printf(s, "srckey=0x%x dstkey=0x%x ",
+			  ntohs(tuple->src.u.gre.key),
+			  ntohs(tuple->dst.u.gre.key));
+}
+
+/* print private data for conntrack */
+static int gre_print_conntrack(struct seq_file *s,
+			       const struct nf_conn *ct)
+{
+	return seq_printf(s, "timeout=%u, stream_timeout=%u ",
+			  (ct->proto.gre.timeout / HZ),
+			  (ct->proto.gre.stream_timeout / HZ));
+}
+
+/* Returns verdict for packet, and may modify conntrack */
+static int gre_packet(struct nf_conn *ct,
+		      const struct sk_buff *skb,
+		      unsigned int dataoff,
+		      enum ip_conntrack_info ctinfo,
+		      int pf,
+		      unsigned int hooknum)
+{
+	/* If we've seen traffic both ways, this is a GRE connection.
+	 * Extend timeout. */
+	if (ct->status & IPS_SEEN_REPLY) {
+		nf_ct_refresh_acct(ct, ctinfo, skb,
+				   ct->proto.gre.stream_timeout);
+		/* Also, more likely to be important, and not a probe. */
+		set_bit(IPS_ASSURED_BIT, &ct->status);
+		nf_conntrack_event_cache(IPCT_STATUS, skb);
+	} else
+		nf_ct_refresh_acct(ct, ctinfo, skb,
+				   ct->proto.gre.timeout);
+
+	return NF_ACCEPT;
+}
+
+/* Called when a new connection for this protocol found. */
+static int gre_new(struct nf_conn *ct, const struct sk_buff *skb,
+		   unsigned int dataoff)
+{
+	DEBUGP(": ");
+	NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+
+	/* initialize to sane value.  Ideally a conntrack helper
+	 * (e.g. in case of pptp) is increasing them */
+	ct->proto.gre.stream_timeout = GRE_STREAM_TIMEOUT;
+	ct->proto.gre.timeout = GRE_TIMEOUT;
+
+	return 1;
+}
+
+/* Called when a conntrack entry has already been removed from the hashes
+ * and is about to be deleted from memory */
+static void gre_destroy(struct nf_conn *ct)
+{
+	struct nf_conn *master = ct->master;
+	DEBUGP(" entering\n");
+
+	if (!master)
+		DEBUGP("no master !?!\n");
+	else
+		nf_ct_gre_keymap_destroy(master);
+}
+
+/* protocol helper struct */
+static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
+	.l3proto	 = AF_INET,
+	.l4proto	 = IPPROTO_GRE,
+	.name		 = "gre",
+	.pkt_to_tuple	 = gre_pkt_to_tuple,
+	.invert_tuple	 = gre_invert_tuple,
+	.print_tuple	 = gre_print_tuple,
+	.print_conntrack = gre_print_conntrack,
+	.packet		 = gre_packet,
+	.new		 = gre_new,
+	.destroy	 = gre_destroy,
+	.me 		 = THIS_MODULE,
+#if defined(CONFIG_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_NF_CONNTRACK_NETLINK_MODULE)
+	.tuple_to_nfattr = nf_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple = nf_ct_port_nfattr_to_tuple,
+#endif
+};
+
+static int __init nf_ct_proto_gre_init(void)
+{
+	return nf_conntrack_l4proto_register(&nf_conntrack_l4proto_gre4);
+}
+
+static void nf_ct_proto_gre_fini(void)
+{
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_gre4);
+	nf_ct_gre_keymap_flush();
+}
+
+module_init(nf_ct_proto_gre_init);
+module_exit(nf_ct_proto_gre_fini);
+
+MODULE_LICENSE("GPL");
