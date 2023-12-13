Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1B0E4
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 04:27:10 -0800 (PST)
Date: Wed, 13 Dec 2023 13:27:08 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] log NAT events using IPFIX
Message-ID: <20231213122708.GD18912@polanet.pl>
References: <20231210201705.GA16025@polanet.pl>
 <ZXhkbfE9ju7uiFNN@calendula>
 <20231212184413.GA2168@polanet.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <20231212184413.GA2168@polanet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

The flow.end field for NEW connections has a value of 0.
However it seems that the flowEnd* IPFIX are commonly interpreted as
"last seen" timestamps.

From https://www.iana.org/assignments/ipfix/ipfix.xhtml:
153	flowEndMilliseconds	The absolute timestamp of the last packet of this Flow.

It's not clear whether "last packet" should be read as "final/closing packet",
but with this field carrying a value of 0 the nfdump doesn't handle the
flowStartMilliseconds value as well.

Moreover, NF_NETLINK_CONNTRACK_UPDATE events also set flow.end to
timestamp of last packet _seen_, with the connection being still
established (UPDATEd connection is on-going per-se, until DESTROY).

The actual state of the flow, i.e. it's termination, should be read
directly from event type (firewallEvent/natEvent fields), not derived
from flowEnd* having non-zero value.

Therefore, when flow.end is not set, make it equal to flow.start, as
initiating packet and the last one are the same.


As this change is only 1 line, I've left the remaining notes and comments here.

-- 
Tomasz Pala <gotar@pld-linux.org>

--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ulogd2-last_seen.patch"

diff --color '--palette=ad=1;38;5;155:de=1;38;5;205:hd=1;36:ln=35;1;3' -U5 -ru ddd/ulogd2/input/flow/ulogd_inpflow_NFCT.c ./input/flow/ulogd_inpflow_NFCT.c
--- ddd/input/flow/ulogd_inpflow_NFCT.c	2023-12-13 12:14:03.137497479 +0100
+++ aaa/input/flow/ulogd_inpflow_NFCT.c	2023-12-13 10:12:46.267523061 +0100
@@ -244,21 +244,20 @@
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "orig.raw.pktlen",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
-			/* FIXME: this could also be octetDeltaCount */
 		},
 	},
 	{
 		.type	= ULOGD_RET_UINT64,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "orig.raw.pktcount",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
-			/* FIXME: this could also be packetDeltaCount */
+			/* FIXME: this could also be egressUnicastPacketTotalCount */
 		},
 	},
 	{
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
@@ -309,21 +308,20 @@
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.raw.pktlen",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
-			/* FIXME: this could also be octetDeltaCount */
 		},
 	},
 	{
 		.type	= ULOGD_RET_UINT64,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.raw.pktcount",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
-			/* FIXME: this could also be packetDeltaCount */
+			/* FIXME: this could also be ingressUnicastPacketTotalCount */
 		},
 	},
 	{
 		.type	= ULOGD_RET_UINT8,
 		.flags	= ULOGD_RETF_NONE,
diff --color '--palette=ad=1;38;5;155:de=1;38;5;205:hd=1;36:ln=35;1;3' -U5 -ru ddd/ulogd2/output/ipfix/ulogd_output_IPFIX.c ./output/ipfix/ulogd_output_IPFIX.c
--- ddd/output/ipfix/ulogd_output_IPFIX.c	2023-12-13 12:14:03.137497479 +0100
+++ aaa/output/ipfix/ulogd_output_IPFIX.c	2023-12-13 11:59:52.652179788 +0100
@@ -488,19 +566,21 @@
 	data->saddr.s_addr = ikey_get_u32(&pi->input.keys[InIpSaddr]);
 	data->daddr.s_addr = ikey_get_u32(&pi->input.keys[InIpDaddr]);
 	data->tsaddr.s_addr = ikey_get_u32(&pi->input.keys[InTIpSaddr]);
 	data->tdaddr.s_addr = ikey_get_u32(&pi->input.keys[InTIpDaddr]);
 
+	/* TODO: send full uint64_t */
 	data->packets = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktCount])
 						+ ikey_get_u64(&pi->input.keys[InRawOutPktCount])));
 	data->bytes = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktLen])
 						+ ikey_get_u64(&pi->input.keys[InRawOutPktLen])));
 
 	start = (uint64_t)ikey_get_u32(&pi->input.keys[InFlowStartSec]) *1000 + ikey_get_u32(&pi->input.keys[InFlowStartUsec])/1000;
 	end   = (uint64_t)ikey_get_u32(&pi->input.keys[InFlowEndSec])   *1000 + ikey_get_u32(&pi->input.keys[InFlowEndUsec])/1000;
 	data->start_low = htonl((uint32_t)(start & 0xFFFFFFFFUL));
 	data->start_high = htonl(start >> 32);
+	if (!end) end = start;	/* end timestamp seems to be commonly read as "last seen" timestamp */
 	data->end_low = htonl((uint32_t)(end & 0xFFFFFFFFUL));
 	data->end_high = htonl(end >> 32);
 
 	if (GET_FLAGS(pi->input.keys, InL4SPort) & ULOGD_RETF_VALID) {
 		data->sport = htons(ikey_get_u16(&pi->input.keys[InL4SPort]));
diff --color '--palette=ad=1;38;5;155:de=1;38;5;205:hd=1;36:ln=35;1;3' -U5 -ru ddd/ulogd2/README ./README
--- ddd/README	2023-12-13 12:10:38.503561734 +0100
+++ aaa/README	2023-12-10 19:58:55.735776260 +0100
@@ -1,9 +1,9 @@
 Userspace logging daemon for netfilter/iptables
 
-Project Homepage: http://www.gnumonks.org/projects/ulogd
-Mailinglist: http://lists.gnumonks.org/mailman/listinfo/ulogd/
+Project Homepage: https://www.netfilter.org/projects/ulogd/
+Mailinglist: https://marc.info/?l=netfilter
 
 This is just a short README, pleaes see the more extensive documentation
 in the doc/ subdirectory.
 
 ===> IDEA

--Km1U/tdNT/EmXiR1--
