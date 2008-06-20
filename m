From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools] XML output is invalid
Date: Fri, 20 Jun 2008 15:24:27 +0200
Message-ID: <485BAF8B.1050502@netfilter.org>
References: <F7825499-A8F5-4F41-B3DD-2E13807954E2@rotsen.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030806040000090802070300"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Sen Haerens <sen@rotsen.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51235 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752858AbYFTNYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:24:32 -0400
In-Reply-To: <F7825499-A8F5-4F41-B3DD-2E13807954E2@rotsen.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030806040000090802070300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sen Haerens wrote:
> Hi Pablo,
> 
> I wanted to enter this into Bugzilla but I can't pick the
> conntrack-tools product when entering a bug.

I'll check what happen with this.

> Outputting XML from conntrack produces an invalid XML document:
> 
> * The XML declaration is missing: <?xml version="1.0"?>
> * There can only be one root element. We have to wrap all the flow
> elements into a single root element:
> <conntrack>
> <flow>[...]</flow>
> <flow>[...]</flow>
> [...]
> </conntrack>
> 
> My version: conntrack v0.9.7 (conntrack-tools)

Does this patch help?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------030806040000090802070300
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/conntrack.c b/src/conntrack.c
index 25a3a57..6b43352 100644
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
+	int len = 0;
 	struct nf_conntrack *obj = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
@@ -629,8 +636,14 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	if (options & CT_COMPARISON && !nfct_cmp(obj, ct, NFCT_CMP_ALL))
 		return NFCT_CB_CONTINUE;
 
-	if (output_mask & _O_XML)
+	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
+		if (dump_xml_header_done) {
+			dump_xml_header_done = 0;
+			len = snprintf(buf, 1024, "<?xml version=\"1.0\"?>\n"
+						  "<conntrack>\n");
+		}
+	} 
 	if (output_mask & _O_EXT)
 		op_flags = NFCT_OF_SHOW_LAYER3;
 	if (output_mask & _O_TMS) {
@@ -644,7 +657,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	if (output_mask & _O_ID)
 		op_flags |= NFCT_OF_ID;
 
-	nfct_snprintf(buf, 1024, ct, type, op_type, op_flags);
+	nfct_snprintf(buf+len, 1024-len, ct, type, op_type, op_flags);
 	printf("%s\n", buf);
 	fflush(stdout);
 
@@ -658,6 +671,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		   void *data)
 {
 	char buf[1024];
+	int len = 0;
 	struct nf_conntrack *obj = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
@@ -668,14 +682,20 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (options & CT_COMPARISON && !nfct_cmp(obj, ct, NFCT_CMP_ALL))
 		return NFCT_CB_CONTINUE;
 
-	if (output_mask & _O_XML)
+	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
+		if (dump_xml_header_done) {
+			dump_xml_header_done = 0;
+			len = snprintf(buf, 1024, "<?xml version=\"1.0\"?>\n"
+						  "<conntrack>\n");
+		}
+	}
 	if (output_mask & _O_EXT)
 		op_flags = NFCT_OF_SHOW_LAYER3;
 	if (output_mask & _O_ID)
 		op_flags |= NFCT_OF_ID;
 
-	nfct_snprintf(buf, 1024, ct, NFCT_T_UNKNOWN, op_type, op_flags);
+	nfct_snprintf(buf+len, 1024-len, ct, NFCT_T_UNKNOWN, op_type, op_flags);
 	printf("%s\n", buf);
 
 	counter++;
@@ -1129,6 +1149,11 @@ int main(int argc, char *argv[])
 		else
 			res = nfct_query(cth, NFCT_Q_DUMP, &family);
 
+		if (dump_xml_header_done == 0) {
+			printf("</conntrack>\n");
+			fflush(stdout);
+		}
+
 		nfct_close(cth);
 		break;
 

--------------030806040000090802070300--
