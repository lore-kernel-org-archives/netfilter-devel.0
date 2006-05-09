From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [PATCH 2/2] [NETFILTER] Follow expectation API changes
Date: Tue, 09 May 2006 14:20:19 +0200
Message-ID: <11471772194133-git-send-email-heitzenberger@astaro.com>
References: <11471772191487-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <11471772191487-git-send-email-heitzenberger@astaro.com>
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

Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>

---

 .../net/ipv4/netfilter/ip_conntrack_mms.c          |  125 +++++++++++------------
 .../linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c   |    4 -
 2 files changed, 63 insertions(+), 66 deletions(-)

fec1a5aba8056bdf2eb40df16d2a15e8fed4db07
diff --git a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
index cb0cf23..7b352d3 100644
--- a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
+++ b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
@@ -224,72 +224,71 @@ #endif
 	 * it as a member of struct ip_ct_mms_expect and checking for it in
 	 * ip_nat_mms...
 	 */
-	if ((MMS_SRV_MSG_OFFSET < datalen) &&
-	    ((*(u32 *)(data+MMS_SRV_MSG_OFFSET)) == MMS_SRV_MSG_ID)) {
-		DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n",
-		       (u8)*(data+36), (u8)*(data+37),
-		       (u8)*(data+38), (u8)*(data+39),
-		       datalen);
-		if (parse_mms(data, datalen, &mms_ip, &mms_proto, &mms_port,
-		             &mms_string_b, &mms_string_e, &mms_padding_e))
-			if (net_ratelimit())
-				/* FIXME: more verbose debugging ? */
-				printk(KERN_WARNING
-				       "ip_conntrack_mms: Unable to parse "
-				       "data payload\n");
-
-		sprintf(mms_proto_string, "(%u)", mms_proto);
-		DEBUGP("ip_conntrack_mms: adding %s expectation "
-		       "%u.%u.%u.%u -> %u.%u.%u.%u:%u\n",
-		       mms_proto == IPPROTO_TCP ? "TCP"
-		       : mms_proto == IPPROTO_UDP ? "UDP":mms_proto_string,
-		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
-		       NIPQUAD(mms_ip),
-		       mms_port);
-
-		/* it's possible that the client will just ask the server to
-		 * tunnel the stream over the same TCP session (from port
-		 * 1755): there's shouldn't be a need to add an expectation in
-		 * that case, but it makes NAT packet mangling so much easier
-		 * */
-
-		DEBUGP("ip_conntrack_mms: tcph->seq = %u\n", tcph->seq);
-
-		exp = ip_conntrack_expect_alloc();
-		if (!exp) {
-			ret = NF_DROP;
-			goto out;
-		}
+	if ((MMS_SRV_MSG_OFFSET >= datalen) ||
+		((*(u32 *)(data+MMS_SRV_MSG_OFFSET)) != MMS_SRV_MSG_ID))
+		goto out;
 
-		exp_mms_info->offset  = (mms_string_b - data);
-		exp_mms_info->len     = (mms_string_e  - mms_string_b);
-		exp_mms_info->padding = (mms_padding_e - mms_string_e);
-		exp_mms_info->port    = mms_port;
-
-		DEBUGP("ip_conntrack_mms: wrote info seq=%u (ofs=%u), "
-		       "len=%d, padding=%u\n", exp->seq, (mms_string_e - data),
-		       exp_mms_info->len, exp_mms_info->padding);
-
-		exp->tuple = ((struct ip_conntrack_tuple)
-		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
-		              { mms_ip,
-		                { .tcp = { (__u16) ntohs(mms_port) } },
-		                mms_proto } }
-		             );
-		exp->mask  = ((struct ip_conntrack_tuple)
-		             { { 0xFFFFFFFF, { 0 } },
-		               { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
-		exp->expectfn = NULL;
-		exp->master = ct;
-
-		if (ip_nat_mms_hook)
-			ret = ip_nat_mms_hook(pskb, ctinfo, exp_mms_info, exp);
-		else if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
-			ret = NF_DROP;
-		}
+	DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n",
+		   (u8)*(data+36), (u8)*(data+37), (u8)*(data+38), (u8)*(data+39),
+		   datalen);
+	if (parse_mms(data, datalen, &mms_ip, &mms_proto, &mms_port,
+				  &mms_string_b, &mms_string_e, &mms_padding_e))
+		if (net_ratelimit())
+			/* FIXME: more verbose debugging ? */
+			printk(KERN_WARNING
+				   "ip_conntrack_mms: Unable to parse "
+				   "data payload\n");
+
+	sprintf(mms_proto_string, "(%u)", mms_proto);
+	DEBUGP("ip_conntrack_mms: adding %s expectation "
+		   "%u.%u.%u.%u -> %u.%u.%u.%u:%u\n",
+		   mms_proto == IPPROTO_TCP ? "TCP"
+		   : mms_proto == IPPROTO_UDP ? "UDP":mms_proto_string,
+		   NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+		   NIPQUAD(mms_ip),
+		   mms_port);
+
+	/* it's possible that the client will just ask the server to
+	 * tunnel the stream over the same TCP session (from port
+	 * 1755): there's shouldn't be a need to add an expectation in
+	 * that case, but it makes NAT packet mangling so much easier
+	 * */
+
+	DEBUGP("ip_conntrack_mms: tcph->seq = %u\n", tcph->seq);
+
+	if ((exp = ip_conntrack_expect_alloc(ct)) == NULL) {
+		ret = NF_DROP;
 		goto out;
 	}
+
+	exp_mms_info->offset  = (mms_string_b - data);
+	exp_mms_info->len     = (mms_string_e  - mms_string_b);
+	exp_mms_info->padding = (mms_padding_e - mms_string_e);
+	exp_mms_info->port    = mms_port;
+
+	DEBUGP("ip_conntrack_mms: wrote info seq=%u (ofs=%u), "
+		   "len=%d, padding=%u\n", exp->seq, (mms_string_e - data),
+		   exp_mms_info->len, exp_mms_info->padding);
+
+	exp->tuple = ((struct ip_conntrack_tuple)
+		{ { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
+		  { mms_ip,
+			{ .tcp = { (__u16) ntohs(mms_port) } },
+			mms_proto } }
+		);
+	exp->mask  = ((struct ip_conntrack_tuple)
+		{ { 0xFFFFFFFF, { 0 } },
+		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+	exp->expectfn = NULL;
+	exp->master = ct;
+
+	if (ip_nat_mms_hook)
+		ret = ip_nat_mms_hook(pskb, ctinfo, exp_mms_info, exp);
+	else if (ip_conntrack_expect_related(exp) != 0)
+		ret = NF_DROP;
+
+	ip_conntrack_expect_put(exp);
+
 out:
 	spin_unlock_bh(&mms_buffer_lock);
 	return ret;
diff --git a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
index 0492222..54365de 100644
--- a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
+++ b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
@@ -114,10 +114,8 @@ static unsigned int mms_data_fixup(struc
 		}
 	}
 
-	if (port == 0) {
-		ip_conntrack_expect_free(expect);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	sprintf(buffer, "\\\\%u.%u.%u.%u\\%s\\%u",
 	        NIPQUAD(newip),
