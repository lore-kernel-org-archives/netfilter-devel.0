Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57EEAF
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 03:49:37 -0800 (PST)
Date: Wed, 13 Dec 2023 12:49:35 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] log NAT events using IPFIX
Message-ID: <20231213114934.GC18912@polanet.pl>
References: <20231210201705.GA16025@polanet.pl>
 <ZXhkbfE9ju7uiFNN@calendula>
 <20231212184413.GA2168@polanet.pl>
 <20231212200859.GA18912@polanet.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20231212200859.GA18912@polanet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Change IPFIX output plugin event timestamps from:

IPFIX_flowStartSeconds	150
IPFIX_flowEndSeconds	151

to:

IPFIX_flowStartMilliSeconds	152
IPFIX_flowEndMilliSeconds	153

While there are other entities with larger precision, namely *Micro* and
*Nano*seconds, this choice has the advantage of being handled by nfdump.

> diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
> index 93c8844..f4b737b 100644
> --- a/input/flow/ulogd_inpflow_NFCT.c
> +++ b/input/flow/ulogd_inpflow_NFCT.c
>  		.type 	= ULOGD_RET_UINT32,
>  		.flags 	= ULOGD_RETF_NONE,
>  		.name	= "flow.start.usec",
> -		.ipfix	= {
> -			.vendor		= IPFIX_VENDOR_IETF,
> -			.field_id	= IPFIX_flowStartMicroSeconds,
> -		},
> +		.ipfix	= { },
> +		/* note that this is only fractional part of the second of flow.start,
> +		   while IPFIX_flowStartMicroSeconds expects full timestamp */
>  	},
>  	{
>  		.type	= ULOGD_RET_UINT32,

Oops, this chunk is missing it's line pointers, resending...

-- 
Tomasz Pala <gotar@pld-linux.org>

--qjNfmADvan18RZcF
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ulogd2-ts_resolution2.patch"

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 93c8844..f4b737b 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -379,10 +377,9 @@ static struct ulogd_key nfct_okeys[] = {
 		.type 	= ULOGD_RET_UINT32,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "flow.start.usec",
-		.ipfix	= {
-			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowStartMicroSeconds,
-		},
+		.ipfix	= { },
+		/* note that this is only fractional part of the second of flow.start,
+		   while IPFIX_flowStartMicroSeconds expects full timestamp */
 	},
 	{
 		.type	= ULOGD_RET_UINT32,
@@ -397,10 +394,9 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "flow.end.usec",
-		.ipfix	= {
-			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowEndSeconds,
-		},
+		.ipfix	= { },
+		/* note that this is only fractional part of the second of flow.end,
+		   while IPFIX_flowEndMicroSeconds expects full timestamp */
 	},
 	{
 		.type	= ULOGD_RET_UINT8,
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index 0ad34ec..c2a6c6b 100644
--- a/output/ipfix/ipfix.c
+++ b/output/ipfix/ipfix.c
@@ -53,12 +53,12 @@ static const struct ipfix_templ template = {
 			.len = sizeof(uint32_t)
 		},
 		{
-			.id = IPFIX_flowStartSeconds,
-			.len = sizeof(uint32_t)
+			.id = IPFIX_flowStartMilliSeconds,
+			.len = sizeof(uint64_t)
 		},
 		{
-			.id = IPFIX_flowEndSeconds,
-			.len = sizeof(uint32_t)
+			.id = IPFIX_flowEndMilliSeconds,
+			.len = sizeof(uint64_t)
 		},
 		{
 			.id = IPFIX_sourceTransportPort,
diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
index f671ea6..2de9572 100644
--- a/output/ipfix/ipfix.h
+++ b/output/ipfix/ipfix.h
@@ -63,8 +63,10 @@ struct vy_ipfix_data {
 	struct in_addr tdaddr;
 	uint32_t packets;
 	uint32_t bytes;
-	uint32_t start;				/* Unix time */
-	uint32_t end;				/* Unix time */
+	uint32_t start_high;			/* Unix time * 1000 */
+	uint32_t start_low;
+	uint32_t end_high;
+	uint32_t end_low;
 	uint16_t sport;
 	uint16_t dport;
 	uint16_t tsport;
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 167ee9a..8f1dde3 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -440,6 +440,7 @@ static int ipfix_interp(struct ulogd_pluginstance *pi)
 {
 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
 	char saddr[16],tsaddr[16], daddr[16],tdaddr[16], *send_template;
+	uint64_t start, end;
 	struct vy_ipfix_data *data;
 	int oid, mtu, ret;
 
@@ -486,8 +487,12 @@ again:
 	data->bytes = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktLen])
 						+ ikey_get_u64(&pi->input.keys[InRawOutPktLen])));
 
-	data->start = htonl(ikey_get_u32(&pi->input.keys[InFlowStartSec]));
-	data->end = htonl(ikey_get_u32(&pi->input.keys[InFlowEndSec]));
+	start = (uint64_t)ikey_get_u32(&pi->input.keys[InFlowStartSec]) *1000 + ikey_get_u32(&pi->input.keys[InFlowStartUsec])/1000;
+	end   = (uint64_t)ikey_get_u32(&pi->input.keys[InFlowEndSec])   *1000 + ikey_get_u32(&pi->input.keys[InFlowEndUsec])/1000;
+	data->start_low = htonl((uint32_t)(start & 0xFFFFFFFFUL));
+	data->start_high = htonl(start >> 32);
+	data->end_low = htonl((uint32_t)(end & 0xFFFFFFFFUL));
+	data->end_high = htonl(end >> 32);
 
 	if (GET_FLAGS(pi->input.keys, InL4SPort) & ULOGD_RETF_VALID) {
 		data->sport = htons(ikey_get_u16(&pi->input.keys[InL4SPort]));
@@ -502,11 +508,13 @@ again:
 
 	data->l4_proto = ikey_get_u8(&pi->input.keys[InIpProto]);
 
-	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u, %u), saddr = %s, daddr = %s, sport = %u, dport = %u)\n",
-		  ntohl(data->packets), ntohl(data->bytes), ntohl(data->start), ntohl(data->end),
+	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u:%u, %u:%u), saddr = %s/%s, daddr = %s/%s, sport = %u/%u, dport = %u/%u)\n",
+		  ntohl(data->packets), ntohl(data->bytes), ntohl(data->start_high),ntohl(data->start_low), ntohl(data->end_high),ntohl(data->end_low),
 		  inet_ntop(AF_INET, &data->saddr.s_addr, saddr, sizeof(saddr)),
+		  inet_ntop(AF_INET, &data->tsaddr.s_addr, tsaddr, sizeof(tsaddr)),
 		  inet_ntop(AF_INET, &data->daddr.s_addr, daddr, sizeof(daddr)),
-		  ntohs(data->sport), ntohs(data->dport));
+		  inet_ntop(AF_INET, &data->tdaddr.s_addr, tdaddr, sizeof(tdaddr)),
+		  ntohs(data->sport),ntohs(data->tsport), ntohs(data->dport),ntohs(data->tdport));
 
 	if ((ret = send_msgs(pi)) < 0)
 		return ret;

--qjNfmADvan18RZcF--
