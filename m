From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: warn for icmp type 255
Date: Tue, 05 Aug 2003 01:59:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F2EF375.407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060609060901060303060902"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060609060901060303060902
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a warning if icmp-type 255 is given. Maybe we should fix 
this
right in 2.6 as long as it's still possible, even if that means having 
some #ifdefs
in the userspace code ?

Best regards,
Patrick

--------------060609060901060303060902
Content-Type: text/plain;
 name="libipt_icmp-warn-icmp-0xff.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_icmp-warn-icmp-0xff.diff"

Index: libipt_icmp.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_icmp.c,v
retrieving revision 1.8
diff -u -r1.8 libipt_icmp.c
--- libipt_icmp.c	25 Feb 2003 10:50:59 -0000	1.8
+++ libipt_icmp.c	4 Aug 2003 23:49:00 -0000
@@ -77,7 +77,7 @@
 };
 
 static void
-print_icmptypes()
+print_icmptypes(void)
 {
 	unsigned int i;
 	printf("Valid ICMP Types:");
@@ -153,6 +153,9 @@
 		if (string_to_number(buffer, 0, 255, &number) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid ICMP type `%s'\n", buffer);
+		if (number == 0xFF)
+			fprintf(stderr, "Warning: ICMP type 255 is used "
+					"internally and matches all types!\n");
 		*type = number;
 		if (slash) {
 			if (string_to_number(slash+1, 0, 255, &number) == -1)

--------------060609060901060303060902--
