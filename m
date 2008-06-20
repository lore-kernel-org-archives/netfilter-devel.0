From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools] XML output is invalid
Date: Fri, 20 Jun 2008 16:06:05 +0200
Message-ID: <485BB94D.6000005@netfilter.org>
References: <F7825499-A8F5-4F41-B3DD-2E13807954E2@rotsen.be> <485BAF8B.1050502@netfilter.org> <485BB110.60307@trash.net> <485BB63A.6000404@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050600050707050103090704"
Cc: Sen Haerens <sen@rotsen.be>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49750 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757282AbYFTOGR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:06:17 -0400
In-Reply-To: <485BB63A.6000404@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050600050707050103090704
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Does this patch help?
>>>
>>>
>>> +    if (output_mask & _O_XML) {
>>>          op_type = NFCT_O_XML;
>>> +        if (dump_xml_header_done) {
>>> +            dump_xml_header_done = 0;
>>> +            len = snprintf(buf, 1024, "<?xml version=\"1.0\"?>\n"
>>> +                          "<conntrack>\n");
>>> +        }
>>> +    }
>>>      if (output_mask & _O_EXT)
>>>          op_flags = NFCT_OF_SHOW_LAYER3;
>>>      if (output_mask & _O_ID)
>>>          op_flags |= NFCT_OF_ID;
>>>  
>>> -    nfct_snprintf(buf, 1024, ct, NFCT_T_UNKNOWN, op_type, op_flags);
>>> +    nfct_snprintf(buf+len, 1024-len, ct, NFCT_T_UNKNOWN, op_type,
>>> op_flags);
>>
>> It doesn't seem to matter here, but that looks buggy (combined
>> with the snprintf above). When the buffer size is exceed, snprintf
>> returns the amount of characters it *would have written* if
>> enough space was available. So when this really happens above,
>> you have a buffer overflow in the second snprintf.
> 
> The string above has a fixed size and the buffer is big enough to print
> the flow entry, so the buffer overflow is very unlikely.
> 
> Anyhow, I think that the following patch perform more strict and robust
> checkings regarding the buffer size. I hope that you like better :).

Oops, I forgot the patch. I can also make another patch to check for
other snprintf return values.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------050600050707050103090704
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/conntrack.h b/include/conntrack.h
index 2e17475..dc30c13 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -189,4 +189,10 @@ extern void register_udp(void);
 extern void register_icmp(void);
 extern void register_icmpv6(void);
 
+#define BUFFER_SIZE(ret, len, offset)			\
+	if (ret > len)					\
+		ret = len;				\
+	offset += ret;					\
+	len -= ret;
+
 #endif
diff --git a/src/conntrack.c b/src/conntrack.c
index 25a3a57..f018c82 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -604,10 +604,16 @@ static int ignore_nat(const struct nf_conntrack *obj,
 }
 
 static int counter;
+static int dump_xml_header_done = 1;
 
 static void __attribute__((noreturn))
 event_sighandler(int s)
 {
+	if (dump_xml_header_done == 0) {
+		printf("</conntrack>\n");
+		fflush(stdout);
+	}
+
 	fprintf(stderr, "%s v%s: ", PROGNAME, VERSION);
 	fprintf(stderr, "%d flow events has been shown.\n", counter);
 	nfct_close(cth);
@@ -619,6 +625,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 		    void *data)
 {
 	char buf[1024];
+	int ret, offset = 0, len = 1024;
 	struct nf_conntrack *obj = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
@@ -629,8 +636,20 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	if (options & CT_COMPARISON && !nfct_cmp(obj, ct, NFCT_CMP_ALL))
 		return NFCT_CB_CONTINUE;
 
-	if (output_mask & _O_XML)
+	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
+		if (dump_xml_header_done) {
+			dump_xml_header_done = 0;
+			ret = snprintf(buf, len, "<?xml version=\"1.0\"?>\n"
+						 "<conntrack>\n");
+			if (ret == -1) {
+				fprintf(stderr, "evil! snprintf fails\n");
+				return NFCT_CB_CONTINUE;
+			}
+
+			BUFFER_SIZE(ret, len, offset);
+		}
+	} 
 	if (output_mask & _O_EXT)
 		op_flags = NFCT_OF_SHOW_LAYER3;
 	if (output_mask & _O_TMS) {
@@ -644,7 +663,8 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	if (output_mask & _O_ID)
 		op_flags |= NFCT_OF_ID;
 
-	nfct_snprintf(buf, 1024, ct, type, op_type, op_flags);
+	nfct_snprintf(buf+offset, len, ct, type, op_type, op_flags);
+
 	printf("%s\n", buf);
 	fflush(stdout);
 
@@ -658,6 +678,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		   void *data)
 {
 	char buf[1024];
+	int ret, offset = 0, len = 1024;
 	struct nf_conntrack *obj = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
@@ -668,14 +689,26 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (options & CT_COMPARISON && !nfct_cmp(obj, ct, NFCT_CMP_ALL))
 		return NFCT_CB_CONTINUE;
 
-	if (output_mask & _O_XML)
+	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
+		if (dump_xml_header_done) {
+			dump_xml_header_done = 0;
+			ret = snprintf(buf, len, "<?xml version=\"1.0\"?>\n"
+						 "<conntrack>\n");
+			if (ret == -1) {
+				fprintf(stderr, "evil! snprintf fails\n");
+				return NFCT_CB_CONTINUE;
+			}
+
+			BUFFER_SIZE(ret, len, offset);
+		}
+	}
 	if (output_mask & _O_EXT)
 		op_flags = NFCT_OF_SHOW_LAYER3;
 	if (output_mask & _O_ID)
 		op_flags |= NFCT_OF_ID;
 
-	nfct_snprintf(buf, 1024, ct, NFCT_T_UNKNOWN, op_type, op_flags);
+	nfct_snprintf(buf+offset, len, ct, NFCT_T_UNKNOWN, op_type, op_flags);
 	printf("%s\n", buf);
 
 	counter++;
@@ -1129,6 +1162,11 @@ int main(int argc, char *argv[])
 		else
 			res = nfct_query(cth, NFCT_Q_DUMP, &family);
 
+		if (dump_xml_header_done == 0) {
+			printf("</conntrack>\n");
+			fflush(stdout);
+		}
+
 		nfct_close(cth);
 		break;
 

--------------050600050707050103090704--
