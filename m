From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: H.323 conntrack/NAT helper update for 2.6.17-rc1
Date: Mon, 3 Apr 2006 23:55:25 -0400
Message-ID: <BAY109-DAV8692BB886C2FB9F734827B3CA0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000E_01C6577A.1388B1F0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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

This is a multi-part message in MIME format.

------=_NextPart_000_000E_01C6577A.1388B1F0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: base64

SGksIFBhdHJpY2ssDQoNClRoaXMgdXBkYXRlIGlzIHRvIHVwZGF0ZSAyLjYuMTctcmMxIHRvIHRo
ZSBsYXRlc3Qgc3RhdGUuIA0KSXQgaW5jbHVkZXMgZm9sbG93aW5nIGNoYW5nZXMgdGhhdCBhcmUg
bm90IGluIDIuNi4xNy1yYzE6DQoNCjEuIEFkZCBuZXcgcGFyYW1ldGVyICdkZWZhdWx0X3JycV90
dGwnLg0KMi4gQ2hhbmdlIGdldF9oMjQ1X2FkZHIgdG8gc3RhdGljDQozLiBDaGFuZ2UgdG8gdXNl
IEVYUE9SVF9TWU1CT0xfR1BMDQo0LiBNb3ZlIHNvbWUgZXh0ZXJuIGZ1bmN0aW9uIHByb3RvdHlw
ZXMgZnJvbSBpcF9uYXRfaGVscGVyX2gzMjMuYyANCiAgICB0byBpcF9jb25udHJhY2tfaDMyMy5o
Lg0KNS4gTW92ZSBpcF9jb25udHJhY2tfaGVscGVyX2gzMjNfYXNuMS5oIGFuZCANCiAgICBpcF9j
b25udHJhY2tfaGVscGVyX2gzMjNfdHlwZXMuaCBmcm9tIG5ldC9pcHY0L25ldGZpbHRlci8gdG8g
DQogICAgaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2NC8uDQoNClBsZWFzZSBoYXZlIGEgbG9v
ayBhdCBpdCBhbmQgYXBwbHkgaXQuDQoNClRoYW5rcyBhIGxvdCENCg0KSmluZyBNaW4gWmhhbw0K
DQoNCg0KU2lnbmVkLW9mZi1ieTogSmluZyBNaW4gWmhhbyA8emhhb2ppbmdtaW5AdXNlcnMuc291
cmNlZm9yZ2UubmV0Pg==

------=_NextPart_000_000E_01C6577A.1388B1F0
Content-Type: application/octet-stream;
	name="patch-2.6.17-rc1-nath323-0.7"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-2.6.17-rc1-nath323-0.7"

diff -pruN =
linux-2.6.17-rc1.orig/include/linux/netfilter_ipv4/ip_conntrack_h323.h =
linux-2.6.17-rc1/include/linux/netfilter_ipv4/ip_conntrack_h323.h=0A=
--- =
linux-2.6.17-rc1.orig/include/linux/netfilter_ipv4/ip_conntrack_h323.h	=
2006-04-03 21:02:55.000000000 -0400=0A=
+++ linux-2.6.17-rc1/include/linux/netfilter_ipv4/ip_conntrack_h323.h	=
2006-04-03 21:19:12.000000000 -0400=0A=
@@ -3,6 +3,8 @@=0A=
 =0A=
 #ifdef __KERNEL__=0A=
 =0A=
+#include <linux/netfilter_ipv4/ip_conntrack_helper_h323_asn1.h>=0A=
+=0A=
 #define RAS_PORT 1719=0A=
 #define Q931_PORT 1720=0A=
 #define H323_RTP_CHANNEL_MAX 4	/* Audio, video, FAX and other */=0A=
@@ -25,6 +27,56 @@ struct ip_ct_h323_master {=0A=
 	};=0A=
 };=0A=
 =0A=
+struct ip_conntrack_expect;=0A=
+=0A=
+extern int get_h225_addr(unsigned char *data, TransportAddress * addr,=0A=
+			 u_int32_t * ip, u_int16_t * port);=0A=
+extern void ip_conntrack_h245_expect(struct ip_conntrack *new,=0A=
+				     struct ip_conntrack_expect *this);=0A=
+extern void ip_conntrack_q931_expect(struct ip_conntrack *new,=0A=
+				     struct ip_conntrack_expect *this);=0A=
+extern int (*set_h245_addr_hook) (struct sk_buff ** pskb,=0A=
+				  unsigned char **data, int dataoff,=0A=
+				  H245_TransportAddress * addr,=0A=
+				  u_int32_t ip, u_int16_t port);=0A=
+extern int (*set_h225_addr_hook) (struct sk_buff ** pskb,=0A=
+				  unsigned char **data, int dataoff,=0A=
+				  TransportAddress * addr,=0A=
+				  u_int32_t ip, u_int16_t port);=0A=
+extern int (*set_sig_addr_hook) (struct sk_buff ** pskb,=0A=
+				 struct ip_conntrack * ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data,=0A=
+				 TransportAddress * addr, int count);=0A=
+extern int (*set_ras_addr_hook) (struct sk_buff ** pskb,=0A=
+				 struct ip_conntrack * ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data,=0A=
+				 TransportAddress * addr, int count);=0A=
+extern int (*nat_rtp_rtcp_hook) (struct sk_buff ** pskb,=0A=
+				 struct ip_conntrack * ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data, int dataoff,=0A=
+				 H245_TransportAddress * addr,=0A=
+				 u_int16_t port, u_int16_t rtp_port,=0A=
+				 struct ip_conntrack_expect * rtp_exp,=0A=
+				 struct ip_conntrack_expect * rtcp_exp);=0A=
+extern int (*nat_t120_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
+			     enum ip_conntrack_info ctinfo,=0A=
+			     unsigned char **data, int dataoff,=0A=
+			     H245_TransportAddress * addr, u_int16_t port,=0A=
+			     struct ip_conntrack_expect * exp);=0A=
+extern int (*nat_h245_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
+			     enum ip_conntrack_info ctinfo,=0A=
+			     unsigned char **data, int dataoff,=0A=
+			     TransportAddress * addr, u_int16_t port,=0A=
+			     struct ip_conntrack_expect * exp);=0A=
+extern int (*nat_q931_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
+			     enum ip_conntrack_info ctinfo,=0A=
+			     unsigned char **data, TransportAddress * addr,=0A=
+			     int idx, u_int16_t port,=0A=
+			     struct ip_conntrack_expect * exp);=0A=
+=0A=
 #endif=0A=
 =0A=
 #endif=0A=
diff -pruN =
linux-2.6.17-rc1.orig/include/linux/netfilter_ipv4/ip_conntrack_helper_h3=
23_asn1.h =
linux-2.6.17-rc1/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_as=
n1.h=0A=
--- =
linux-2.6.17-rc1.orig/include/linux/netfilter_ipv4/ip_conntrack_helper_h3=
23_asn1.h	1969-12-31 19:00:00.000000000 -0500=0A=
+++ =
linux-2.6.17-rc1/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_as=
n1.h	2006-04-03 21:19:12.000000000 -0400=0A=
@@ -0,0 +1,98 @@=0A=
+/***********************************************************************=
*****=0A=
+ * ip_conntrack_helper_h323_asn1.h - BER and PER decoding library for =
H.323=0A=
+ * 			      	     conntrack/NAT module.=0A=
+ *=0A=
+ * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@hotmail.com>=0A=
+ * =0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ * =0A=
+ * =0A=
+ * This library is based on H.225 version 4, H.235 version 2 and H.245 =0A=
+ * version 7. It is extremely optimized to decode only the absolutely =0A=
+ * necessary objects in a signal for Linux kernel NAT module use, so =
don't =0A=
+ * expect it to be a full ASN.1 library.=0A=
+ * =0A=
+ * Features:=0A=
+ *=0A=
+ * 1. Small. The total size of code plus data is less than 20 KB (IA32).=0A=
+ * 2. Fast. Decoding Netmeeting's Setup signal 1 million times on a =
PIII 866 =0A=
+ *    takes only 3.9 seconds.=0A=
+ * 3. No memory allocation. It uses a static object. No need to =
initialize or=0A=
+ *    cleanup.=0A=
+ * 4. Thread safe.=0A=
+ * 5. Support embedded architectures that has no misaligned memory =
access =0A=
+ *    support.=0A=
+ *=0A=
+ * Limitations:=0A=
+ *=0A=
+ * 1. At most 30 faststart entries. Actually this is limited by =
ethernet's MTU.=0A=
+ *    If a Setup signal contains more than 30 faststart, the packet =
size will =0A=
+ *    very likely exceed the MTU size, then the TPKT will be =
fragmented. I =0A=
+ *    don't know how to handle this in a Netfilter module. Anybody can =
help? =0A=
+ *    Although I think 30 is enough for most of the cases.=0A=
+ * 2. IPv4 addresses only.=0A=
+ *=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+#ifndef _IP_CONNTRACK_HELPER_H323_ASN1_H_=0A=
+#define _IP_CONNTRACK_HELPER_H323_ASN1_H_=0A=
+=0A=
+/***********************************************************************=
******=0A=
+ * H.323 Types=0A=
+ =
*************************************************************************=
***/=0A=
+#include "ip_conntrack_helper_h323_types.h"=0A=
+=0A=
+typedef struct {=0A=
+	enum {=0A=
+		Q931_NationalEscape =3D 0x00,=0A=
+		Q931_Alerting =3D 0x01,=0A=
+		Q931_CallProceeding =3D 0x02,=0A=
+		Q931_Connect =3D 0x07,=0A=
+		Q931_ConnectAck =3D 0x0F,=0A=
+		Q931_Progress =3D 0x03,=0A=
+		Q931_Setup =3D 0x05,=0A=
+		Q931_SetupAck =3D 0x0D,=0A=
+		Q931_Resume =3D 0x26,=0A=
+		Q931_ResumeAck =3D 0x2E,=0A=
+		Q931_ResumeReject =3D 0x22,=0A=
+		Q931_Suspend =3D 0x25,=0A=
+		Q931_SuspendAck =3D 0x2D,=0A=
+		Q931_SuspendReject =3D 0x21,=0A=
+		Q931_UserInformation =3D 0x20,=0A=
+		Q931_Disconnect =3D 0x45,=0A=
+		Q931_Release =3D 0x4D,=0A=
+		Q931_ReleaseComplete =3D 0x5A,=0A=
+		Q931_Restart =3D 0x46,=0A=
+		Q931_RestartAck =3D 0x4E,=0A=
+		Q931_Segment =3D 0x60,=0A=
+		Q931_CongestionCtrl =3D 0x79,=0A=
+		Q931_Information =3D 0x7B,=0A=
+		Q931_Notify =3D 0x6E,=0A=
+		Q931_Status =3D 0x7D,=0A=
+		Q931_StatusEnquiry =3D 0x75,=0A=
+		Q931_Facility =3D 0x62=0A=
+	} MessageType;=0A=
+	H323_UserInformation UUIE;=0A=
+} Q931;=0A=
+=0A=
+/***********************************************************************=
******=0A=
+ * Decode Functions Return Codes=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+#define H323_ERROR_NONE 0	/* Decoded successfully */=0A=
+#define H323_ERROR_STOP 1	/* Decoding stopped, not really an error */=0A=
+#define H323_ERROR_BOUND -1=0A=
+#define H323_ERROR_RANGE -2=0A=
+=0A=
+=0A=
+/***********************************************************************=
******=0A=
+ * Decode Functions=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage * ras);=0A=
+int DecodeQ931(unsigned char *buf, size_t sz, Q931 * q931);=0A=
+int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,=0A=
+					 MultimediaSystemControlMessage *=0A=
+					 mscm);=0A=
+=0A=
+#endif=0A=
diff -pruN =
linux-2.6.17-rc1.orig/include/linux/netfilter_ipv4/ip_conntrack_helper_h3=
23_types.h =
linux-2.6.17-rc1/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_ty=
pes.h=0A=
--- =
linux-2.6.17-rc1.orig/include/linux/netfilter_ipv4/ip_conntrack_helper_h3=
23_types.h	1969-12-31 19:00:00.000000000 -0500=0A=
+++ =
linux-2.6.17-rc1/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_ty=
pes.h	2006-04-03 21:19:12.000000000 -0400=0A=
@@ -0,0 +1,938 @@=0A=
+/* Generated by Jing Min Zhao's ASN.1 parser, Mar 15 2006=0A=
+ *=0A=
+ * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>=0A=
+ *=0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ */=0A=
+=0A=
+typedef struct TransportAddress_ipAddress {	/* SEQUENCE */=0A=
+	int options;		/* No use */=0A=
+	unsigned ip;=0A=
+} TransportAddress_ipAddress;=0A=
+=0A=
+typedef struct TransportAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eTransportAddress_ipAddress,=0A=
+		eTransportAddress_ipSourceRoute,=0A=
+		eTransportAddress_ipxAddress,=0A=
+		eTransportAddress_ip6Address,=0A=
+		eTransportAddress_netBios,=0A=
+		eTransportAddress_nsap,=0A=
+		eTransportAddress_nonStandardAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		TransportAddress_ipAddress ipAddress;=0A=
+	};=0A=
+} TransportAddress;=0A=
+=0A=
+typedef struct DataProtocolCapability {	/* CHOICE */=0A=
+	enum {=0A=
+		eDataProtocolCapability_nonStandard,=0A=
+		eDataProtocolCapability_v14buffered,=0A=
+		eDataProtocolCapability_v42lapm,=0A=
+		eDataProtocolCapability_hdlcFrameTunnelling,=0A=
+		eDataProtocolCapability_h310SeparateVCStack,=0A=
+		eDataProtocolCapability_h310SingleVCStack,=0A=
+		eDataProtocolCapability_transparent,=0A=
+		eDataProtocolCapability_segmentationAndReassembly,=0A=
+		eDataProtocolCapability_hdlcFrameTunnelingwSAR,=0A=
+		eDataProtocolCapability_v120,=0A=
+		eDataProtocolCapability_separateLANStack,=0A=
+		eDataProtocolCapability_v76wCompression,=0A=
+		eDataProtocolCapability_tcp,=0A=
+		eDataProtocolCapability_udp,=0A=
+	} choice;=0A=
+} DataProtocolCapability;=0A=
+=0A=
+typedef struct DataApplicationCapability_application {	/* CHOICE */=0A=
+	enum {=0A=
+		eDataApplicationCapability_application_nonStandard,=0A=
+		eDataApplicationCapability_application_t120,=0A=
+		eDataApplicationCapability_application_dsm_cc,=0A=
+		eDataApplicationCapability_application_userData,=0A=
+		eDataApplicationCapability_application_t84,=0A=
+		eDataApplicationCapability_application_t434,=0A=
+		eDataApplicationCapability_application_h224,=0A=
+		eDataApplicationCapability_application_nlpid,=0A=
+		eDataApplicationCapability_application_dsvdControl,=0A=
+		eDataApplicationCapability_application_h222DataPartitioning,=0A=
+		eDataApplicationCapability_application_t30fax,=0A=
+		eDataApplicationCapability_application_t140,=0A=
+		eDataApplicationCapability_application_t38fax,=0A=
+		eDataApplicationCapability_application_genericDataCapability,=0A=
+	} choice;=0A=
+	union {=0A=
+		DataProtocolCapability t120;=0A=
+	};=0A=
+} DataApplicationCapability_application;=0A=
+=0A=
+typedef struct DataApplicationCapability {	/* SEQUENCE */=0A=
+	int options;		/* No use */=0A=
+	DataApplicationCapability_application application;=0A=
+} DataApplicationCapability;=0A=
+=0A=
+typedef struct DataType {	/* CHOICE */=0A=
+	enum {=0A=
+		eDataType_nonStandard,=0A=
+		eDataType_nullData,=0A=
+		eDataType_videoData,=0A=
+		eDataType_audioData,=0A=
+		eDataType_data,=0A=
+		eDataType_encryptionData,=0A=
+		eDataType_h235Control,=0A=
+		eDataType_h235Media,=0A=
+		eDataType_multiplexedStream,=0A=
+	} choice;=0A=
+	union {=0A=
+		DataApplicationCapability data;=0A=
+	};=0A=
+} DataType;=0A=
+=0A=
+typedef struct UnicastAddress_iPAddress {	/* SEQUENCE */=0A=
+	int options;		/* No use */=0A=
+	unsigned network;=0A=
+} UnicastAddress_iPAddress;=0A=
+=0A=
+typedef struct UnicastAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eUnicastAddress_iPAddress,=0A=
+		eUnicastAddress_iPXAddress,=0A=
+		eUnicastAddress_iP6Address,=0A=
+		eUnicastAddress_netBios,=0A=
+		eUnicastAddress_iPSourceRouteAddress,=0A=
+		eUnicastAddress_nsap,=0A=
+		eUnicastAddress_nonStandardAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		UnicastAddress_iPAddress iPAddress;=0A=
+	};=0A=
+} UnicastAddress;=0A=
+=0A=
+typedef struct H245_TransportAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eH245_TransportAddress_unicastAddress,=0A=
+		eH245_TransportAddress_multicastAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		UnicastAddress unicastAddress;=0A=
+	};=0A=
+} H245_TransportAddress;=0A=
+=0A=
+typedef struct H2250LogicalChannelParameters {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH2250LogicalChannelParameters_nonStandard =3D (1 << 31),=0A=
+		eH2250LogicalChannelParameters_associatedSessionID =3D=0A=
+		    (1 << 30),=0A=
+		eH2250LogicalChannelParameters_mediaChannel =3D (1 << 29),=0A=
+		eH2250LogicalChannelParameters_mediaGuaranteedDelivery =3D=0A=
+		    (1 << 28),=0A=
+		eH2250LogicalChannelParameters_mediaControlChannel =3D=0A=
+		    (1 << 27),=0A=
+		eH2250LogicalChannelParameters_mediaControlGuaranteedDelivery=0A=
+		    =3D (1 << 26),=0A=
+		eH2250LogicalChannelParameters_silenceSuppression =3D (1 << 25),=0A=
+		eH2250LogicalChannelParameters_destination =3D (1 << 24),=0A=
+		eH2250LogicalChannelParameters_dynamicRTPPayloadType =3D=0A=
+		    (1 << 23),=0A=
+		eH2250LogicalChannelParameters_mediaPacketization =3D (1 << 22),=0A=
+		eH2250LogicalChannelParameters_transportCapability =3D=0A=
+		    (1 << 21),=0A=
+		eH2250LogicalChannelParameters_redundancyEncoding =3D (1 << 20),=0A=
+		eH2250LogicalChannelParameters_source =3D (1 << 19),=0A=
+	} options;=0A=
+	H245_TransportAddress mediaChannel;=0A=
+	H245_TransportAddress mediaControlChannel;=0A=
+} H2250LogicalChannelParameters;=0A=
+=0A=
+typedef struct =
OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters {	=
/* CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
222LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
223LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_v=
76LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_n=
one,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
+	};=0A=
+} =
OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannel_forwardLogicalChannelParameters {	/* =
SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannel_forwardLogicalChannelParameters_portNumber=0A=
+		    =3D (1 << 31),=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_forwardLogicalChannel=
Dependency=0A=
+		    =3D (1 << 30),=0A=
+		eOpenLogicalChannel_forwardLogicalChannelParameters_replacementFor=0A=
+		    =3D (1 << 29),=0A=
+	} options;=0A=
+	DataType dataType;=0A=
+	OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters=0A=
+	    multiplexParameters;=0A=
+} OpenLogicalChannel_forwardLogicalChannelParameters;=0A=
+=0A=
+typedef struct =
OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters {	=
/* CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
223LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_v=
76LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
+	};=0A=
+} =
OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannel_reverseLogicalChannelParameters {	/* =
SEQUENCE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters=0A=
+		    =3D (1 << 31),=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_reverseLogicalChannel=
Dependency=0A=
+		    =3D (1 << 30),=0A=
+		eOpenLogicalChannel_reverseLogicalChannelParameters_replacementFor=0A=
+		    =3D (1 << 29),=0A=
+	} options;=0A=
+	OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters=0A=
+	    multiplexParameters;=0A=
+} OpenLogicalChannel_reverseLogicalChannelParameters;=0A=
+=0A=
+typedef struct NetworkAccessParameters_networkAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eNetworkAccessParameters_networkAddress_q2931Address,=0A=
+		eNetworkAccessParameters_networkAddress_e164Address,=0A=
+		eNetworkAccessParameters_networkAddress_localAreaAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		H245_TransportAddress localAreaAddress;=0A=
+	};=0A=
+} NetworkAccessParameters_networkAddress;=0A=
+=0A=
+typedef struct NetworkAccessParameters {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eNetworkAccessParameters_distribution =3D (1 << 31),=0A=
+		eNetworkAccessParameters_externalReference =3D (1 << 30),=0A=
+		eNetworkAccessParameters_t120SetupProcedure =3D (1 << 29),=0A=
+	} options;=0A=
+	NetworkAccessParameters_networkAddress networkAddress;=0A=
+} NetworkAccessParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannel {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannel_reverseLogicalChannelParameters =3D=0A=
+		    (1 << 31),=0A=
+		eOpenLogicalChannel_separateStack =3D (1 << 30),=0A=
+		eOpenLogicalChannel_encryptionSync =3D (1 << 29),=0A=
+	} options;=0A=
+	OpenLogicalChannel_forwardLogicalChannelParameters=0A=
+	    forwardLogicalChannelParameters;=0A=
+	OpenLogicalChannel_reverseLogicalChannelParameters=0A=
+	    reverseLogicalChannelParameters;=0A=
+	NetworkAccessParameters separateStack;=0A=
+} OpenLogicalChannel;=0A=
+=0A=
+typedef struct Setup_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Setup_UUIE_fastStart;=0A=
+=0A=
+typedef struct Setup_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eSetup_UUIE_h245Address =3D (1 << 31),=0A=
+		eSetup_UUIE_sourceAddress =3D (1 << 30),=0A=
+		eSetup_UUIE_destinationAddress =3D (1 << 29),=0A=
+		eSetup_UUIE_destCallSignalAddress =3D (1 << 28),=0A=
+		eSetup_UUIE_destExtraCallInfo =3D (1 << 27),=0A=
+		eSetup_UUIE_destExtraCRV =3D (1 << 26),=0A=
+		eSetup_UUIE_callServices =3D (1 << 25),=0A=
+		eSetup_UUIE_sourceCallSignalAddress =3D (1 << 24),=0A=
+		eSetup_UUIE_remoteExtensionAddress =3D (1 << 23),=0A=
+		eSetup_UUIE_callIdentifier =3D (1 << 22),=0A=
+		eSetup_UUIE_h245SecurityCapability =3D (1 << 21),=0A=
+		eSetup_UUIE_tokens =3D (1 << 20),=0A=
+		eSetup_UUIE_cryptoTokens =3D (1 << 19),=0A=
+		eSetup_UUIE_fastStart =3D (1 << 18),=0A=
+		eSetup_UUIE_mediaWaitForConnect =3D (1 << 17),=0A=
+		eSetup_UUIE_canOverlapSend =3D (1 << 16),=0A=
+		eSetup_UUIE_endpointIdentifier =3D (1 << 15),=0A=
+		eSetup_UUIE_multipleCalls =3D (1 << 14),=0A=
+		eSetup_UUIE_maintainConnection =3D (1 << 13),=0A=
+		eSetup_UUIE_connectionParameters =3D (1 << 12),=0A=
+		eSetup_UUIE_language =3D (1 << 11),=0A=
+		eSetup_UUIE_presentationIndicator =3D (1 << 10),=0A=
+		eSetup_UUIE_screeningIndicator =3D (1 << 9),=0A=
+		eSetup_UUIE_serviceControl =3D (1 << 8),=0A=
+		eSetup_UUIE_symmetricOperationRequired =3D (1 << 7),=0A=
+		eSetup_UUIE_capacity =3D (1 << 6),=0A=
+		eSetup_UUIE_circuitInfo =3D (1 << 5),=0A=
+		eSetup_UUIE_desiredProtocols =3D (1 << 4),=0A=
+		eSetup_UUIE_neededFeatures =3D (1 << 3),=0A=
+		eSetup_UUIE_desiredFeatures =3D (1 << 2),=0A=
+		eSetup_UUIE_supportedFeatures =3D (1 << 1),=0A=
+		eSetup_UUIE_parallelH245Control =3D (1 << 0),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	TransportAddress destCallSignalAddress;=0A=
+	TransportAddress sourceCallSignalAddress;=0A=
+	Setup_UUIE_fastStart fastStart;=0A=
+} Setup_UUIE;=0A=
+=0A=
+typedef struct CallProceeding_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} CallProceeding_UUIE_fastStart;=0A=
+=0A=
+typedef struct CallProceeding_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eCallProceeding_UUIE_h245Address =3D (1 << 31),=0A=
+		eCallProceeding_UUIE_callIdentifier =3D (1 << 30),=0A=
+		eCallProceeding_UUIE_h245SecurityMode =3D (1 << 29),=0A=
+		eCallProceeding_UUIE_tokens =3D (1 << 28),=0A=
+		eCallProceeding_UUIE_cryptoTokens =3D (1 << 27),=0A=
+		eCallProceeding_UUIE_fastStart =3D (1 << 26),=0A=
+		eCallProceeding_UUIE_multipleCalls =3D (1 << 25),=0A=
+		eCallProceeding_UUIE_maintainConnection =3D (1 << 24),=0A=
+		eCallProceeding_UUIE_fastConnectRefused =3D (1 << 23),=0A=
+		eCallProceeding_UUIE_featureSet =3D (1 << 22),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	CallProceeding_UUIE_fastStart fastStart;=0A=
+} CallProceeding_UUIE;=0A=
+=0A=
+typedef struct Connect_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Connect_UUIE_fastStart;=0A=
+=0A=
+typedef struct Connect_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eConnect_UUIE_h245Address =3D (1 << 31),=0A=
+		eConnect_UUIE_callIdentifier =3D (1 << 30),=0A=
+		eConnect_UUIE_h245SecurityMode =3D (1 << 29),=0A=
+		eConnect_UUIE_tokens =3D (1 << 28),=0A=
+		eConnect_UUIE_cryptoTokens =3D (1 << 27),=0A=
+		eConnect_UUIE_fastStart =3D (1 << 26),=0A=
+		eConnect_UUIE_multipleCalls =3D (1 << 25),=0A=
+		eConnect_UUIE_maintainConnection =3D (1 << 24),=0A=
+		eConnect_UUIE_language =3D (1 << 23),=0A=
+		eConnect_UUIE_connectedAddress =3D (1 << 22),=0A=
+		eConnect_UUIE_presentationIndicator =3D (1 << 21),=0A=
+		eConnect_UUIE_screeningIndicator =3D (1 << 20),=0A=
+		eConnect_UUIE_fastConnectRefused =3D (1 << 19),=0A=
+		eConnect_UUIE_serviceControl =3D (1 << 18),=0A=
+		eConnect_UUIE_capacity =3D (1 << 17),=0A=
+		eConnect_UUIE_featureSet =3D (1 << 16),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	Connect_UUIE_fastStart fastStart;=0A=
+} Connect_UUIE;=0A=
+=0A=
+typedef struct Alerting_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Alerting_UUIE_fastStart;=0A=
+=0A=
+typedef struct Alerting_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eAlerting_UUIE_h245Address =3D (1 << 31),=0A=
+		eAlerting_UUIE_callIdentifier =3D (1 << 30),=0A=
+		eAlerting_UUIE_h245SecurityMode =3D (1 << 29),=0A=
+		eAlerting_UUIE_tokens =3D (1 << 28),=0A=
+		eAlerting_UUIE_cryptoTokens =3D (1 << 27),=0A=
+		eAlerting_UUIE_fastStart =3D (1 << 26),=0A=
+		eAlerting_UUIE_multipleCalls =3D (1 << 25),=0A=
+		eAlerting_UUIE_maintainConnection =3D (1 << 24),=0A=
+		eAlerting_UUIE_alertingAddress =3D (1 << 23),=0A=
+		eAlerting_UUIE_presentationIndicator =3D (1 << 22),=0A=
+		eAlerting_UUIE_screeningIndicator =3D (1 << 21),=0A=
+		eAlerting_UUIE_fastConnectRefused =3D (1 << 20),=0A=
+		eAlerting_UUIE_serviceControl =3D (1 << 19),=0A=
+		eAlerting_UUIE_capacity =3D (1 << 18),=0A=
+		eAlerting_UUIE_featureSet =3D (1 << 17),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	Alerting_UUIE_fastStart fastStart;=0A=
+} Alerting_UUIE;=0A=
+=0A=
+typedef struct Information_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Information_UUIE_fastStart;=0A=
+=0A=
+typedef struct Information_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eInformation_UUIE_callIdentifier =3D (1 << 31),=0A=
+		eInformation_UUIE_tokens =3D (1 << 30),=0A=
+		eInformation_UUIE_cryptoTokens =3D (1 << 29),=0A=
+		eInformation_UUIE_fastStart =3D (1 << 28),=0A=
+		eInformation_UUIE_fastConnectRefused =3D (1 << 27),=0A=
+		eInformation_UUIE_circuitInfo =3D (1 << 26),=0A=
+	} options;=0A=
+	Information_UUIE_fastStart fastStart;=0A=
+} Information_UUIE;=0A=
+=0A=
+typedef struct FacilityReason {	/* CHOICE */=0A=
+	enum {=0A=
+		eFacilityReason_routeCallToGatekeeper,=0A=
+		eFacilityReason_callForwarded,=0A=
+		eFacilityReason_routeCallToMC,=0A=
+		eFacilityReason_undefinedReason,=0A=
+		eFacilityReason_conferenceListChoice,=0A=
+		eFacilityReason_startH245,=0A=
+		eFacilityReason_noH245,=0A=
+		eFacilityReason_newTokens,=0A=
+		eFacilityReason_featureSetUpdate,=0A=
+		eFacilityReason_forwardedElements,=0A=
+		eFacilityReason_transportedInformation,=0A=
+	} choice;=0A=
+} FacilityReason;=0A=
+=0A=
+typedef struct Facility_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Facility_UUIE_fastStart;=0A=
+=0A=
+typedef struct Facility_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eFacility_UUIE_alternativeAddress =3D (1 << 31),=0A=
+		eFacility_UUIE_alternativeAliasAddress =3D (1 << 30),=0A=
+		eFacility_UUIE_conferenceID =3D (1 << 29),=0A=
+		eFacility_UUIE_callIdentifier =3D (1 << 28),=0A=
+		eFacility_UUIE_destExtraCallInfo =3D (1 << 27),=0A=
+		eFacility_UUIE_remoteExtensionAddress =3D (1 << 26),=0A=
+		eFacility_UUIE_tokens =3D (1 << 25),=0A=
+		eFacility_UUIE_cryptoTokens =3D (1 << 24),=0A=
+		eFacility_UUIE_conferences =3D (1 << 23),=0A=
+		eFacility_UUIE_h245Address =3D (1 << 22),=0A=
+		eFacility_UUIE_fastStart =3D (1 << 21),=0A=
+		eFacility_UUIE_multipleCalls =3D (1 << 20),=0A=
+		eFacility_UUIE_maintainConnection =3D (1 << 19),=0A=
+		eFacility_UUIE_fastConnectRefused =3D (1 << 18),=0A=
+		eFacility_UUIE_serviceControl =3D (1 << 17),=0A=
+		eFacility_UUIE_circuitInfo =3D (1 << 16),=0A=
+		eFacility_UUIE_featureSet =3D (1 << 15),=0A=
+		eFacility_UUIE_destinationInfo =3D (1 << 14),=0A=
+		eFacility_UUIE_h245SecurityMode =3D (1 << 13),=0A=
+	} options;=0A=
+	FacilityReason reason;=0A=
+	TransportAddress h245Address;=0A=
+	Facility_UUIE_fastStart fastStart;=0A=
+} Facility_UUIE;=0A=
+=0A=
+typedef struct Progress_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Progress_UUIE_fastStart;=0A=
+=0A=
+typedef struct Progress_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eProgress_UUIE_h245Address =3D (1 << 31),=0A=
+		eProgress_UUIE_h245SecurityMode =3D (1 << 30),=0A=
+		eProgress_UUIE_tokens =3D (1 << 29),=0A=
+		eProgress_UUIE_cryptoTokens =3D (1 << 28),=0A=
+		eProgress_UUIE_fastStart =3D (1 << 27),=0A=
+		eProgress_UUIE_multipleCalls =3D (1 << 26),=0A=
+		eProgress_UUIE_maintainConnection =3D (1 << 25),=0A=
+		eProgress_UUIE_fastConnectRefused =3D (1 << 24),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	Progress_UUIE_fastStart fastStart;=0A=
+} Progress_UUIE;=0A=
+=0A=
+typedef struct H323_UU_PDU_h323_message_body {	/* CHOICE */=0A=
+	enum {=0A=
+		eH323_UU_PDU_h323_message_body_setup,=0A=
+		eH323_UU_PDU_h323_message_body_callProceeding,=0A=
+		eH323_UU_PDU_h323_message_body_connect,=0A=
+		eH323_UU_PDU_h323_message_body_alerting,=0A=
+		eH323_UU_PDU_h323_message_body_information,=0A=
+		eH323_UU_PDU_h323_message_body_releaseComplete,=0A=
+		eH323_UU_PDU_h323_message_body_facility,=0A=
+		eH323_UU_PDU_h323_message_body_progress,=0A=
+		eH323_UU_PDU_h323_message_body_empty,=0A=
+		eH323_UU_PDU_h323_message_body_status,=0A=
+		eH323_UU_PDU_h323_message_body_statusInquiry,=0A=
+		eH323_UU_PDU_h323_message_body_setupAcknowledge,=0A=
+		eH323_UU_PDU_h323_message_body_notify,=0A=
+	} choice;=0A=
+	union {=0A=
+		Setup_UUIE setup;=0A=
+		CallProceeding_UUIE callProceeding;=0A=
+		Connect_UUIE connect;=0A=
+		Alerting_UUIE alerting;=0A=
+		Information_UUIE information;=0A=
+		Facility_UUIE facility;=0A=
+		Progress_UUIE progress;=0A=
+	};=0A=
+} H323_UU_PDU_h323_message_body;=0A=
+=0A=
+typedef struct RequestMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eRequestMessage_nonStandard,=0A=
+		eRequestMessage_masterSlaveDetermination,=0A=
+		eRequestMessage_terminalCapabilitySet,=0A=
+		eRequestMessage_openLogicalChannel,=0A=
+		eRequestMessage_closeLogicalChannel,=0A=
+		eRequestMessage_requestChannelClose,=0A=
+		eRequestMessage_multiplexEntrySend,=0A=
+		eRequestMessage_requestMultiplexEntry,=0A=
+		eRequestMessage_requestMode,=0A=
+		eRequestMessage_roundTripDelayRequest,=0A=
+		eRequestMessage_maintenanceLoopRequest,=0A=
+		eRequestMessage_communicationModeRequest,=0A=
+		eRequestMessage_conferenceRequest,=0A=
+		eRequestMessage_multilinkRequest,=0A=
+		eRequestMessage_logicalChannelRateRequest,=0A=
+	} choice;=0A=
+	union {=0A=
+		OpenLogicalChannel openLogicalChannel;=0A=
+	};=0A=
+} RequestMessage;=0A=
+=0A=
+typedef struct =
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=
 {	/* CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h222LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h2250LogicalChannelParameters,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
+	};=0A=
+} =
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=
;=0A=
+=0A=
+typedef struct OpenLogicalChannelAck_reverseLogicalChannelParameters {	=
/* SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannelAck_reverseLogicalChannelParameters_portNumber=0A=
+		    =3D (1 << 31),=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s=0A=
+		    =3D (1 << 30),=0A=
+		eOpenLogicalChannelAck_reverseLogicalChannelParameters_replacementFor=0A=
+		    =3D (1 << 29),=0A=
+	} options;=0A=
+	=
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=0A=
+	    multiplexParameters;=0A=
+} OpenLogicalChannelAck_reverseLogicalChannelParameters;=0A=
+=0A=
+typedef struct H2250LogicalChannelAckParameters {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH2250LogicalChannelAckParameters_nonStandard =3D (1 << 31),=0A=
+		eH2250LogicalChannelAckParameters_sessionID =3D (1 << 30),=0A=
+		eH2250LogicalChannelAckParameters_mediaChannel =3D (1 << 29),=0A=
+		eH2250LogicalChannelAckParameters_mediaControlChannel =3D=0A=
+		    (1 << 28),=0A=
+		eH2250LogicalChannelAckParameters_dynamicRTPPayloadType =3D=0A=
+		    (1 << 27),=0A=
+		eH2250LogicalChannelAckParameters_flowControlToZero =3D=0A=
+		    (1 << 26),=0A=
+		eH2250LogicalChannelAckParameters_portNumber =3D (1 << 25),=0A=
+	} options;=0A=
+	H245_TransportAddress mediaChannel;=0A=
+	H245_TransportAddress mediaControlChannel;=0A=
+} H2250LogicalChannelAckParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannelAck_forwardMultiplexAckParameters {	/* =
CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannelAck_forwardMultiplexAckParameters_h2250LogicalChannelA=
ckParameters,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelAckParameters=0A=
+		    h2250LogicalChannelAckParameters;=0A=
+	};=0A=
+} OpenLogicalChannelAck_forwardMultiplexAckParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannelAck {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannelAck_reverseLogicalChannelParameters =3D=0A=
+		    (1 << 31),=0A=
+		eOpenLogicalChannelAck_separateStack =3D (1 << 30),=0A=
+		eOpenLogicalChannelAck_forwardMultiplexAckParameters =3D=0A=
+		    (1 << 29),=0A=
+		eOpenLogicalChannelAck_encryptionSync =3D (1 << 28),=0A=
+	} options;=0A=
+	OpenLogicalChannelAck_reverseLogicalChannelParameters=0A=
+	    reverseLogicalChannelParameters;=0A=
+	OpenLogicalChannelAck_forwardMultiplexAckParameters=0A=
+	    forwardMultiplexAckParameters;=0A=
+} OpenLogicalChannelAck;=0A=
+=0A=
+typedef struct ResponseMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eResponseMessage_nonStandard,=0A=
+		eResponseMessage_masterSlaveDeterminationAck,=0A=
+		eResponseMessage_masterSlaveDeterminationReject,=0A=
+		eResponseMessage_terminalCapabilitySetAck,=0A=
+		eResponseMessage_terminalCapabilitySetReject,=0A=
+		eResponseMessage_openLogicalChannelAck,=0A=
+		eResponseMessage_openLogicalChannelReject,=0A=
+		eResponseMessage_closeLogicalChannelAck,=0A=
+		eResponseMessage_requestChannelCloseAck,=0A=
+		eResponseMessage_requestChannelCloseReject,=0A=
+		eResponseMessage_multiplexEntrySendAck,=0A=
+		eResponseMessage_multiplexEntrySendReject,=0A=
+		eResponseMessage_requestMultiplexEntryAck,=0A=
+		eResponseMessage_requestMultiplexEntryReject,=0A=
+		eResponseMessage_requestModeAck,=0A=
+		eResponseMessage_requestModeReject,=0A=
+		eResponseMessage_roundTripDelayResponse,=0A=
+		eResponseMessage_maintenanceLoopAck,=0A=
+		eResponseMessage_maintenanceLoopReject,=0A=
+		eResponseMessage_communicationModeResponse,=0A=
+		eResponseMessage_conferenceResponse,=0A=
+		eResponseMessage_multilinkResponse,=0A=
+		eResponseMessage_logicalChannelRateAcknowledge,=0A=
+		eResponseMessage_logicalChannelRateReject,=0A=
+	} choice;=0A=
+	union {=0A=
+		OpenLogicalChannelAck openLogicalChannelAck;=0A=
+	};=0A=
+} ResponseMessage;=0A=
+=0A=
+typedef struct MultimediaSystemControlMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eMultimediaSystemControlMessage_request,=0A=
+		eMultimediaSystemControlMessage_response,=0A=
+		eMultimediaSystemControlMessage_command,=0A=
+		eMultimediaSystemControlMessage_indication,=0A=
+	} choice;=0A=
+	union {=0A=
+		RequestMessage request;=0A=
+		ResponseMessage response;=0A=
+	};=0A=
+} MultimediaSystemControlMessage;=0A=
+=0A=
+typedef struct H323_UU_PDU_h245Control {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	MultimediaSystemControlMessage item[4];=0A=
+} H323_UU_PDU_h245Control;=0A=
+=0A=
+typedef struct H323_UU_PDU {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH323_UU_PDU_nonStandardData =3D (1 << 31),=0A=
+		eH323_UU_PDU_h4501SupplementaryService =3D (1 << 30),=0A=
+		eH323_UU_PDU_h245Tunneling =3D (1 << 29),=0A=
+		eH323_UU_PDU_h245Control =3D (1 << 28),=0A=
+		eH323_UU_PDU_nonStandardControl =3D (1 << 27),=0A=
+		eH323_UU_PDU_callLinkage =3D (1 << 26),=0A=
+		eH323_UU_PDU_tunnelledSignallingMessage =3D (1 << 25),=0A=
+		eH323_UU_PDU_provisionalRespToH245Tunneling =3D (1 << 24),=0A=
+		eH323_UU_PDU_stimulusControl =3D (1 << 23),=0A=
+		eH323_UU_PDU_genericData =3D (1 << 22),=0A=
+	} options;=0A=
+	H323_UU_PDU_h323_message_body h323_message_body;=0A=
+	H323_UU_PDU_h245Control h245Control;=0A=
+} H323_UU_PDU;=0A=
+=0A=
+typedef struct H323_UserInformation {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH323_UserInformation_user_data =3D (1 << 31),=0A=
+	} options;=0A=
+	H323_UU_PDU h323_uu_pdu;=0A=
+} H323_UserInformation;=0A=
+=0A=
+typedef struct GatekeeperRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eGatekeeperRequest_nonStandardData =3D (1 << 31),=0A=
+		eGatekeeperRequest_gatekeeperIdentifier =3D (1 << 30),=0A=
+		eGatekeeperRequest_callServices =3D (1 << 29),=0A=
+		eGatekeeperRequest_endpointAlias =3D (1 << 28),=0A=
+		eGatekeeperRequest_alternateEndpoints =3D (1 << 27),=0A=
+		eGatekeeperRequest_tokens =3D (1 << 26),=0A=
+		eGatekeeperRequest_cryptoTokens =3D (1 << 25),=0A=
+		eGatekeeperRequest_authenticationCapability =3D (1 << 24),=0A=
+		eGatekeeperRequest_algorithmOIDs =3D (1 << 23),=0A=
+		eGatekeeperRequest_integrity =3D (1 << 22),=0A=
+		eGatekeeperRequest_integrityCheckValue =3D (1 << 21),=0A=
+		eGatekeeperRequest_supportsAltGK =3D (1 << 20),=0A=
+		eGatekeeperRequest_featureSet =3D (1 << 19),=0A=
+		eGatekeeperRequest_genericData =3D (1 << 18),=0A=
+	} options;=0A=
+	TransportAddress rasAddress;=0A=
+} GatekeeperRequest;=0A=
+=0A=
+typedef struct GatekeeperConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eGatekeeperConfirm_nonStandardData =3D (1 << 31),=0A=
+		eGatekeeperConfirm_gatekeeperIdentifier =3D (1 << 30),=0A=
+		eGatekeeperConfirm_alternateGatekeeper =3D (1 << 29),=0A=
+		eGatekeeperConfirm_authenticationMode =3D (1 << 28),=0A=
+		eGatekeeperConfirm_tokens =3D (1 << 27),=0A=
+		eGatekeeperConfirm_cryptoTokens =3D (1 << 26),=0A=
+		eGatekeeperConfirm_algorithmOID =3D (1 << 25),=0A=
+		eGatekeeperConfirm_integrity =3D (1 << 24),=0A=
+		eGatekeeperConfirm_integrityCheckValue =3D (1 << 23),=0A=
+		eGatekeeperConfirm_featureSet =3D (1 << 22),=0A=
+		eGatekeeperConfirm_genericData =3D (1 << 21),=0A=
+	} options;=0A=
+	TransportAddress rasAddress;=0A=
+} GatekeeperConfirm;=0A=
+=0A=
+typedef struct RegistrationRequest_callSignalAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} RegistrationRequest_callSignalAddress;=0A=
+=0A=
+typedef struct RegistrationRequest_rasAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} RegistrationRequest_rasAddress;=0A=
+=0A=
+typedef struct RegistrationRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eRegistrationRequest_nonStandardData =3D (1 << 31),=0A=
+		eRegistrationRequest_terminalAlias =3D (1 << 30),=0A=
+		eRegistrationRequest_gatekeeperIdentifier =3D (1 << 29),=0A=
+		eRegistrationRequest_alternateEndpoints =3D (1 << 28),=0A=
+		eRegistrationRequest_timeToLive =3D (1 << 27),=0A=
+		eRegistrationRequest_tokens =3D (1 << 26),=0A=
+		eRegistrationRequest_cryptoTokens =3D (1 << 25),=0A=
+		eRegistrationRequest_integrityCheckValue =3D (1 << 24),=0A=
+		eRegistrationRequest_keepAlive =3D (1 << 23),=0A=
+		eRegistrationRequest_endpointIdentifier =3D (1 << 22),=0A=
+		eRegistrationRequest_willSupplyUUIEs =3D (1 << 21),=0A=
+		eRegistrationRequest_maintainConnection =3D (1 << 20),=0A=
+		eRegistrationRequest_alternateTransportAddresses =3D (1 << 19),=0A=
+		eRegistrationRequest_additiveRegistration =3D (1 << 18),=0A=
+		eRegistrationRequest_terminalAliasPattern =3D (1 << 17),=0A=
+		eRegistrationRequest_supportsAltGK =3D (1 << 16),=0A=
+		eRegistrationRequest_usageReportingCapability =3D (1 << 15),=0A=
+		eRegistrationRequest_multipleCalls =3D (1 << 14),=0A=
+		eRegistrationRequest_supportedH248Packages =3D (1 << 13),=0A=
+		eRegistrationRequest_callCreditCapability =3D (1 << 12),=0A=
+		eRegistrationRequest_capacityReportingCapability =3D (1 << 11),=0A=
+		eRegistrationRequest_capacity =3D (1 << 10),=0A=
+		eRegistrationRequest_featureSet =3D (1 << 9),=0A=
+		eRegistrationRequest_genericData =3D (1 << 8),=0A=
+	} options;=0A=
+	RegistrationRequest_callSignalAddress callSignalAddress;=0A=
+	RegistrationRequest_rasAddress rasAddress;=0A=
+	unsigned timeToLive;=0A=
+} RegistrationRequest;=0A=
+=0A=
+typedef struct RegistrationConfirm_callSignalAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} RegistrationConfirm_callSignalAddress;=0A=
+=0A=
+typedef struct RegistrationConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eRegistrationConfirm_nonStandardData =3D (1 << 31),=0A=
+		eRegistrationConfirm_terminalAlias =3D (1 << 30),=0A=
+		eRegistrationConfirm_gatekeeperIdentifier =3D (1 << 29),=0A=
+		eRegistrationConfirm_alternateGatekeeper =3D (1 << 28),=0A=
+		eRegistrationConfirm_timeToLive =3D (1 << 27),=0A=
+		eRegistrationConfirm_tokens =3D (1 << 26),=0A=
+		eRegistrationConfirm_cryptoTokens =3D (1 << 25),=0A=
+		eRegistrationConfirm_integrityCheckValue =3D (1 << 24),=0A=
+		eRegistrationConfirm_willRespondToIRR =3D (1 << 23),=0A=
+		eRegistrationConfirm_preGrantedARQ =3D (1 << 22),=0A=
+		eRegistrationConfirm_maintainConnection =3D (1 << 21),=0A=
+		eRegistrationConfirm_serviceControl =3D (1 << 20),=0A=
+		eRegistrationConfirm_supportsAdditiveRegistration =3D (1 << 19),=0A=
+		eRegistrationConfirm_terminalAliasPattern =3D (1 << 18),=0A=
+		eRegistrationConfirm_supportedPrefixes =3D (1 << 17),=0A=
+		eRegistrationConfirm_usageSpec =3D (1 << 16),=0A=
+		eRegistrationConfirm_featureServerAlias =3D (1 << 15),=0A=
+		eRegistrationConfirm_capacityReportingSpec =3D (1 << 14),=0A=
+		eRegistrationConfirm_featureSet =3D (1 << 13),=0A=
+		eRegistrationConfirm_genericData =3D (1 << 12),=0A=
+	} options;=0A=
+	RegistrationConfirm_callSignalAddress callSignalAddress;=0A=
+	unsigned timeToLive;=0A=
+} RegistrationConfirm;=0A=
+=0A=
+typedef struct UnregistrationRequest_callSignalAddress {	/* SEQUENCE OF =
*/=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} UnregistrationRequest_callSignalAddress;=0A=
+=0A=
+typedef struct UnregistrationRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eUnregistrationRequest_endpointAlias =3D (1 << 31),=0A=
+		eUnregistrationRequest_nonStandardData =3D (1 << 30),=0A=
+		eUnregistrationRequest_endpointIdentifier =3D (1 << 29),=0A=
+		eUnregistrationRequest_alternateEndpoints =3D (1 << 28),=0A=
+		eUnregistrationRequest_gatekeeperIdentifier =3D (1 << 27),=0A=
+		eUnregistrationRequest_tokens =3D (1 << 26),=0A=
+		eUnregistrationRequest_cryptoTokens =3D (1 << 25),=0A=
+		eUnregistrationRequest_integrityCheckValue =3D (1 << 24),=0A=
+		eUnregistrationRequest_reason =3D (1 << 23),=0A=
+		eUnregistrationRequest_endpointAliasPattern =3D (1 << 22),=0A=
+		eUnregistrationRequest_supportedPrefixes =3D (1 << 21),=0A=
+		eUnregistrationRequest_alternateGatekeeper =3D (1 << 20),=0A=
+		eUnregistrationRequest_genericData =3D (1 << 19),=0A=
+	} options;=0A=
+	UnregistrationRequest_callSignalAddress callSignalAddress;=0A=
+} UnregistrationRequest;=0A=
+=0A=
+typedef struct AdmissionRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eAdmissionRequest_callModel =3D (1 << 31),=0A=
+		eAdmissionRequest_destinationInfo =3D (1 << 30),=0A=
+		eAdmissionRequest_destCallSignalAddress =3D (1 << 29),=0A=
+		eAdmissionRequest_destExtraCallInfo =3D (1 << 28),=0A=
+		eAdmissionRequest_srcCallSignalAddress =3D (1 << 27),=0A=
+		eAdmissionRequest_nonStandardData =3D (1 << 26),=0A=
+		eAdmissionRequest_callServices =3D (1 << 25),=0A=
+		eAdmissionRequest_canMapAlias =3D (1 << 24),=0A=
+		eAdmissionRequest_callIdentifier =3D (1 << 23),=0A=
+		eAdmissionRequest_srcAlternatives =3D (1 << 22),=0A=
+		eAdmissionRequest_destAlternatives =3D (1 << 21),=0A=
+		eAdmissionRequest_gatekeeperIdentifier =3D (1 << 20),=0A=
+		eAdmissionRequest_tokens =3D (1 << 19),=0A=
+		eAdmissionRequest_cryptoTokens =3D (1 << 18),=0A=
+		eAdmissionRequest_integrityCheckValue =3D (1 << 17),=0A=
+		eAdmissionRequest_transportQOS =3D (1 << 16),=0A=
+		eAdmissionRequest_willSupplyUUIEs =3D (1 << 15),=0A=
+		eAdmissionRequest_callLinkage =3D (1 << 14),=0A=
+		eAdmissionRequest_gatewayDataRate =3D (1 << 13),=0A=
+		eAdmissionRequest_capacity =3D (1 << 12),=0A=
+		eAdmissionRequest_circuitInfo =3D (1 << 11),=0A=
+		eAdmissionRequest_desiredProtocols =3D (1 << 10),=0A=
+		eAdmissionRequest_desiredTunnelledProtocol =3D (1 << 9),=0A=
+		eAdmissionRequest_featureSet =3D (1 << 8),=0A=
+		eAdmissionRequest_genericData =3D (1 << 7),=0A=
+	} options;=0A=
+	TransportAddress destCallSignalAddress;=0A=
+	TransportAddress srcCallSignalAddress;=0A=
+} AdmissionRequest;=0A=
+=0A=
+typedef struct AdmissionConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eAdmissionConfirm_irrFrequency =3D (1 << 31),=0A=
+		eAdmissionConfirm_nonStandardData =3D (1 << 30),=0A=
+		eAdmissionConfirm_destinationInfo =3D (1 << 29),=0A=
+		eAdmissionConfirm_destExtraCallInfo =3D (1 << 28),=0A=
+		eAdmissionConfirm_destinationType =3D (1 << 27),=0A=
+		eAdmissionConfirm_remoteExtensionAddress =3D (1 << 26),=0A=
+		eAdmissionConfirm_alternateEndpoints =3D (1 << 25),=0A=
+		eAdmissionConfirm_tokens =3D (1 << 24),=0A=
+		eAdmissionConfirm_cryptoTokens =3D (1 << 23),=0A=
+		eAdmissionConfirm_integrityCheckValue =3D (1 << 22),=0A=
+		eAdmissionConfirm_transportQOS =3D (1 << 21),=0A=
+		eAdmissionConfirm_willRespondToIRR =3D (1 << 20),=0A=
+		eAdmissionConfirm_uuiesRequested =3D (1 << 19),=0A=
+		eAdmissionConfirm_language =3D (1 << 18),=0A=
+		eAdmissionConfirm_alternateTransportAddresses =3D (1 << 17),=0A=
+		eAdmissionConfirm_useSpecifiedTransport =3D (1 << 16),=0A=
+		eAdmissionConfirm_circuitInfo =3D (1 << 15),=0A=
+		eAdmissionConfirm_usageSpec =3D (1 << 14),=0A=
+		eAdmissionConfirm_supportedProtocols =3D (1 << 13),=0A=
+		eAdmissionConfirm_serviceControl =3D (1 << 12),=0A=
+		eAdmissionConfirm_multipleCalls =3D (1 << 11),=0A=
+		eAdmissionConfirm_featureSet =3D (1 << 10),=0A=
+		eAdmissionConfirm_genericData =3D (1 << 9),=0A=
+	} options;=0A=
+	TransportAddress destCallSignalAddress;=0A=
+} AdmissionConfirm;=0A=
+=0A=
+typedef struct LocationRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eLocationRequest_endpointIdentifier =3D (1 << 31),=0A=
+		eLocationRequest_nonStandardData =3D (1 << 30),=0A=
+		eLocationRequest_sourceInfo =3D (1 << 29),=0A=
+		eLocationRequest_canMapAlias =3D (1 << 28),=0A=
+		eLocationRequest_gatekeeperIdentifier =3D (1 << 27),=0A=
+		eLocationRequest_tokens =3D (1 << 26),=0A=
+		eLocationRequest_cryptoTokens =3D (1 << 25),=0A=
+		eLocationRequest_integrityCheckValue =3D (1 << 24),=0A=
+		eLocationRequest_desiredProtocols =3D (1 << 23),=0A=
+		eLocationRequest_desiredTunnelledProtocol =3D (1 << 22),=0A=
+		eLocationRequest_featureSet =3D (1 << 21),=0A=
+		eLocationRequest_genericData =3D (1 << 20),=0A=
+		eLocationRequest_hopCount =3D (1 << 19),=0A=
+		eLocationRequest_circuitInfo =3D (1 << 18),=0A=
+	} options;=0A=
+	TransportAddress replyAddress;=0A=
+} LocationRequest;=0A=
+=0A=
+typedef struct LocationConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eLocationConfirm_nonStandardData =3D (1 << 31),=0A=
+		eLocationConfirm_destinationInfo =3D (1 << 30),=0A=
+		eLocationConfirm_destExtraCallInfo =3D (1 << 29),=0A=
+		eLocationConfirm_destinationType =3D (1 << 28),=0A=
+		eLocationConfirm_remoteExtensionAddress =3D (1 << 27),=0A=
+		eLocationConfirm_alternateEndpoints =3D (1 << 26),=0A=
+		eLocationConfirm_tokens =3D (1 << 25),=0A=
+		eLocationConfirm_cryptoTokens =3D (1 << 24),=0A=
+		eLocationConfirm_integrityCheckValue =3D (1 << 23),=0A=
+		eLocationConfirm_alternateTransportAddresses =3D (1 << 22),=0A=
+		eLocationConfirm_supportedProtocols =3D (1 << 21),=0A=
+		eLocationConfirm_multipleCalls =3D (1 << 20),=0A=
+		eLocationConfirm_featureSet =3D (1 << 19),=0A=
+		eLocationConfirm_genericData =3D (1 << 18),=0A=
+		eLocationConfirm_circuitInfo =3D (1 << 17),=0A=
+		eLocationConfirm_serviceControl =3D (1 << 16),=0A=
+	} options;=0A=
+	TransportAddress callSignalAddress;=0A=
+	TransportAddress rasAddress;=0A=
+} LocationConfirm;=0A=
+=0A=
+typedef struct InfoRequestResponse_callSignalAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} InfoRequestResponse_callSignalAddress;=0A=
+=0A=
+typedef struct InfoRequestResponse {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eInfoRequestResponse_nonStandardData =3D (1 << 31),=0A=
+		eInfoRequestResponse_endpointAlias =3D (1 << 30),=0A=
+		eInfoRequestResponse_perCallInfo =3D (1 << 29),=0A=
+		eInfoRequestResponse_tokens =3D (1 << 28),=0A=
+		eInfoRequestResponse_cryptoTokens =3D (1 << 27),=0A=
+		eInfoRequestResponse_integrityCheckValue =3D (1 << 26),=0A=
+		eInfoRequestResponse_needResponse =3D (1 << 25),=0A=
+		eInfoRequestResponse_capacity =3D (1 << 24),=0A=
+		eInfoRequestResponse_irrStatus =3D (1 << 23),=0A=
+		eInfoRequestResponse_unsolicited =3D (1 << 22),=0A=
+		eInfoRequestResponse_genericData =3D (1 << 21),=0A=
+	} options;=0A=
+	TransportAddress rasAddress;=0A=
+	InfoRequestResponse_callSignalAddress callSignalAddress;=0A=
+} InfoRequestResponse;=0A=
+=0A=
+typedef struct RasMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eRasMessage_gatekeeperRequest,=0A=
+		eRasMessage_gatekeeperConfirm,=0A=
+		eRasMessage_gatekeeperReject,=0A=
+		eRasMessage_registrationRequest,=0A=
+		eRasMessage_registrationConfirm,=0A=
+		eRasMessage_registrationReject,=0A=
+		eRasMessage_unregistrationRequest,=0A=
+		eRasMessage_unregistrationConfirm,=0A=
+		eRasMessage_unregistrationReject,=0A=
+		eRasMessage_admissionRequest,=0A=
+		eRasMessage_admissionConfirm,=0A=
+		eRasMessage_admissionReject,=0A=
+		eRasMessage_bandwidthRequest,=0A=
+		eRasMessage_bandwidthConfirm,=0A=
+		eRasMessage_bandwidthReject,=0A=
+		eRasMessage_disengageRequest,=0A=
+		eRasMessage_disengageConfirm,=0A=
+		eRasMessage_disengageReject,=0A=
+		eRasMessage_locationRequest,=0A=
+		eRasMessage_locationConfirm,=0A=
+		eRasMessage_locationReject,=0A=
+		eRasMessage_infoRequest,=0A=
+		eRasMessage_infoRequestResponse,=0A=
+		eRasMessage_nonStandardMessage,=0A=
+		eRasMessage_unknownMessageResponse,=0A=
+		eRasMessage_requestInProgress,=0A=
+		eRasMessage_resourcesAvailableIndicate,=0A=
+		eRasMessage_resourcesAvailableConfirm,=0A=
+		eRasMessage_infoRequestAck,=0A=
+		eRasMessage_infoRequestNak,=0A=
+		eRasMessage_serviceControlIndication,=0A=
+		eRasMessage_serviceControlResponse,=0A=
+	} choice;=0A=
+	union {=0A=
+		GatekeeperRequest gatekeeperRequest;=0A=
+		GatekeeperConfirm gatekeeperConfirm;=0A=
+		RegistrationRequest registrationRequest;=0A=
+		RegistrationConfirm registrationConfirm;=0A=
+		UnregistrationRequest unregistrationRequest;=0A=
+		AdmissionRequest admissionRequest;=0A=
+		AdmissionConfirm admissionConfirm;=0A=
+		LocationRequest locationRequest;=0A=
+		LocationConfirm locationConfirm;=0A=
+		InfoRequestResponse infoRequestResponse;=0A=
+	};=0A=
+} RasMessage;=0A=
diff -pruN =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c =
linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c=0A=
--- =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c	=
2006-04-03 21:03:05.000000000 -0400=0A=
+++ linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c	=
2006-04-03 21:19:12.000000000 -0400=0A=
@@ -15,7 +15,7 @@=0A=
 #else=0A=
 #include <stdio.h>=0A=
 #endif=0A=
-#include "ip_conntrack_helper_h323_asn1.h"=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_helper_h323_asn1.h>=0A=
 =0A=
 /* Trace Flag */=0A=
 #ifndef H323_TRACE=0A=
diff -pruN =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h =
linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h=0A=
--- =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h	=
2006-04-03 21:03:05.000000000 -0400=0A=
+++ linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h	=
1969-12-31 19:00:00.000000000 -0500=0A=
@@ -1,98 +0,0 @@=0A=
-/***********************************************************************=
*****=0A=
- * ip_conntrack_helper_h323_asn1.h - BER and PER decoding library for =
H.323=0A=
- * 			      	     conntrack/NAT module.=0A=
- *=0A=
- * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@hotmail.com>=0A=
- *=0A=
- * This source code is licensed under General Public License version 2.=0A=
- *=0A=
- *=0A=
- * This library is based on H.225 version 4, H.235 version 2 and H.245=0A=
- * version 7. It is extremely optimized to decode only the absolutely=0A=
- * necessary objects in a signal for Linux kernel NAT module use, so =
don't=0A=
- * expect it to be a full ASN.1 library.=0A=
- *=0A=
- * Features:=0A=
- *=0A=
- * 1. Small. The total size of code plus data is less than 20 KB (IA32).=0A=
- * 2. Fast. Decoding Netmeeting's Setup signal 1 million times on a =
PIII 866=0A=
- *    takes only 3.9 seconds.=0A=
- * 3. No memory allocation. It uses a static object. No need to =
initialize or=0A=
- *    cleanup.=0A=
- * 4. Thread safe.=0A=
- * 5. Support embedded architectures that has no misaligned memory =
access=0A=
- *    support.=0A=
- *=0A=
- * Limitations:=0A=
- *=0A=
- * 1. At most 30 faststart entries. Actually this is limited by =
ethernet's MTU.=0A=
- *    If a Setup signal contains more than 30 faststart, the packet =
size will=0A=
- *    very likely exceed the MTU size, then the TPKT will be =
fragmented. I=0A=
- *    don't know how to handle this in a Netfilter module. Anybody can =
help?=0A=
- *    Although I think 30 is enough for most of the cases.=0A=
- * 2. IPv4 addresses only.=0A=
- *=0A=
- =
*************************************************************************=
***/=0A=
-=0A=
-#ifndef _IP_CONNTRACK_HELPER_H323_ASN1_H_=0A=
-#define _IP_CONNTRACK_HELPER_H323_ASN1_H_=0A=
-=0A=
-/***********************************************************************=
******=0A=
- * H.323 Types=0A=
- =
*************************************************************************=
***/=0A=
-#include "ip_conntrack_helper_h323_types.h"=0A=
-=0A=
-typedef struct {=0A=
-	enum {=0A=
-		Q931_NationalEscape =3D 0x00,=0A=
-		Q931_Alerting =3D 0x01,=0A=
-		Q931_CallProceeding =3D 0x02,=0A=
-		Q931_Connect =3D 0x07,=0A=
-		Q931_ConnectAck =3D 0x0F,=0A=
-		Q931_Progress =3D 0x03,=0A=
-		Q931_Setup =3D 0x05,=0A=
-		Q931_SetupAck =3D 0x0D,=0A=
-		Q931_Resume =3D 0x26,=0A=
-		Q931_ResumeAck =3D 0x2E,=0A=
-		Q931_ResumeReject =3D 0x22,=0A=
-		Q931_Suspend =3D 0x25,=0A=
-		Q931_SuspendAck =3D 0x2D,=0A=
-		Q931_SuspendReject =3D 0x21,=0A=
-		Q931_UserInformation =3D 0x20,=0A=
-		Q931_Disconnect =3D 0x45,=0A=
-		Q931_Release =3D 0x4D,=0A=
-		Q931_ReleaseComplete =3D 0x5A,=0A=
-		Q931_Restart =3D 0x46,=0A=
-		Q931_RestartAck =3D 0x4E,=0A=
-		Q931_Segment =3D 0x60,=0A=
-		Q931_CongestionCtrl =3D 0x79,=0A=
-		Q931_Information =3D 0x7B,=0A=
-		Q931_Notify =3D 0x6E,=0A=
-		Q931_Status =3D 0x7D,=0A=
-		Q931_StatusEnquiry =3D 0x75,=0A=
-		Q931_Facility =3D 0x62=0A=
-	} MessageType;=0A=
-	H323_UserInformation UUIE;=0A=
-} Q931;=0A=
-=0A=
-/***********************************************************************=
******=0A=
- * Decode Functions Return Codes=0A=
- =
*************************************************************************=
***/=0A=
-=0A=
-#define H323_ERROR_NONE 0	/* Decoded successfully */=0A=
-#define H323_ERROR_STOP 1	/* Decoding stopped, not really an error */=0A=
-#define H323_ERROR_BOUND -1=0A=
-#define H323_ERROR_RANGE -2=0A=
-=0A=
-=0A=
-/***********************************************************************=
******=0A=
- * Decode Functions=0A=
- =
*************************************************************************=
***/=0A=
-=0A=
-int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage * ras);=0A=
-int DecodeQ931(unsigned char *buf, size_t sz, Q931 * q931);=0A=
-int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,=0A=
-					 MultimediaSystemControlMessage *=0A=
-					 mscm);=0A=
-=0A=
-#endif=0A=
diff -pruN =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c =
linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323.c=0A=
--- linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-04-03 21:03:05.000000000 -0400=0A=
+++ linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-04-03 21:19:12.000000000 -0400=0A=
@@ -40,6 +40,21 @@=0A=
  * 	  4. Sort ASN.1 data to avoid forwarding declarations (suggested by=0A=
  * 	     Patrick McHardy)=0A=
  * 	  5. Reset next TPKT data length in get_tpkt_data()=0A=
+ *=0A=
+ * 	2006-03-20 - version 0.5=0A=
+ * 	  1. Change gkrouted_only default to 1 (Patrick McHardy)=0A=
+ * 	  2. Remove #ifndef offsetof in ASN.1 parser (Patrick McHardy)=0A=
+ * 	  3. Initialize datalen to 0 in ras_help to silence an incorrect =
gcc =0A=
+ * 	     warning (Patrick McHardy)=0A=
+ *=0A=
+ * 	2006-03-22 - version 0.6=0A=
+ * 	  1. get_h225_addr incorrectly defined as 'static' (found by=0A=
+ * 	     Andrew Morton)=0A=
+ *=0A=
+ * 	2006-03-25 - version 0.7=0A=
+ * 	  1. Added new parameter 'default_rrq_ttl'.=0A=
+ * 	  2. Made get_h245_addr static (suggested by Adrian Bunk)=0A=
+ * 	  3. Changed to use EXPORT_SYMBOL_GPL (suggested by Adrian Bunk)=0A=
  */=0A=
 =0A=
 #include <linux/config.h>=0A=
@@ -54,8 +69,6 @@=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_h323.h>=0A=
 #include <linux/moduleparam.h>=0A=
 =0A=
-#include "ip_conntrack_helper_h323_asn1.h"=0A=
-=0A=
 #if 0=0A=
 #define DEBUGP printk=0A=
 #else=0A=
@@ -63,6 +76,10 @@=0A=
 #endif=0A=
 =0A=
 /* Parameters */=0A=
+static int default_rrq_ttl =3D 300;=0A=
+module_param(default_rrq_ttl, int, 0600);=0A=
+MODULE_PARM_DESC(default_rrq_ttl, "use this TTL if it's missing in =
RRQ");=0A=
+=0A=
 static int gkrouted_only =3D 1;=0A=
 module_param(gkrouted_only, int, 0600);=0A=
 MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");=0A=
@@ -222,8 +239,8 @@ static int get_tpkt_data(struct sk_buff =0A=
 }=0A=
 =0A=
 =
/************************************************************************=
****/=0A=
-int get_h245_addr(unsigned char *data, H245_TransportAddress * addr,=0A=
-		  u_int32_t * ip, u_int16_t * port)=0A=
+static int get_h245_addr(unsigned char *data, H245_TransportAddress * =
addr,=0A=
+			 u_int32_t * ip, u_int16_t * port)=0A=
 {=0A=
 	unsigned char *p;=0A=
 =0A=
@@ -1302,7 +1319,7 @@ static int process_rrq(struct sk_buff **=0A=
 		DEBUGP("ip_ct_ras: RRQ TTL =3D %u seconds\n", rrq->timeToLive);=0A=
 		info->timeout =3D rrq->timeToLive;=0A=
 	} else=0A=
-		info->timeout =3D 0;=0A=
+		info->timeout =3D default_rrq_ttl;=0A=
 =0A=
 	return 0;=0A=
 }=0A=
@@ -1713,18 +1730,17 @@ static int __init init(void)=0A=
 module_init(init);=0A=
 module_exit(fini);=0A=
 =0A=
-EXPORT_SYMBOL(get_h245_addr);=0A=
-EXPORT_SYMBOL(get_h225_addr);=0A=
-EXPORT_SYMBOL(ip_conntrack_h245_expect);=0A=
-EXPORT_SYMBOL(ip_conntrack_q931_expect);=0A=
-EXPORT_SYMBOL(set_h245_addr_hook);=0A=
-EXPORT_SYMBOL(set_h225_addr_hook);=0A=
-EXPORT_SYMBOL(set_sig_addr_hook);=0A=
-EXPORT_SYMBOL(set_ras_addr_hook);=0A=
-EXPORT_SYMBOL(nat_rtp_rtcp_hook);=0A=
-EXPORT_SYMBOL(nat_t120_hook);=0A=
-EXPORT_SYMBOL(nat_h245_hook);=0A=
-EXPORT_SYMBOL(nat_q931_hook);=0A=
+EXPORT_SYMBOL_GPL(get_h225_addr);=0A=
+EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);=0A=
+EXPORT_SYMBOL_GPL(ip_conntrack_q931_expect);=0A=
+EXPORT_SYMBOL_GPL(set_h245_addr_hook);=0A=
+EXPORT_SYMBOL_GPL(set_h225_addr_hook);=0A=
+EXPORT_SYMBOL_GPL(set_sig_addr_hook);=0A=
+EXPORT_SYMBOL_GPL(set_ras_addr_hook);=0A=
+EXPORT_SYMBOL_GPL(nat_rtp_rtcp_hook);=0A=
+EXPORT_SYMBOL_GPL(nat_t120_hook);=0A=
+EXPORT_SYMBOL_GPL(nat_h245_hook);=0A=
+EXPORT_SYMBOL_GPL(nat_q931_hook);=0A=
 =0A=
 MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");=0A=
 MODULE_DESCRIPTION("H.323 connection tracking helper");=0A=
diff -pruN =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h=
 linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h=0A=
--- =
linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h=
	2006-04-03 21:03:05.000000000 -0400=0A=
+++ linux-2.6.17-rc1/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h	=
1969-12-31 19:00:00.000000000 -0500=0A=
@@ -1,938 +0,0 @@=0A=
-/* Generated by Jing Min Zhao's ASN.1 parser, Mar 15 2006=0A=
- *=0A=
- * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>=0A=
- *=0A=
- * This source code is licensed under General Public License version 2.=0A=
- */=0A=
-=0A=
-typedef struct TransportAddress_ipAddress {	/* SEQUENCE */=0A=
-	int options;		/* No use */=0A=
-	unsigned ip;=0A=
-} TransportAddress_ipAddress;=0A=
-=0A=
-typedef struct TransportAddress {	/* CHOICE */=0A=
-	enum {=0A=
-		eTransportAddress_ipAddress,=0A=
-		eTransportAddress_ipSourceRoute,=0A=
-		eTransportAddress_ipxAddress,=0A=
-		eTransportAddress_ip6Address,=0A=
-		eTransportAddress_netBios,=0A=
-		eTransportAddress_nsap,=0A=
-		eTransportAddress_nonStandardAddress,=0A=
-	} choice;=0A=
-	union {=0A=
-		TransportAddress_ipAddress ipAddress;=0A=
-	};=0A=
-} TransportAddress;=0A=
-=0A=
-typedef struct DataProtocolCapability {	/* CHOICE */=0A=
-	enum {=0A=
-		eDataProtocolCapability_nonStandard,=0A=
-		eDataProtocolCapability_v14buffered,=0A=
-		eDataProtocolCapability_v42lapm,=0A=
-		eDataProtocolCapability_hdlcFrameTunnelling,=0A=
-		eDataProtocolCapability_h310SeparateVCStack,=0A=
-		eDataProtocolCapability_h310SingleVCStack,=0A=
-		eDataProtocolCapability_transparent,=0A=
-		eDataProtocolCapability_segmentationAndReassembly,=0A=
-		eDataProtocolCapability_hdlcFrameTunnelingwSAR,=0A=
-		eDataProtocolCapability_v120,=0A=
-		eDataProtocolCapability_separateLANStack,=0A=
-		eDataProtocolCapability_v76wCompression,=0A=
-		eDataProtocolCapability_tcp,=0A=
-		eDataProtocolCapability_udp,=0A=
-	} choice;=0A=
-} DataProtocolCapability;=0A=
-=0A=
-typedef struct DataApplicationCapability_application {	/* CHOICE */=0A=
-	enum {=0A=
-		eDataApplicationCapability_application_nonStandard,=0A=
-		eDataApplicationCapability_application_t120,=0A=
-		eDataApplicationCapability_application_dsm_cc,=0A=
-		eDataApplicationCapability_application_userData,=0A=
-		eDataApplicationCapability_application_t84,=0A=
-		eDataApplicationCapability_application_t434,=0A=
-		eDataApplicationCapability_application_h224,=0A=
-		eDataApplicationCapability_application_nlpid,=0A=
-		eDataApplicationCapability_application_dsvdControl,=0A=
-		eDataApplicationCapability_application_h222DataPartitioning,=0A=
-		eDataApplicationCapability_application_t30fax,=0A=
-		eDataApplicationCapability_application_t140,=0A=
-		eDataApplicationCapability_application_t38fax,=0A=
-		eDataApplicationCapability_application_genericDataCapability,=0A=
-	} choice;=0A=
-	union {=0A=
-		DataProtocolCapability t120;=0A=
-	};=0A=
-} DataApplicationCapability_application;=0A=
-=0A=
-typedef struct DataApplicationCapability {	/* SEQUENCE */=0A=
-	int options;		/* No use */=0A=
-	DataApplicationCapability_application application;=0A=
-} DataApplicationCapability;=0A=
-=0A=
-typedef struct DataType {	/* CHOICE */=0A=
-	enum {=0A=
-		eDataType_nonStandard,=0A=
-		eDataType_nullData,=0A=
-		eDataType_videoData,=0A=
-		eDataType_audioData,=0A=
-		eDataType_data,=0A=
-		eDataType_encryptionData,=0A=
-		eDataType_h235Control,=0A=
-		eDataType_h235Media,=0A=
-		eDataType_multiplexedStream,=0A=
-	} choice;=0A=
-	union {=0A=
-		DataApplicationCapability data;=0A=
-	};=0A=
-} DataType;=0A=
-=0A=
-typedef struct UnicastAddress_iPAddress {	/* SEQUENCE */=0A=
-	int options;		/* No use */=0A=
-	unsigned network;=0A=
-} UnicastAddress_iPAddress;=0A=
-=0A=
-typedef struct UnicastAddress {	/* CHOICE */=0A=
-	enum {=0A=
-		eUnicastAddress_iPAddress,=0A=
-		eUnicastAddress_iPXAddress,=0A=
-		eUnicastAddress_iP6Address,=0A=
-		eUnicastAddress_netBios,=0A=
-		eUnicastAddress_iPSourceRouteAddress,=0A=
-		eUnicastAddress_nsap,=0A=
-		eUnicastAddress_nonStandardAddress,=0A=
-	} choice;=0A=
-	union {=0A=
-		UnicastAddress_iPAddress iPAddress;=0A=
-	};=0A=
-} UnicastAddress;=0A=
-=0A=
-typedef struct H245_TransportAddress {	/* CHOICE */=0A=
-	enum {=0A=
-		eH245_TransportAddress_unicastAddress,=0A=
-		eH245_TransportAddress_multicastAddress,=0A=
-	} choice;=0A=
-	union {=0A=
-		UnicastAddress unicastAddress;=0A=
-	};=0A=
-} H245_TransportAddress;=0A=
-=0A=
-typedef struct H2250LogicalChannelParameters {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eH2250LogicalChannelParameters_nonStandard =3D (1 << 31),=0A=
-		eH2250LogicalChannelParameters_associatedSessionID =3D=0A=
-		    (1 << 30),=0A=
-		eH2250LogicalChannelParameters_mediaChannel =3D (1 << 29),=0A=
-		eH2250LogicalChannelParameters_mediaGuaranteedDelivery =3D=0A=
-		    (1 << 28),=0A=
-		eH2250LogicalChannelParameters_mediaControlChannel =3D=0A=
-		    (1 << 27),=0A=
-		eH2250LogicalChannelParameters_mediaControlGuaranteedDelivery=0A=
-		    =3D (1 << 26),=0A=
-		eH2250LogicalChannelParameters_silenceSuppression =3D (1 << 25),=0A=
-		eH2250LogicalChannelParameters_destination =3D (1 << 24),=0A=
-		eH2250LogicalChannelParameters_dynamicRTPPayloadType =3D=0A=
-		    (1 << 23),=0A=
-		eH2250LogicalChannelParameters_mediaPacketization =3D (1 << 22),=0A=
-		eH2250LogicalChannelParameters_transportCapability =3D=0A=
-		    (1 << 21),=0A=
-		eH2250LogicalChannelParameters_redundancyEncoding =3D (1 << 20),=0A=
-		eH2250LogicalChannelParameters_source =3D (1 << 19),=0A=
-	} options;=0A=
-	H245_TransportAddress mediaChannel;=0A=
-	H245_TransportAddress mediaControlChannel;=0A=
-} H2250LogicalChannelParameters;=0A=
-=0A=
-typedef struct =
OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters {	=
/* CHOICE */=0A=
-	enum {=0A=
-		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
222LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
223LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_v=
76LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_n=
one,=0A=
-	} choice;=0A=
-	union {=0A=
-		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
-	};=0A=
-} =
OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters;=0A=
-=0A=
-typedef struct OpenLogicalChannel_forwardLogicalChannelParameters {	/* =
SEQUENCE */=0A=
-	enum {=0A=
-		eOpenLogicalChannel_forwardLogicalChannelParameters_portNumber=0A=
-		    =3D (1 << 31),=0A=
-		=
eOpenLogicalChannel_forwardLogicalChannelParameters_forwardLogicalChannel=
Dependency=0A=
-		    =3D (1 << 30),=0A=
-		eOpenLogicalChannel_forwardLogicalChannelParameters_replacementFor=0A=
-		    =3D (1 << 29),=0A=
-	} options;=0A=
-	DataType dataType;=0A=
-	OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters=0A=
-	    multiplexParameters;=0A=
-} OpenLogicalChannel_forwardLogicalChannelParameters;=0A=
-=0A=
-typedef struct =
OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters {	=
/* CHOICE */=0A=
-	enum {=0A=
-		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
223LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_v=
76LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters,=0A=
-	} choice;=0A=
-	union {=0A=
-		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
-	};=0A=
-} =
OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters;=0A=
-=0A=
-typedef struct OpenLogicalChannel_reverseLogicalChannelParameters {	/* =
SEQUENCE */=0A=
-	enum {=0A=
-		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters=0A=
-		    =3D (1 << 31),=0A=
-		=
eOpenLogicalChannel_reverseLogicalChannelParameters_reverseLogicalChannel=
Dependency=0A=
-		    =3D (1 << 30),=0A=
-		eOpenLogicalChannel_reverseLogicalChannelParameters_replacementFor=0A=
-		    =3D (1 << 29),=0A=
-	} options;=0A=
-	OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters=0A=
-	    multiplexParameters;=0A=
-} OpenLogicalChannel_reverseLogicalChannelParameters;=0A=
-=0A=
-typedef struct NetworkAccessParameters_networkAddress {	/* CHOICE */=0A=
-	enum {=0A=
-		eNetworkAccessParameters_networkAddress_q2931Address,=0A=
-		eNetworkAccessParameters_networkAddress_e164Address,=0A=
-		eNetworkAccessParameters_networkAddress_localAreaAddress,=0A=
-	} choice;=0A=
-	union {=0A=
-		H245_TransportAddress localAreaAddress;=0A=
-	};=0A=
-} NetworkAccessParameters_networkAddress;=0A=
-=0A=
-typedef struct NetworkAccessParameters {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eNetworkAccessParameters_distribution =3D (1 << 31),=0A=
-		eNetworkAccessParameters_externalReference =3D (1 << 30),=0A=
-		eNetworkAccessParameters_t120SetupProcedure =3D (1 << 29),=0A=
-	} options;=0A=
-	NetworkAccessParameters_networkAddress networkAddress;=0A=
-} NetworkAccessParameters;=0A=
-=0A=
-typedef struct OpenLogicalChannel {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eOpenLogicalChannel_reverseLogicalChannelParameters =3D=0A=
-		    (1 << 31),=0A=
-		eOpenLogicalChannel_separateStack =3D (1 << 30),=0A=
-		eOpenLogicalChannel_encryptionSync =3D (1 << 29),=0A=
-	} options;=0A=
-	OpenLogicalChannel_forwardLogicalChannelParameters=0A=
-	    forwardLogicalChannelParameters;=0A=
-	OpenLogicalChannel_reverseLogicalChannelParameters=0A=
-	    reverseLogicalChannelParameters;=0A=
-	NetworkAccessParameters separateStack;=0A=
-} OpenLogicalChannel;=0A=
-=0A=
-typedef struct Setup_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} Setup_UUIE_fastStart;=0A=
-=0A=
-typedef struct Setup_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eSetup_UUIE_h245Address =3D (1 << 31),=0A=
-		eSetup_UUIE_sourceAddress =3D (1 << 30),=0A=
-		eSetup_UUIE_destinationAddress =3D (1 << 29),=0A=
-		eSetup_UUIE_destCallSignalAddress =3D (1 << 28),=0A=
-		eSetup_UUIE_destExtraCallInfo =3D (1 << 27),=0A=
-		eSetup_UUIE_destExtraCRV =3D (1 << 26),=0A=
-		eSetup_UUIE_callServices =3D (1 << 25),=0A=
-		eSetup_UUIE_sourceCallSignalAddress =3D (1 << 24),=0A=
-		eSetup_UUIE_remoteExtensionAddress =3D (1 << 23),=0A=
-		eSetup_UUIE_callIdentifier =3D (1 << 22),=0A=
-		eSetup_UUIE_h245SecurityCapability =3D (1 << 21),=0A=
-		eSetup_UUIE_tokens =3D (1 << 20),=0A=
-		eSetup_UUIE_cryptoTokens =3D (1 << 19),=0A=
-		eSetup_UUIE_fastStart =3D (1 << 18),=0A=
-		eSetup_UUIE_mediaWaitForConnect =3D (1 << 17),=0A=
-		eSetup_UUIE_canOverlapSend =3D (1 << 16),=0A=
-		eSetup_UUIE_endpointIdentifier =3D (1 << 15),=0A=
-		eSetup_UUIE_multipleCalls =3D (1 << 14),=0A=
-		eSetup_UUIE_maintainConnection =3D (1 << 13),=0A=
-		eSetup_UUIE_connectionParameters =3D (1 << 12),=0A=
-		eSetup_UUIE_language =3D (1 << 11),=0A=
-		eSetup_UUIE_presentationIndicator =3D (1 << 10),=0A=
-		eSetup_UUIE_screeningIndicator =3D (1 << 9),=0A=
-		eSetup_UUIE_serviceControl =3D (1 << 8),=0A=
-		eSetup_UUIE_symmetricOperationRequired =3D (1 << 7),=0A=
-		eSetup_UUIE_capacity =3D (1 << 6),=0A=
-		eSetup_UUIE_circuitInfo =3D (1 << 5),=0A=
-		eSetup_UUIE_desiredProtocols =3D (1 << 4),=0A=
-		eSetup_UUIE_neededFeatures =3D (1 << 3),=0A=
-		eSetup_UUIE_desiredFeatures =3D (1 << 2),=0A=
-		eSetup_UUIE_supportedFeatures =3D (1 << 1),=0A=
-		eSetup_UUIE_parallelH245Control =3D (1 << 0),=0A=
-	} options;=0A=
-	TransportAddress h245Address;=0A=
-	TransportAddress destCallSignalAddress;=0A=
-	TransportAddress sourceCallSignalAddress;=0A=
-	Setup_UUIE_fastStart fastStart;=0A=
-} Setup_UUIE;=0A=
-=0A=
-typedef struct CallProceeding_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} CallProceeding_UUIE_fastStart;=0A=
-=0A=
-typedef struct CallProceeding_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eCallProceeding_UUIE_h245Address =3D (1 << 31),=0A=
-		eCallProceeding_UUIE_callIdentifier =3D (1 << 30),=0A=
-		eCallProceeding_UUIE_h245SecurityMode =3D (1 << 29),=0A=
-		eCallProceeding_UUIE_tokens =3D (1 << 28),=0A=
-		eCallProceeding_UUIE_cryptoTokens =3D (1 << 27),=0A=
-		eCallProceeding_UUIE_fastStart =3D (1 << 26),=0A=
-		eCallProceeding_UUIE_multipleCalls =3D (1 << 25),=0A=
-		eCallProceeding_UUIE_maintainConnection =3D (1 << 24),=0A=
-		eCallProceeding_UUIE_fastConnectRefused =3D (1 << 23),=0A=
-		eCallProceeding_UUIE_featureSet =3D (1 << 22),=0A=
-	} options;=0A=
-	TransportAddress h245Address;=0A=
-	CallProceeding_UUIE_fastStart fastStart;=0A=
-} CallProceeding_UUIE;=0A=
-=0A=
-typedef struct Connect_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} Connect_UUIE_fastStart;=0A=
-=0A=
-typedef struct Connect_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eConnect_UUIE_h245Address =3D (1 << 31),=0A=
-		eConnect_UUIE_callIdentifier =3D (1 << 30),=0A=
-		eConnect_UUIE_h245SecurityMode =3D (1 << 29),=0A=
-		eConnect_UUIE_tokens =3D (1 << 28),=0A=
-		eConnect_UUIE_cryptoTokens =3D (1 << 27),=0A=
-		eConnect_UUIE_fastStart =3D (1 << 26),=0A=
-		eConnect_UUIE_multipleCalls =3D (1 << 25),=0A=
-		eConnect_UUIE_maintainConnection =3D (1 << 24),=0A=
-		eConnect_UUIE_language =3D (1 << 23),=0A=
-		eConnect_UUIE_connectedAddress =3D (1 << 22),=0A=
-		eConnect_UUIE_presentationIndicator =3D (1 << 21),=0A=
-		eConnect_UUIE_screeningIndicator =3D (1 << 20),=0A=
-		eConnect_UUIE_fastConnectRefused =3D (1 << 19),=0A=
-		eConnect_UUIE_serviceControl =3D (1 << 18),=0A=
-		eConnect_UUIE_capacity =3D (1 << 17),=0A=
-		eConnect_UUIE_featureSet =3D (1 << 16),=0A=
-	} options;=0A=
-	TransportAddress h245Address;=0A=
-	Connect_UUIE_fastStart fastStart;=0A=
-} Connect_UUIE;=0A=
-=0A=
-typedef struct Alerting_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} Alerting_UUIE_fastStart;=0A=
-=0A=
-typedef struct Alerting_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eAlerting_UUIE_h245Address =3D (1 << 31),=0A=
-		eAlerting_UUIE_callIdentifier =3D (1 << 30),=0A=
-		eAlerting_UUIE_h245SecurityMode =3D (1 << 29),=0A=
-		eAlerting_UUIE_tokens =3D (1 << 28),=0A=
-		eAlerting_UUIE_cryptoTokens =3D (1 << 27),=0A=
-		eAlerting_UUIE_fastStart =3D (1 << 26),=0A=
-		eAlerting_UUIE_multipleCalls =3D (1 << 25),=0A=
-		eAlerting_UUIE_maintainConnection =3D (1 << 24),=0A=
-		eAlerting_UUIE_alertingAddress =3D (1 << 23),=0A=
-		eAlerting_UUIE_presentationIndicator =3D (1 << 22),=0A=
-		eAlerting_UUIE_screeningIndicator =3D (1 << 21),=0A=
-		eAlerting_UUIE_fastConnectRefused =3D (1 << 20),=0A=
-		eAlerting_UUIE_serviceControl =3D (1 << 19),=0A=
-		eAlerting_UUIE_capacity =3D (1 << 18),=0A=
-		eAlerting_UUIE_featureSet =3D (1 << 17),=0A=
-	} options;=0A=
-	TransportAddress h245Address;=0A=
-	Alerting_UUIE_fastStart fastStart;=0A=
-} Alerting_UUIE;=0A=
-=0A=
-typedef struct Information_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} Information_UUIE_fastStart;=0A=
-=0A=
-typedef struct Information_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eInformation_UUIE_callIdentifier =3D (1 << 31),=0A=
-		eInformation_UUIE_tokens =3D (1 << 30),=0A=
-		eInformation_UUIE_cryptoTokens =3D (1 << 29),=0A=
-		eInformation_UUIE_fastStart =3D (1 << 28),=0A=
-		eInformation_UUIE_fastConnectRefused =3D (1 << 27),=0A=
-		eInformation_UUIE_circuitInfo =3D (1 << 26),=0A=
-	} options;=0A=
-	Information_UUIE_fastStart fastStart;=0A=
-} Information_UUIE;=0A=
-=0A=
-typedef struct FacilityReason {	/* CHOICE */=0A=
-	enum {=0A=
-		eFacilityReason_routeCallToGatekeeper,=0A=
-		eFacilityReason_callForwarded,=0A=
-		eFacilityReason_routeCallToMC,=0A=
-		eFacilityReason_undefinedReason,=0A=
-		eFacilityReason_conferenceListChoice,=0A=
-		eFacilityReason_startH245,=0A=
-		eFacilityReason_noH245,=0A=
-		eFacilityReason_newTokens,=0A=
-		eFacilityReason_featureSetUpdate,=0A=
-		eFacilityReason_forwardedElements,=0A=
-		eFacilityReason_transportedInformation,=0A=
-	} choice;=0A=
-} FacilityReason;=0A=
-=0A=
-typedef struct Facility_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} Facility_UUIE_fastStart;=0A=
-=0A=
-typedef struct Facility_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eFacility_UUIE_alternativeAddress =3D (1 << 31),=0A=
-		eFacility_UUIE_alternativeAliasAddress =3D (1 << 30),=0A=
-		eFacility_UUIE_conferenceID =3D (1 << 29),=0A=
-		eFacility_UUIE_callIdentifier =3D (1 << 28),=0A=
-		eFacility_UUIE_destExtraCallInfo =3D (1 << 27),=0A=
-		eFacility_UUIE_remoteExtensionAddress =3D (1 << 26),=0A=
-		eFacility_UUIE_tokens =3D (1 << 25),=0A=
-		eFacility_UUIE_cryptoTokens =3D (1 << 24),=0A=
-		eFacility_UUIE_conferences =3D (1 << 23),=0A=
-		eFacility_UUIE_h245Address =3D (1 << 22),=0A=
-		eFacility_UUIE_fastStart =3D (1 << 21),=0A=
-		eFacility_UUIE_multipleCalls =3D (1 << 20),=0A=
-		eFacility_UUIE_maintainConnection =3D (1 << 19),=0A=
-		eFacility_UUIE_fastConnectRefused =3D (1 << 18),=0A=
-		eFacility_UUIE_serviceControl =3D (1 << 17),=0A=
-		eFacility_UUIE_circuitInfo =3D (1 << 16),=0A=
-		eFacility_UUIE_featureSet =3D (1 << 15),=0A=
-		eFacility_UUIE_destinationInfo =3D (1 << 14),=0A=
-		eFacility_UUIE_h245SecurityMode =3D (1 << 13),=0A=
-	} options;=0A=
-	FacilityReason reason;=0A=
-	TransportAddress h245Address;=0A=
-	Facility_UUIE_fastStart fastStart;=0A=
-} Facility_UUIE;=0A=
-=0A=
-typedef struct Progress_UUIE_fastStart {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	OpenLogicalChannel item[30];=0A=
-} Progress_UUIE_fastStart;=0A=
-=0A=
-typedef struct Progress_UUIE {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eProgress_UUIE_h245Address =3D (1 << 31),=0A=
-		eProgress_UUIE_h245SecurityMode =3D (1 << 30),=0A=
-		eProgress_UUIE_tokens =3D (1 << 29),=0A=
-		eProgress_UUIE_cryptoTokens =3D (1 << 28),=0A=
-		eProgress_UUIE_fastStart =3D (1 << 27),=0A=
-		eProgress_UUIE_multipleCalls =3D (1 << 26),=0A=
-		eProgress_UUIE_maintainConnection =3D (1 << 25),=0A=
-		eProgress_UUIE_fastConnectRefused =3D (1 << 24),=0A=
-	} options;=0A=
-	TransportAddress h245Address;=0A=
-	Progress_UUIE_fastStart fastStart;=0A=
-} Progress_UUIE;=0A=
-=0A=
-typedef struct H323_UU_PDU_h323_message_body {	/* CHOICE */=0A=
-	enum {=0A=
-		eH323_UU_PDU_h323_message_body_setup,=0A=
-		eH323_UU_PDU_h323_message_body_callProceeding,=0A=
-		eH323_UU_PDU_h323_message_body_connect,=0A=
-		eH323_UU_PDU_h323_message_body_alerting,=0A=
-		eH323_UU_PDU_h323_message_body_information,=0A=
-		eH323_UU_PDU_h323_message_body_releaseComplete,=0A=
-		eH323_UU_PDU_h323_message_body_facility,=0A=
-		eH323_UU_PDU_h323_message_body_progress,=0A=
-		eH323_UU_PDU_h323_message_body_empty,=0A=
-		eH323_UU_PDU_h323_message_body_status,=0A=
-		eH323_UU_PDU_h323_message_body_statusInquiry,=0A=
-		eH323_UU_PDU_h323_message_body_setupAcknowledge,=0A=
-		eH323_UU_PDU_h323_message_body_notify,=0A=
-	} choice;=0A=
-	union {=0A=
-		Setup_UUIE setup;=0A=
-		CallProceeding_UUIE callProceeding;=0A=
-		Connect_UUIE connect;=0A=
-		Alerting_UUIE alerting;=0A=
-		Information_UUIE information;=0A=
-		Facility_UUIE facility;=0A=
-		Progress_UUIE progress;=0A=
-	};=0A=
-} H323_UU_PDU_h323_message_body;=0A=
-=0A=
-typedef struct RequestMessage {	/* CHOICE */=0A=
-	enum {=0A=
-		eRequestMessage_nonStandard,=0A=
-		eRequestMessage_masterSlaveDetermination,=0A=
-		eRequestMessage_terminalCapabilitySet,=0A=
-		eRequestMessage_openLogicalChannel,=0A=
-		eRequestMessage_closeLogicalChannel,=0A=
-		eRequestMessage_requestChannelClose,=0A=
-		eRequestMessage_multiplexEntrySend,=0A=
-		eRequestMessage_requestMultiplexEntry,=0A=
-		eRequestMessage_requestMode,=0A=
-		eRequestMessage_roundTripDelayRequest,=0A=
-		eRequestMessage_maintenanceLoopRequest,=0A=
-		eRequestMessage_communicationModeRequest,=0A=
-		eRequestMessage_conferenceRequest,=0A=
-		eRequestMessage_multilinkRequest,=0A=
-		eRequestMessage_logicalChannelRateRequest,=0A=
-	} choice;=0A=
-	union {=0A=
-		OpenLogicalChannel openLogicalChannel;=0A=
-	};=0A=
-} RequestMessage;=0A=
-=0A=
-typedef struct =
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=
 {	/* CHOICE */=0A=
-	enum {=0A=
-		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h222LogicalChannelParameters,=0A=
-		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h2250LogicalChannelParameters,=0A=
-	} choice;=0A=
-	union {=0A=
-		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
-	};=0A=
-} =
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=
;=0A=
-=0A=
-typedef struct OpenLogicalChannelAck_reverseLogicalChannelParameters {	=
/* SEQUENCE */=0A=
-	enum {=0A=
-		eOpenLogicalChannelAck_reverseLogicalChannelParameters_portNumber=0A=
-		    =3D (1 << 31),=0A=
-		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s=0A=
-		    =3D (1 << 30),=0A=
-		eOpenLogicalChannelAck_reverseLogicalChannelParameters_replacementFor=0A=
-		    =3D (1 << 29),=0A=
-	} options;=0A=
-	=
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=0A=
-	    multiplexParameters;=0A=
-} OpenLogicalChannelAck_reverseLogicalChannelParameters;=0A=
-=0A=
-typedef struct H2250LogicalChannelAckParameters {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eH2250LogicalChannelAckParameters_nonStandard =3D (1 << 31),=0A=
-		eH2250LogicalChannelAckParameters_sessionID =3D (1 << 30),=0A=
-		eH2250LogicalChannelAckParameters_mediaChannel =3D (1 << 29),=0A=
-		eH2250LogicalChannelAckParameters_mediaControlChannel =3D=0A=
-		    (1 << 28),=0A=
-		eH2250LogicalChannelAckParameters_dynamicRTPPayloadType =3D=0A=
-		    (1 << 27),=0A=
-		eH2250LogicalChannelAckParameters_flowControlToZero =3D=0A=
-		    (1 << 26),=0A=
-		eH2250LogicalChannelAckParameters_portNumber =3D (1 << 25),=0A=
-	} options;=0A=
-	H245_TransportAddress mediaChannel;=0A=
-	H245_TransportAddress mediaControlChannel;=0A=
-} H2250LogicalChannelAckParameters;=0A=
-=0A=
-typedef struct OpenLogicalChannelAck_forwardMultiplexAckParameters {	/* =
CHOICE */=0A=
-	enum {=0A=
-		=
eOpenLogicalChannelAck_forwardMultiplexAckParameters_h2250LogicalChannelA=
ckParameters,=0A=
-	} choice;=0A=
-	union {=0A=
-		H2250LogicalChannelAckParameters=0A=
-		    h2250LogicalChannelAckParameters;=0A=
-	};=0A=
-} OpenLogicalChannelAck_forwardMultiplexAckParameters;=0A=
-=0A=
-typedef struct OpenLogicalChannelAck {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eOpenLogicalChannelAck_reverseLogicalChannelParameters =3D=0A=
-		    (1 << 31),=0A=
-		eOpenLogicalChannelAck_separateStack =3D (1 << 30),=0A=
-		eOpenLogicalChannelAck_forwardMultiplexAckParameters =3D=0A=
-		    (1 << 29),=0A=
-		eOpenLogicalChannelAck_encryptionSync =3D (1 << 28),=0A=
-	} options;=0A=
-	OpenLogicalChannelAck_reverseLogicalChannelParameters=0A=
-	    reverseLogicalChannelParameters;=0A=
-	OpenLogicalChannelAck_forwardMultiplexAckParameters=0A=
-	    forwardMultiplexAckParameters;=0A=
-} OpenLogicalChannelAck;=0A=
-=0A=
-typedef struct ResponseMessage {	/* CHOICE */=0A=
-	enum {=0A=
-		eResponseMessage_nonStandard,=0A=
-		eResponseMessage_masterSlaveDeterminationAck,=0A=
-		eResponseMessage_masterSlaveDeterminationReject,=0A=
-		eResponseMessage_terminalCapabilitySetAck,=0A=
-		eResponseMessage_terminalCapabilitySetReject,=0A=
-		eResponseMessage_openLogicalChannelAck,=0A=
-		eResponseMessage_openLogicalChannelReject,=0A=
-		eResponseMessage_closeLogicalChannelAck,=0A=
-		eResponseMessage_requestChannelCloseAck,=0A=
-		eResponseMessage_requestChannelCloseReject,=0A=
-		eResponseMessage_multiplexEntrySendAck,=0A=
-		eResponseMessage_multiplexEntrySendReject,=0A=
-		eResponseMessage_requestMultiplexEntryAck,=0A=
-		eResponseMessage_requestMultiplexEntryReject,=0A=
-		eResponseMessage_requestModeAck,=0A=
-		eResponseMessage_requestModeReject,=0A=
-		eResponseMessage_roundTripDelayResponse,=0A=
-		eResponseMessage_maintenanceLoopAck,=0A=
-		eResponseMessage_maintenanceLoopReject,=0A=
-		eResponseMessage_communicationModeResponse,=0A=
-		eResponseMessage_conferenceResponse,=0A=
-		eResponseMessage_multilinkResponse,=0A=
-		eResponseMessage_logicalChannelRateAcknowledge,=0A=
-		eResponseMessage_logicalChannelRateReject,=0A=
-	} choice;=0A=
-	union {=0A=
-		OpenLogicalChannelAck openLogicalChannelAck;=0A=
-	};=0A=
-} ResponseMessage;=0A=
-=0A=
-typedef struct MultimediaSystemControlMessage {	/* CHOICE */=0A=
-	enum {=0A=
-		eMultimediaSystemControlMessage_request,=0A=
-		eMultimediaSystemControlMessage_response,=0A=
-		eMultimediaSystemControlMessage_command,=0A=
-		eMultimediaSystemControlMessage_indication,=0A=
-	} choice;=0A=
-	union {=0A=
-		RequestMessage request;=0A=
-		ResponseMessage response;=0A=
-	};=0A=
-} MultimediaSystemControlMessage;=0A=
-=0A=
-typedef struct H323_UU_PDU_h245Control {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	MultimediaSystemControlMessage item[4];=0A=
-} H323_UU_PDU_h245Control;=0A=
-=0A=
-typedef struct H323_UU_PDU {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eH323_UU_PDU_nonStandardData =3D (1 << 31),=0A=
-		eH323_UU_PDU_h4501SupplementaryService =3D (1 << 30),=0A=
-		eH323_UU_PDU_h245Tunneling =3D (1 << 29),=0A=
-		eH323_UU_PDU_h245Control =3D (1 << 28),=0A=
-		eH323_UU_PDU_nonStandardControl =3D (1 << 27),=0A=
-		eH323_UU_PDU_callLinkage =3D (1 << 26),=0A=
-		eH323_UU_PDU_tunnelledSignallingMessage =3D (1 << 25),=0A=
-		eH323_UU_PDU_provisionalRespToH245Tunneling =3D (1 << 24),=0A=
-		eH323_UU_PDU_stimulusControl =3D (1 << 23),=0A=
-		eH323_UU_PDU_genericData =3D (1 << 22),=0A=
-	} options;=0A=
-	H323_UU_PDU_h323_message_body h323_message_body;=0A=
-	H323_UU_PDU_h245Control h245Control;=0A=
-} H323_UU_PDU;=0A=
-=0A=
-typedef struct H323_UserInformation {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eH323_UserInformation_user_data =3D (1 << 31),=0A=
-	} options;=0A=
-	H323_UU_PDU h323_uu_pdu;=0A=
-} H323_UserInformation;=0A=
-=0A=
-typedef struct GatekeeperRequest {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eGatekeeperRequest_nonStandardData =3D (1 << 31),=0A=
-		eGatekeeperRequest_gatekeeperIdentifier =3D (1 << 30),=0A=
-		eGatekeeperRequest_callServices =3D (1 << 29),=0A=
-		eGatekeeperRequest_endpointAlias =3D (1 << 28),=0A=
-		eGatekeeperRequest_alternateEndpoints =3D (1 << 27),=0A=
-		eGatekeeperRequest_tokens =3D (1 << 26),=0A=
-		eGatekeeperRequest_cryptoTokens =3D (1 << 25),=0A=
-		eGatekeeperRequest_authenticationCapability =3D (1 << 24),=0A=
-		eGatekeeperRequest_algorithmOIDs =3D (1 << 23),=0A=
-		eGatekeeperRequest_integrity =3D (1 << 22),=0A=
-		eGatekeeperRequest_integrityCheckValue =3D (1 << 21),=0A=
-		eGatekeeperRequest_supportsAltGK =3D (1 << 20),=0A=
-		eGatekeeperRequest_featureSet =3D (1 << 19),=0A=
-		eGatekeeperRequest_genericData =3D (1 << 18),=0A=
-	} options;=0A=
-	TransportAddress rasAddress;=0A=
-} GatekeeperRequest;=0A=
-=0A=
-typedef struct GatekeeperConfirm {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eGatekeeperConfirm_nonStandardData =3D (1 << 31),=0A=
-		eGatekeeperConfirm_gatekeeperIdentifier =3D (1 << 30),=0A=
-		eGatekeeperConfirm_alternateGatekeeper =3D (1 << 29),=0A=
-		eGatekeeperConfirm_authenticationMode =3D (1 << 28),=0A=
-		eGatekeeperConfirm_tokens =3D (1 << 27),=0A=
-		eGatekeeperConfirm_cryptoTokens =3D (1 << 26),=0A=
-		eGatekeeperConfirm_algorithmOID =3D (1 << 25),=0A=
-		eGatekeeperConfirm_integrity =3D (1 << 24),=0A=
-		eGatekeeperConfirm_integrityCheckValue =3D (1 << 23),=0A=
-		eGatekeeperConfirm_featureSet =3D (1 << 22),=0A=
-		eGatekeeperConfirm_genericData =3D (1 << 21),=0A=
-	} options;=0A=
-	TransportAddress rasAddress;=0A=
-} GatekeeperConfirm;=0A=
-=0A=
-typedef struct RegistrationRequest_callSignalAddress {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	TransportAddress item[10];=0A=
-} RegistrationRequest_callSignalAddress;=0A=
-=0A=
-typedef struct RegistrationRequest_rasAddress {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	TransportAddress item[10];=0A=
-} RegistrationRequest_rasAddress;=0A=
-=0A=
-typedef struct RegistrationRequest {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eRegistrationRequest_nonStandardData =3D (1 << 31),=0A=
-		eRegistrationRequest_terminalAlias =3D (1 << 30),=0A=
-		eRegistrationRequest_gatekeeperIdentifier =3D (1 << 29),=0A=
-		eRegistrationRequest_alternateEndpoints =3D (1 << 28),=0A=
-		eRegistrationRequest_timeToLive =3D (1 << 27),=0A=
-		eRegistrationRequest_tokens =3D (1 << 26),=0A=
-		eRegistrationRequest_cryptoTokens =3D (1 << 25),=0A=
-		eRegistrationRequest_integrityCheckValue =3D (1 << 24),=0A=
-		eRegistrationRequest_keepAlive =3D (1 << 23),=0A=
-		eRegistrationRequest_endpointIdentifier =3D (1 << 22),=0A=
-		eRegistrationRequest_willSupplyUUIEs =3D (1 << 21),=0A=
-		eRegistrationRequest_maintainConnection =3D (1 << 20),=0A=
-		eRegistrationRequest_alternateTransportAddresses =3D (1 << 19),=0A=
-		eRegistrationRequest_additiveRegistration =3D (1 << 18),=0A=
-		eRegistrationRequest_terminalAliasPattern =3D (1 << 17),=0A=
-		eRegistrationRequest_supportsAltGK =3D (1 << 16),=0A=
-		eRegistrationRequest_usageReportingCapability =3D (1 << 15),=0A=
-		eRegistrationRequest_multipleCalls =3D (1 << 14),=0A=
-		eRegistrationRequest_supportedH248Packages =3D (1 << 13),=0A=
-		eRegistrationRequest_callCreditCapability =3D (1 << 12),=0A=
-		eRegistrationRequest_capacityReportingCapability =3D (1 << 11),=0A=
-		eRegistrationRequest_capacity =3D (1 << 10),=0A=
-		eRegistrationRequest_featureSet =3D (1 << 9),=0A=
-		eRegistrationRequest_genericData =3D (1 << 8),=0A=
-	} options;=0A=
-	RegistrationRequest_callSignalAddress callSignalAddress;=0A=
-	RegistrationRequest_rasAddress rasAddress;=0A=
-	unsigned timeToLive;=0A=
-} RegistrationRequest;=0A=
-=0A=
-typedef struct RegistrationConfirm_callSignalAddress {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	TransportAddress item[10];=0A=
-} RegistrationConfirm_callSignalAddress;=0A=
-=0A=
-typedef struct RegistrationConfirm {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eRegistrationConfirm_nonStandardData =3D (1 << 31),=0A=
-		eRegistrationConfirm_terminalAlias =3D (1 << 30),=0A=
-		eRegistrationConfirm_gatekeeperIdentifier =3D (1 << 29),=0A=
-		eRegistrationConfirm_alternateGatekeeper =3D (1 << 28),=0A=
-		eRegistrationConfirm_timeToLive =3D (1 << 27),=0A=
-		eRegistrationConfirm_tokens =3D (1 << 26),=0A=
-		eRegistrationConfirm_cryptoTokens =3D (1 << 25),=0A=
-		eRegistrationConfirm_integrityCheckValue =3D (1 << 24),=0A=
-		eRegistrationConfirm_willRespondToIRR =3D (1 << 23),=0A=
-		eRegistrationConfirm_preGrantedARQ =3D (1 << 22),=0A=
-		eRegistrationConfirm_maintainConnection =3D (1 << 21),=0A=
-		eRegistrationConfirm_serviceControl =3D (1 << 20),=0A=
-		eRegistrationConfirm_supportsAdditiveRegistration =3D (1 << 19),=0A=
-		eRegistrationConfirm_terminalAliasPattern =3D (1 << 18),=0A=
-		eRegistrationConfirm_supportedPrefixes =3D (1 << 17),=0A=
-		eRegistrationConfirm_usageSpec =3D (1 << 16),=0A=
-		eRegistrationConfirm_featureServerAlias =3D (1 << 15),=0A=
-		eRegistrationConfirm_capacityReportingSpec =3D (1 << 14),=0A=
-		eRegistrationConfirm_featureSet =3D (1 << 13),=0A=
-		eRegistrationConfirm_genericData =3D (1 << 12),=0A=
-	} options;=0A=
-	RegistrationConfirm_callSignalAddress callSignalAddress;=0A=
-	unsigned timeToLive;=0A=
-} RegistrationConfirm;=0A=
-=0A=
-typedef struct UnregistrationRequest_callSignalAddress {	/* SEQUENCE OF =
*/=0A=
-	int count;=0A=
-	TransportAddress item[10];=0A=
-} UnregistrationRequest_callSignalAddress;=0A=
-=0A=
-typedef struct UnregistrationRequest {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eUnregistrationRequest_endpointAlias =3D (1 << 31),=0A=
-		eUnregistrationRequest_nonStandardData =3D (1 << 30),=0A=
-		eUnregistrationRequest_endpointIdentifier =3D (1 << 29),=0A=
-		eUnregistrationRequest_alternateEndpoints =3D (1 << 28),=0A=
-		eUnregistrationRequest_gatekeeperIdentifier =3D (1 << 27),=0A=
-		eUnregistrationRequest_tokens =3D (1 << 26),=0A=
-		eUnregistrationRequest_cryptoTokens =3D (1 << 25),=0A=
-		eUnregistrationRequest_integrityCheckValue =3D (1 << 24),=0A=
-		eUnregistrationRequest_reason =3D (1 << 23),=0A=
-		eUnregistrationRequest_endpointAliasPattern =3D (1 << 22),=0A=
-		eUnregistrationRequest_supportedPrefixes =3D (1 << 21),=0A=
-		eUnregistrationRequest_alternateGatekeeper =3D (1 << 20),=0A=
-		eUnregistrationRequest_genericData =3D (1 << 19),=0A=
-	} options;=0A=
-	UnregistrationRequest_callSignalAddress callSignalAddress;=0A=
-} UnregistrationRequest;=0A=
-=0A=
-typedef struct AdmissionRequest {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eAdmissionRequest_callModel =3D (1 << 31),=0A=
-		eAdmissionRequest_destinationInfo =3D (1 << 30),=0A=
-		eAdmissionRequest_destCallSignalAddress =3D (1 << 29),=0A=
-		eAdmissionRequest_destExtraCallInfo =3D (1 << 28),=0A=
-		eAdmissionRequest_srcCallSignalAddress =3D (1 << 27),=0A=
-		eAdmissionRequest_nonStandardData =3D (1 << 26),=0A=
-		eAdmissionRequest_callServices =3D (1 << 25),=0A=
-		eAdmissionRequest_canMapAlias =3D (1 << 24),=0A=
-		eAdmissionRequest_callIdentifier =3D (1 << 23),=0A=
-		eAdmissionRequest_srcAlternatives =3D (1 << 22),=0A=
-		eAdmissionRequest_destAlternatives =3D (1 << 21),=0A=
-		eAdmissionRequest_gatekeeperIdentifier =3D (1 << 20),=0A=
-		eAdmissionRequest_tokens =3D (1 << 19),=0A=
-		eAdmissionRequest_cryptoTokens =3D (1 << 18),=0A=
-		eAdmissionRequest_integrityCheckValue =3D (1 << 17),=0A=
-		eAdmissionRequest_transportQOS =3D (1 << 16),=0A=
-		eAdmissionRequest_willSupplyUUIEs =3D (1 << 15),=0A=
-		eAdmissionRequest_callLinkage =3D (1 << 14),=0A=
-		eAdmissionRequest_gatewayDataRate =3D (1 << 13),=0A=
-		eAdmissionRequest_capacity =3D (1 << 12),=0A=
-		eAdmissionRequest_circuitInfo =3D (1 << 11),=0A=
-		eAdmissionRequest_desiredProtocols =3D (1 << 10),=0A=
-		eAdmissionRequest_desiredTunnelledProtocol =3D (1 << 9),=0A=
-		eAdmissionRequest_featureSet =3D (1 << 8),=0A=
-		eAdmissionRequest_genericData =3D (1 << 7),=0A=
-	} options;=0A=
-	TransportAddress destCallSignalAddress;=0A=
-	TransportAddress srcCallSignalAddress;=0A=
-} AdmissionRequest;=0A=
-=0A=
-typedef struct AdmissionConfirm {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eAdmissionConfirm_irrFrequency =3D (1 << 31),=0A=
-		eAdmissionConfirm_nonStandardData =3D (1 << 30),=0A=
-		eAdmissionConfirm_destinationInfo =3D (1 << 29),=0A=
-		eAdmissionConfirm_destExtraCallInfo =3D (1 << 28),=0A=
-		eAdmissionConfirm_destinationType =3D (1 << 27),=0A=
-		eAdmissionConfirm_remoteExtensionAddress =3D (1 << 26),=0A=
-		eAdmissionConfirm_alternateEndpoints =3D (1 << 25),=0A=
-		eAdmissionConfirm_tokens =3D (1 << 24),=0A=
-		eAdmissionConfirm_cryptoTokens =3D (1 << 23),=0A=
-		eAdmissionConfirm_integrityCheckValue =3D (1 << 22),=0A=
-		eAdmissionConfirm_transportQOS =3D (1 << 21),=0A=
-		eAdmissionConfirm_willRespondToIRR =3D (1 << 20),=0A=
-		eAdmissionConfirm_uuiesRequested =3D (1 << 19),=0A=
-		eAdmissionConfirm_language =3D (1 << 18),=0A=
-		eAdmissionConfirm_alternateTransportAddresses =3D (1 << 17),=0A=
-		eAdmissionConfirm_useSpecifiedTransport =3D (1 << 16),=0A=
-		eAdmissionConfirm_circuitInfo =3D (1 << 15),=0A=
-		eAdmissionConfirm_usageSpec =3D (1 << 14),=0A=
-		eAdmissionConfirm_supportedProtocols =3D (1 << 13),=0A=
-		eAdmissionConfirm_serviceControl =3D (1 << 12),=0A=
-		eAdmissionConfirm_multipleCalls =3D (1 << 11),=0A=
-		eAdmissionConfirm_featureSet =3D (1 << 10),=0A=
-		eAdmissionConfirm_genericData =3D (1 << 9),=0A=
-	} options;=0A=
-	TransportAddress destCallSignalAddress;=0A=
-} AdmissionConfirm;=0A=
-=0A=
-typedef struct LocationRequest {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eLocationRequest_endpointIdentifier =3D (1 << 31),=0A=
-		eLocationRequest_nonStandardData =3D (1 << 30),=0A=
-		eLocationRequest_sourceInfo =3D (1 << 29),=0A=
-		eLocationRequest_canMapAlias =3D (1 << 28),=0A=
-		eLocationRequest_gatekeeperIdentifier =3D (1 << 27),=0A=
-		eLocationRequest_tokens =3D (1 << 26),=0A=
-		eLocationRequest_cryptoTokens =3D (1 << 25),=0A=
-		eLocationRequest_integrityCheckValue =3D (1 << 24),=0A=
-		eLocationRequest_desiredProtocols =3D (1 << 23),=0A=
-		eLocationRequest_desiredTunnelledProtocol =3D (1 << 22),=0A=
-		eLocationRequest_featureSet =3D (1 << 21),=0A=
-		eLocationRequest_genericData =3D (1 << 20),=0A=
-		eLocationRequest_hopCount =3D (1 << 19),=0A=
-		eLocationRequest_circuitInfo =3D (1 << 18),=0A=
-	} options;=0A=
-	TransportAddress replyAddress;=0A=
-} LocationRequest;=0A=
-=0A=
-typedef struct LocationConfirm {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eLocationConfirm_nonStandardData =3D (1 << 31),=0A=
-		eLocationConfirm_destinationInfo =3D (1 << 30),=0A=
-		eLocationConfirm_destExtraCallInfo =3D (1 << 29),=0A=
-		eLocationConfirm_destinationType =3D (1 << 28),=0A=
-		eLocationConfirm_remoteExtensionAddress =3D (1 << 27),=0A=
-		eLocationConfirm_alternateEndpoints =3D (1 << 26),=0A=
-		eLocationConfirm_tokens =3D (1 << 25),=0A=
-		eLocationConfirm_cryptoTokens =3D (1 << 24),=0A=
-		eLocationConfirm_integrityCheckValue =3D (1 << 23),=0A=
-		eLocationConfirm_alternateTransportAddresses =3D (1 << 22),=0A=
-		eLocationConfirm_supportedProtocols =3D (1 << 21),=0A=
-		eLocationConfirm_multipleCalls =3D (1 << 20),=0A=
-		eLocationConfirm_featureSet =3D (1 << 19),=0A=
-		eLocationConfirm_genericData =3D (1 << 18),=0A=
-		eLocationConfirm_circuitInfo =3D (1 << 17),=0A=
-		eLocationConfirm_serviceControl =3D (1 << 16),=0A=
-	} options;=0A=
-	TransportAddress callSignalAddress;=0A=
-	TransportAddress rasAddress;=0A=
-} LocationConfirm;=0A=
-=0A=
-typedef struct InfoRequestResponse_callSignalAddress {	/* SEQUENCE OF */=0A=
-	int count;=0A=
-	TransportAddress item[10];=0A=
-} InfoRequestResponse_callSignalAddress;=0A=
-=0A=
-typedef struct InfoRequestResponse {	/* SEQUENCE */=0A=
-	enum {=0A=
-		eInfoRequestResponse_nonStandardData =3D (1 << 31),=0A=
-		eInfoRequestResponse_endpointAlias =3D (1 << 30),=0A=
-		eInfoRequestResponse_perCallInfo =3D (1 << 29),=0A=
-		eInfoRequestResponse_tokens =3D (1 << 28),=0A=
-		eInfoRequestResponse_cryptoTokens =3D (1 << 27),=0A=
-		eInfoRequestResponse_integrityCheckValue =3D (1 << 26),=0A=
-		eInfoRequestResponse_needResponse =3D (1 << 25),=0A=
-		eInfoRequestResponse_capacity =3D (1 << 24),=0A=
-		eInfoRequestResponse_irrStatus =3D (1 << 23),=0A=
-		eInfoRequestResponse_unsolicited =3D (1 << 22),=0A=
-		eInfoRequestResponse_genericData =3D (1 << 21),=0A=
-	} options;=0A=
-	TransportAddress rasAddress;=0A=
-	InfoRequestResponse_callSignalAddress callSignalAddress;=0A=
-} InfoRequestResponse;=0A=
-=0A=
-typedef struct RasMessage {	/* CHOICE */=0A=
-	enum {=0A=
-		eRasMessage_gatekeeperRequest,=0A=
-		eRasMessage_gatekeeperConfirm,=0A=
-		eRasMessage_gatekeeperReject,=0A=
-		eRasMessage_registrationRequest,=0A=
-		eRasMessage_registrationConfirm,=0A=
-		eRasMessage_registrationReject,=0A=
-		eRasMessage_unregistrationRequest,=0A=
-		eRasMessage_unregistrationConfirm,=0A=
-		eRasMessage_unregistrationReject,=0A=
-		eRasMessage_admissionRequest,=0A=
-		eRasMessage_admissionConfirm,=0A=
-		eRasMessage_admissionReject,=0A=
-		eRasMessage_bandwidthRequest,=0A=
-		eRasMessage_bandwidthConfirm,=0A=
-		eRasMessage_bandwidthReject,=0A=
-		eRasMessage_disengageRequest,=0A=
-		eRasMessage_disengageConfirm,=0A=
-		eRasMessage_disengageReject,=0A=
-		eRasMessage_locationRequest,=0A=
-		eRasMessage_locationConfirm,=0A=
-		eRasMessage_locationReject,=0A=
-		eRasMessage_infoRequest,=0A=
-		eRasMessage_infoRequestResponse,=0A=
-		eRasMessage_nonStandardMessage,=0A=
-		eRasMessage_unknownMessageResponse,=0A=
-		eRasMessage_requestInProgress,=0A=
-		eRasMessage_resourcesAvailableIndicate,=0A=
-		eRasMessage_resourcesAvailableConfirm,=0A=
-		eRasMessage_infoRequestAck,=0A=
-		eRasMessage_infoRequestNak,=0A=
-		eRasMessage_serviceControlIndication,=0A=
-		eRasMessage_serviceControlResponse,=0A=
-	} choice;=0A=
-	union {=0A=
-		GatekeeperRequest gatekeeperRequest;=0A=
-		GatekeeperConfirm gatekeeperConfirm;=0A=
-		RegistrationRequest registrationRequest;=0A=
-		RegistrationConfirm registrationConfirm;=0A=
-		UnregistrationRequest unregistrationRequest;=0A=
-		AdmissionRequest admissionRequest;=0A=
-		AdmissionConfirm admissionConfirm;=0A=
-		LocationRequest locationRequest;=0A=
-		LocationConfirm locationConfirm;=0A=
-		InfoRequestResponse infoRequestResponse;=0A=
-	};=0A=
-} RasMessage;=0A=
diff -pruN linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_nat_helper_h323.c =
linux-2.6.17-rc1/net/ipv4/netfilter/ip_nat_helper_h323.c=0A=
--- linux-2.6.17-rc1.orig/net/ipv4/netfilter/ip_nat_helper_h323.c	=
2006-04-03 21:03:05.000000000 -0400=0A=
+++ linux-2.6.17-rc1/net/ipv4/netfilter/ip_nat_helper_h323.c	2006-04-03 =
21:19:12.000000000 -0400=0A=
@@ -25,6 +25,11 @@=0A=
  * 	2006-03-15 - version 0.4=0A=
  * 	  1. Added support for T.120 channels=0A=
  * 	  2. Added parameter gkrouted_only (suggested by Patrick McHardy)=0A=
+ *=0A=
+ * 	2006-03-25 - version 0.7=0A=
+ * 	  1. Made get_h245_addr static (suggested by Adrian Bunk)=0A=
+ * 	  2. Move some extern function prototypes to ip_conntrack_h323.h=0A=
+ * 	     (suggested by Adrian Bunk)=0A=
  */=0A=
 =0A=
 #include <linux/module.h>=0A=
@@ -41,65 +46,12 @@=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_h323.h>=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>=0A=
 =0A=
-#include "ip_conntrack_helper_h323_asn1.h"=0A=
-=0A=
 #if 0=0A=
 #define DEBUGP printk=0A=
 #else=0A=
 #define DEBUGP(format, args...)=0A=
 #endif=0A=
 =0A=
-extern int get_h245_addr(unsigned char *data, H245_TransportAddress * =
addr,=0A=
-			 u_int32_t * ip, u_int16_t * port);=0A=
-extern int get_h225_addr(unsigned char *data, TransportAddress * addr,=0A=
-			 u_int32_t * ip, u_int16_t * port);=0A=
-extern void ip_conntrack_h245_expect(struct ip_conntrack *new,=0A=
-				     struct ip_conntrack_expect *this);=0A=
-extern void ip_conntrack_q931_expect(struct ip_conntrack *new,=0A=
-				     struct ip_conntrack_expect *this);=0A=
-extern int (*set_h245_addr_hook) (struct sk_buff ** pskb,=0A=
-				  unsigned char **data, int dataoff,=0A=
-				  H245_TransportAddress * addr,=0A=
-				  u_int32_t ip, u_int16_t port);=0A=
-extern int (*set_h225_addr_hook) (struct sk_buff ** pskb,=0A=
-				  unsigned char **data, int dataoff,=0A=
-				  TransportAddress * addr,=0A=
-				  u_int32_t ip, u_int16_t port);=0A=
-extern int (*set_sig_addr_hook) (struct sk_buff ** pskb,=0A=
-				 struct ip_conntrack * ct,=0A=
-				 enum ip_conntrack_info ctinfo,=0A=
-				 unsigned char **data,=0A=
-				 TransportAddress * addr, int count);=0A=
-extern int (*set_ras_addr_hook) (struct sk_buff ** pskb,=0A=
-				 struct ip_conntrack * ct,=0A=
-				 enum ip_conntrack_info ctinfo,=0A=
-				 unsigned char **data,=0A=
-				 TransportAddress * addr, int count);=0A=
-extern int (*nat_rtp_rtcp_hook) (struct sk_buff ** pskb,=0A=
-				 struct ip_conntrack * ct,=0A=
-				 enum ip_conntrack_info ctinfo,=0A=
-				 unsigned char **data, int dataoff,=0A=
-				 H245_TransportAddress * addr,=0A=
-				 u_int16_t port, u_int16_t rtp_port,=0A=
-				 struct ip_conntrack_expect * rtp_exp,=0A=
-				 struct ip_conntrack_expect * rtcp_exp);=0A=
-extern int (*nat_t120_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
-			     enum ip_conntrack_info ctinfo,=0A=
-			     unsigned char **data, int dataoff,=0A=
-			     H245_TransportAddress * addr, u_int16_t port,=0A=
-			     struct ip_conntrack_expect * exp);=0A=
-extern int (*nat_h245_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
-			     enum ip_conntrack_info ctinfo,=0A=
-			     unsigned char **data, int dataoff,=0A=
-			     TransportAddress * addr, u_int16_t port,=0A=
-			     struct ip_conntrack_expect * exp);=0A=
-extern int (*nat_q931_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
-			     enum ip_conntrack_info ctinfo,=0A=
-			     unsigned char **data, TransportAddress * addr,=0A=
-			     int idx, u_int16_t port,=0A=
-			     struct ip_conntrack_expect * exp);=0A=
-=0A=
-=0A=
 =
/************************************************************************=
****/=0A=
 static int set_addr(struct sk_buff **pskb,=0A=
 		    unsigned char **data, int dataoff,=0A=
@@ -143,8 +95,8 @@ static int set_addr(struct sk_buff **psk=0A=
 				       " error\n");=0A=
 			return -1;=0A=
 		}=0A=
-		/* ip_nat_mangle_udp_packet uses skb_make_writable() to copy=0A=
-		 * or pull everything in a linear buffer, so we can safely=0A=
+		/* ip_nat_mangle_udp_packet uses skb_make_writable() to copy =0A=
+		 * or pull everything in a linear buffer, so we can safely =0A=
 		 * use the skb pointers now */=0A=
 		*data =3D (*pskb)->data + (*pskb)->nh.iph->ihl * 4 +=0A=
 		    sizeof(struct udphdr);=0A=

------=_NextPart_000_000E_01C6577A.1388B1F0--
