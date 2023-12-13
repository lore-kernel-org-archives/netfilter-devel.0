Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398CAA5
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 03:29:52 -0800 (PST)
Date: Wed, 13 Dec 2023 12:29:50 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] log NAT events using IPFIX
Message-ID: <20231213112949.GB18912@polanet.pl>
References: <20231210201705.GA16025@polanet.pl>
 <ZXhkbfE9ju7uiFNN@calendula>
 <20231212184413.GA2168@polanet.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20231212184413.GA2168@polanet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Export conntract event type via IPFIX.

While conntrack doesn't imply using NAT, the natEvent
is handled by nfdump, so prefer it over firewallEvent.



BTW - NF_NETLINK_CONNTRACK_UPDATE events are somehow ignored, output is
empty with:

event_mask=2

while conntrack -E -e update dumps a lot of them.

-- 
Tomasz Pala <gotar@pld-linux.org>

--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ulogd2-event_type.patch"

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index a34ee92..b7a61f4 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -222,6 +222,8 @@ enum {
 	IPFIX_postNATDestinationIPv4Address	= 226,
 	IPFIX_postNAPTSourceTransportPort	= 227,
 	IPFIX_postNAPTDestinationTransportPort	= 228,
+	IPFIX_natEvent			= 230,
+	IPFIX_firewallEvent		= 233,
 };
 
 /* Information elements of the netfilter vendor id */
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 93c8844..614ae70 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -364,7 +362,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "ct.event",
-	},
+	},	/* remapped to uint8 IPFIX_firewallEvent/IPFIX_natEvent */
 
 	{
 		.type 	= ULOGD_RET_UINT32,
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index 0ad34ec..785d35d 100644
--- a/output/ipfix/ipfix.c
+++ b/output/ipfix/ipfix.c
@@ -26,7 +26,7 @@ struct ipfix_templ {
 
 /* Template fields modeled after vy_ipfix_data */
 static const struct ipfix_templ template = {
-	.num_templ_elements = 14,
+	.num_templ_elements = 15,
 	.templ_elements = {
 		{
 			.id = IPFIX_sourceIPv4Address,
@@ -83,7 +83,11 @@ static const struct ipfix_templ template = {
 		{
 			.id = IPFIX_applicationId,
 			.len = sizeof(uint32_t)
-		},
+		},	/* CT mark */
+		{
+			.id = IPFIX_natEvent,
+			.len = sizeof(uint8_t)
+		},	/* note: this could be IPFIX_firewallEvent, but it'is not handled by nfdump */
 	}
 };
 
diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
index f671ea6..853a256 100644
--- a/output/ipfix/ipfix.h
+++ b/output/ipfix/ipfix.h
@@ -70,7 +70,8 @@ struct vy_ipfix_data {
 	uint16_t tsport;
 	uint16_t tdport;
 	uint8_t l4_proto;
-	uint32_t aid;				/* Application ID */
+	uint32_t aid;				/* Application ID; used for CT mark */
+	uint8_t event;
 } __attribute__((packed));
 
 #define VY_IPFIX_SID		256
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 167ee9a..712ec4f 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -24,6 +24,8 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
 
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
 #include "ipfix.h"
 
 #define DEFAULT_MTU		512 /* RFC 5101, 10.3.3 */
@@ -112,7 +114,8 @@ enum {
 	InL4TSPort,
 	InL4TDPort,
 	InIpProto,
-	InCtMark
+	InCtMark,
+	InCtEvent,
 };
 
 static struct ulogd_key ipfix_in_keys[] = {
@@ -187,7 +190,11 @@ static struct ulogd_key ipfix_in_keys[] = {
 		[InCtMark] = {
 			.type = ULOGD_RET_UINT32,
 			.name = "ct.mark"
-		}
+		},
+		[InCtEvent] = {
+			.type = ULOGD_RET_UINT32
+			.name = "ct.event"
+		},
 };
 
 /* do some polishing and enqueue it */
@@ -441,6 +526,7 @@ static int ipfix_interp(struct ulogd_pluginstance *pi)
 {
 	char saddr[16],tsaddr[16], daddr[16],tdaddr[16], *send_template;
 	uint64_t start, end;
+	uint32_t event_type;
 	struct vy_ipfix_data *data;
 	int oid, mtu, ret;
 
@@ -496,11 +589,24 @@ again:
 		data->tdport = htons(ikey_get_u16(&pi->input.keys[InL4TDPort]));
 	}
 
+	data->l4_proto = ikey_get_u8(&pi->input.keys[InIpProto]);
+
 	data->aid = 0;
 	if (GET_FLAGS(pi->input.keys, InCtMark) & ULOGD_RETF_VALID)
 		data->aid = htonl(ikey_get_u32(&pi->input.keys[InCtMark]));
 
-	data->l4_proto = ikey_get_u8(&pi->input.keys[InIpProto]);
+	data->event = 255;	/* Unassigned */
+	event_type = ikey_get_u32(&pi->input.keys[InCtEvent]);
+	switch (event_type) {
+										/* IPFIX_natEvent [230] */
+		case NF_NETLINK_CONNTRACK_NEW:		data->event = 4; break;	/* NAT44 session create */
+		case NF_NETLINK_CONNTRACK_UPDATE:	data->event = 4; break;	/* NAT44 session create */
+		case NF_NETLINK_CONNTRACK_DESTROY:	data->event = 5; break;	/* NAT44 session delete */
+										// IPFIX_firewallEvent [233]
+	//	case NF_NETLINK_CONNTRACK_NEW:		data->event = 1; break;	/* Flow Created */
+	//	case NF_NETLINK_CONNTRACK_UPDATE:	data->event = 5; break;	/* Flow Update */
+	//	case NF_NETLINK_CONNTRACK_DESTROY:	data->event = 2; break;	/* Flow Deleted */
+	}
 
 	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u:%u, %u:%u), saddr = %s/%s, daddr = %s/%s, sport = %u/%u, dport = %u/%u)\n",
 		  ntohl(data->packets), ntohl(data->bytes), ntohl(data->start_high),ntohl(data->start_low), ntohl(data->end_high),ntohl(data->end_low),

--yEPQxsgoJgBvi8ip--
