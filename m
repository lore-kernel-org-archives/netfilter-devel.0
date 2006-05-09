From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [PATCH 1/2] [NETFILTER] Remove trailing whitespace from MMS
	conntrack/NAT
Date: Tue, 09 May 2006 14:20:18 +0200
Message-ID: <11471772191585-git-send-email-heitzenberger@astaro.com>
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

 .../net/ipv4/netfilter/ip_conntrack_mms.c          |   48 ++++++++++++-----------
 .../linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c   |   44 +++++++++++----------
 2 files changed, 46 insertions(+), 46 deletions(-)

6c838bb8bb3673e65a9ae3da9288d98fafe0d58f
diff --git a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
index 71b4333..cb0cf23 100644
--- a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
+++ b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
@@ -54,7 +54,7 @@ unsigned int (*ip_nat_mms_hook)(struct s
 				struct ip_conntrack_expect *exp);
 EXPORT_SYMBOL(ip_nat_mms_hook);
 
-#if 0 
+#if 0
 #define DEBUGP printk
 #else
 #define DEBUGP(format, args...)
@@ -76,7 +76,7 @@ static void unicode_to_ascii (char *stri
 	string[unicode_size] = 0x00;
 }
 
-__inline static int atoi(char *s) 
+__inline static int atoi(char *s)
 {
 	int i=0;
 	while (isdigit(*s)) {
@@ -99,7 +99,7 @@ __inline static u_int32_t asciiiptoi(cha
 	return ntohl(i);
 }
 
-int parse_mms(const char *data, 
+int parse_mms(const char *data,
 	      const unsigned int datalen,
 	      u_int32_t *mms_ip,
 	      u_int16_t *mms_proto,
@@ -111,21 +111,21 @@ int parse_mms(const char *data, 
 	int unicode_size, i;
 	char tempstring[28];       /* "\\255.255.255.255\UDP\65535" */
 	char getlengthstring[28];
-	
-	for(unicode_size=0; 
+
+	for(unicode_size=0;
 	    (char) *(data+(MMS_SRV_UNICODE_STRING_OFFSET+unicode_size*2)) != (char)0;
 	    unicode_size++)
-		if ((unicode_size == 28) || (MMS_SRV_UNICODE_STRING_OFFSET+unicode_size*2 >= datalen)) 
+		if ((unicode_size == 28) || (MMS_SRV_UNICODE_STRING_OFFSET+unicode_size*2 >= datalen))
 			return -1; /* out of bounds - incomplete packet */
-	
+
 	unicode_to_ascii(tempstring, (short *)(data+MMS_SRV_UNICODE_STRING_OFFSET), unicode_size);
 	DEBUGP("ip_conntrack_mms: offset 60: %s\n", (const char *)(tempstring));
-	
+
 	/* IP address ? */
 	*mms_ip = asciiiptoi(tempstring+2);
-	
+
 	i=sprintf(getlengthstring, "%u.%u.%u.%u", HIPQUAD(*mms_ip));
-		
+
 	/* protocol ? */
 	if(strncmp(tempstring+3+i, "TCP", 3)==0)
 		*mms_proto = IPPROTO_TCP;
@@ -135,9 +135,9 @@ int parse_mms(const char *data, 
 	/* port ? */
 	*mms_port = atoi(tempstring+7+i);
 
-	/* we store a pointer to the beginning of the "\\a.b.c.d\proto\port" 
-	   unicode string, one to the end of the string, and one to the end 
-	   of the packet, since we must keep track of the number of bytes 
+	/* we store a pointer to the beginning of the "\\a.b.c.d\proto\port"
+	   unicode string, one to the end of the string, and one to the end
+	   of the packet, since we must keep track of the number of bytes
 	   between end of the unicode string and the end of packet (padding) */
 	*mms_string_b  = (char *)(data + MMS_SRV_UNICODE_STRING_OFFSET);
 	*mms_string_e  = (char *)(data + MMS_SRV_UNICODE_STRING_OFFSET + unicode_size * 2);
@@ -163,13 +163,13 @@ static int help(struct sk_buff **pskb,
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_conntrack_expect *exp;
 	struct ip_ct_mms_expect _emmi, *exp_mms_info = &_emmi;
-	
+
 	u_int32_t mms_ip;
 	u_int16_t mms_proto;
 	char mms_proto_string[8];
 	u_int16_t mms_port;
 	char *mms_string_b, *mms_string_e, *mms_padding_e;
-	     
+
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
 	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
@@ -207,7 +207,7 @@ #if 0
 		return NF_ACCEPT;
 	}
 #endif
-	
+
 	/* Only look at packets with 0x00030002/196610 on bytes 36->39 of TCP
 	 * payload */
 
@@ -224,10 +224,10 @@ #endif
 	 * it as a member of struct ip_ct_mms_expect and checking for it in
 	 * ip_nat_mms...
 	 */
-	if ((MMS_SRV_MSG_OFFSET < datalen) && 
+	if ((MMS_SRV_MSG_OFFSET < datalen) &&
 	    ((*(u32 *)(data+MMS_SRV_MSG_OFFSET)) == MMS_SRV_MSG_ID)) {
-		DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n", 
-		       (u8)*(data+36), (u8)*(data+37), 
+		DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n",
+		       (u8)*(data+36), (u8)*(data+37),
 		       (u8)*(data+38), (u8)*(data+39),
 		       datalen);
 		if (parse_mms(data, datalen, &mms_ip, &mms_proto, &mms_port,
@@ -246,7 +246,7 @@ #endif
 		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
 		       NIPQUAD(mms_ip),
 		       mms_port);
-		
+
 		/* it's possible that the client will just ask the server to
 		 * tunnel the stream over the same TCP session (from port
 		 * 1755): there's shouldn't be a need to add an expectation in
@@ -260,16 +260,16 @@ #endif
 			ret = NF_DROP;
 			goto out;
 		}
-		
+
 		exp_mms_info->offset  = (mms_string_b - data);
 		exp_mms_info->len     = (mms_string_e  - mms_string_b);
 		exp_mms_info->padding = (mms_padding_e - mms_string_e);
 		exp_mms_info->port    = mms_port;
-		
+
 		DEBUGP("ip_conntrack_mms: wrote info seq=%u (ofs=%u), "
 		       "len=%d, padding=%u\n", exp->seq, (mms_string_e - data),
 		       exp_mms_info->len, exp_mms_info->padding);
-		
+
 		exp->tuple = ((struct ip_conntrack_tuple)
 		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
 		              { mms_ip,
@@ -335,7 +335,7 @@ static int __init init(void)
 			sprintf(tmpname, "mms-%d", ports[i]);
 		mms[i].name = tmpname;
 
-		DEBUGP("ip_conntrack_mms: registering helper for port %d\n", 
+		DEBUGP("ip_conntrack_mms: registering helper for port %d\n",
 				ports[i]);
 		ret = ip_conntrack_helper_register(&mms[i]);
 
diff --git a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
index fff25c5..0492222 100644
--- a/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
+++ b/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
@@ -28,8 +28,8 @@
 
  */
 
-/* FIXME: issue with UDP & fragmentation with this URL: 
-   http://www.cnn.com/video/world/2002/01/21/jb.shoe.bomb.cafe.cnn.low.asx 
+/* FIXME: issue with UDP & fragmentation with this URL:
+   http://www.cnn.com/video/world/2002/01/21/jb.shoe.bomb.cafe.cnn.low.asx
    may be related to out-of-order first packets:
    basically the expectation is set up correctly, then the server sends
    a first UDP packet which is fragmented plus arrives out-of-order.
@@ -47,7 +47,7 @@ #include <linux/netfilter_ipv4/ip_nat_ru
 #include <linux/netfilter_ipv4/ip_conntrack_mms.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 
-#if 0 
+#if 0
 #define DEBUGP printk
 #define DUMP_BYTES(address, counter)                                \
 ({                                                                  \
@@ -85,7 +85,7 @@ static unsigned int mms_data_fixup(struc
 
 	int zero_padding;
 
-	char buffer[28];         /* "\\255.255.255.255\UDP\65635" * 2 
+	char buffer[28];         /* "\\255.255.255.255\UDP\65635" * 2
 				    (for unicode) */
 	char unicode_buffer[75]; /* 27*2 (unicode) + 20 + 1 */
 	char proto_string[6];
@@ -93,13 +93,13 @@ static unsigned int mms_data_fixup(struc
 	/* what was the protocol again ? */
 	mms_proto = expect->tuple.dst.protonum;
 	sprintf(proto_string, "%u", mms_proto);
-	
+
 	DEBUGP("ip_nat_mms: mms_data_fixup: info (seq %u + %u) "
 	       "in %u, proto %s\n",
 	       expect->seq, ct_mms_info->len, ntohl(tcph->seq),
 	       mms_proto == IPPROTO_UDP ? "UDP"
 	       : mms_proto == IPPROTO_TCP ? "TCP":proto_string);
-	
+
 	newip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 	expect->saved_proto.tcp.port = expect->tuple.dst.u.tcp.port;
 	expect->expectfn = ip_nat_follow_master;
@@ -109,11 +109,11 @@ static unsigned int mms_data_fixup(struc
 		expect->tuple.dst.u.tcp.port = htons(port);
 		if (ip_conntrack_expect_related(expect) == 0) {
 			DEBUGP("ip_nat_mms: mms_data_fixup: using port %d\n",
-				port); 
+				port);
 			break;
 		}
 	}
-	
+
 	if (port == 0) {
 		ip_conntrack_expect_free(expect);
 		return NF_DROP;
@@ -125,21 +125,21 @@ static unsigned int mms_data_fixup(struc
 		: expect->tuple.dst.protonum == IPPROTO_TCP ? "TCP":proto_string,
 		port);
 	DEBUGP("ip_nat_mms: new unicode string=%s\n", buffer);
-	
+
 	memset(unicode_buffer, 0, sizeof(char)*75);
 
 	for (i=0; i<strlen(buffer); ++i)
 		*(unicode_buffer+i*2)=*(buffer+i);
-	
-	DEBUGP("ip_nat_mms: mms_data_fixup: padding: %u len: %u\n", 
+
+	DEBUGP("ip_nat_mms: mms_data_fixup: padding: %u len: %u\n",
 		ct_mms_info->padding, ct_mms_info->len);
-	DEBUGP("ip_nat_mms: mms_data_fixup: offset: %u\n", 
+	DEBUGP("ip_nat_mms: mms_data_fixup: offset: %u\n",
 		MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_info->len);
 	DUMP_BYTES(data+MMS_SRV_UNICODE_STRING_OFFSET, 60);
-	
+
 	/* add end of packet to it */
 	for (j=0; j<ct_mms_info->padding; ++j) {
-		DEBUGP("ip_nat_mms: mms_data_fixup: i=%u j=%u byte=%u\n", 
+		DEBUGP("ip_nat_mms: mms_data_fixup: i=%u j=%u byte=%u\n",
 		       i, j, (u8)*(data+MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_info->len+j));
 		*(unicode_buffer+i*2+j) = *(data+MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_info->len+j);
 	}
@@ -148,32 +148,32 @@ static unsigned int mms_data_fixup(struc
 	zero_padding = (8-(strlen(buffer)*2 + ct_mms_info->padding + 4)%8)%8;
 	for (k=0; k<zero_padding; ++k)
 		*(unicode_buffer+i*2+j+k)= (char)0;
-	
+
 	DEBUGP("ip_nat_mms: mms_data_fixup: zero_padding = %u\n", zero_padding);
 	DEBUGP("ip_nat_mms: original=> chunkLenLV=%u chunkLenLM=%u "
 	       "messageLength=%u\n", *mms_chunkLenLV, *mms_chunkLenLM,
 	       *mms_messageLength);
-	
+
 	/* explanation, before I forget what I did:
 	   strlen(buffer)*2 + ct_mms_info->padding + 4 must be divisable by 8;
 	   divide by 8 and add 3 to compute the mms_chunkLenLM field,
-	   but note that things may have to be padded with zeroes to align by 8 
-	   bytes, hence we add 7 and divide by 8 to get the correct length */ 
+	   but note that things may have to be padded with zeroes to align by 8
+	   bytes, hence we add 7 and divide by 8 to get the correct length */
 	*mms_chunkLenLM    = (u_int32_t) (3+(strlen(buffer)*2+ct_mms_info->padding+11)/8);
 	*mms_chunkLenLV    = *mms_chunkLenLM+2;
 	*mms_messageLength = *mms_chunkLenLV*8;
-	
+
 	DEBUGP("ip_nat_mms: modified=> chunkLenLV=%u chunkLenLM=%u"
 	       " messageLength=%u\n", *mms_chunkLenLV, *mms_chunkLenLM,
 	       *mms_messageLength);
-	
-	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, 
+
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
 	                         ct_mms_info->offset,
 	                         ct_mms_info->len + ct_mms_info->padding,
 				 unicode_buffer, strlen(buffer)*2 +
 				 ct_mms_info->padding + zero_padding);
 	DUMP_BYTES(unicode_buffer, 60);
-	
+
 	return NF_ACCEPT;
 }
 
