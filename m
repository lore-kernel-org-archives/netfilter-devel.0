From: Thomas Woerner <twoerner@redhat.com>
Subject: [PATCH] cleanup
Date: Thu, 09 Sep 2004 17:29:11 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414076C7.7000009@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010509030403080305000909"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010509030403080305000909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Hello,


I got this patch for iptables in bugzilla #131848 from Steve Grubb. Are including it 
in the next version?


Thanks in advance,
Thomas

-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/

--------------010509030403080305000909
Content-Type: text/x-patch;
 name="iptables-1.2.11-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.11-cleanup.patch"

diff -ur iptables-1.2.11.orig/extensions/libipt_REJECT.c iptables-1.2.11/extensions/libipt_REJECT.c
--- iptables-1.2.11.orig/extensions/libipt_REJECT.c	2004-09-05 11:27:49.000000000 -0400
+++ iptables-1.2.11/extensions/libipt_REJECT.c	2004-09-05 11:28:17.000000000 -0400
@@ -147,13 +147,16 @@
 {
 	const struct ipt_reject_info *reject
 		= (const struct ipt_reject_info *)target->data;
-	unsigned int i;
+	unsigned int i, limit=sizeof(reject_table)/sizeof(struct reject_names);
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
+	for (i = 0; i < limit; i++) {
 		if (reject_table[i].with == reject->with)
 			break;
 	}
-	printf("reject-with %s ", reject_table[i].name);
+	if (i < limit)
+		printf("reject-with %s ", reject_table[i].name);
+	else
+		printf("reject-with: error reject->with not found ");
 }
 
 /* Saves ipt_reject in parsable form to stdout. */
@@ -161,13 +164,15 @@
 {
 	const struct ipt_reject_info *reject
 		= (const struct ipt_reject_info *)target->data;
-	unsigned int i;
+	unsigned int i, limit=sizeof(reject_table)/sizeof(struct reject_names);
 
-	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++)
+	for (i = 0; i < limit; i++)
 		if (reject_table[i].with == reject->with)
 			break;
-
-	printf("--reject-with %s ", reject_table[i].name);
+	if (i < limit)
+		printf("--reject-with %s ", reject_table[i].name);
+	else
+		fprintf(stderr, "--reject-with error reject->with not found");
 }
 
 static
diff -ur iptables-1.2.11.orig/extensions/libipt_rpc.c iptables-1.2.11/extensions/libipt_rpc.c
--- iptables-1.2.11.orig/extensions/libipt_rpc.c	2004-09-05 11:27:50.000000000 -0400
+++ iptables-1.2.11/extensions/libipt_rpc.c	2004-09-05 11:41:11.000000000 -0400
@@ -252,7 +252,7 @@
 
 			idup = 0;
 			memset(buf, 0, sizeof(buf));
-			dst = (char *)buf - 1;
+			dst = (char *)buf;
 		}
 	}
 

--------------010509030403080305000909--
