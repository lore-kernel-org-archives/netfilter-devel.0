From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] fix iptables-restore escaping of quotes
Date: Mon, 20 Dec 2004 16:31:57 +1000
Message-ID: <41C671DD.2070207@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060509060001060309060409"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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
--------------060509060001060309060409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

iptables-restore was losing a character at the start of the parameter
for every escaped quote within the parameter.

This is of signifance when there are " characters in log prefixes.
Note that iptables-save can't generate escaped quotes;  I am
generating the input for iptables-restore from a script.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com

--------------060509060001060309060409
Content-Type: text/plain;
 name="iptables-escape-quote.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-escape-quote.patch"

Index: iptables-restore.c
===================================================================
--- iptables-restore.c	(revision 3377)
+++ iptables-restore.c	(working copy)
@@ -336,12 +336,15 @@
 			param_start = parsestart;
 			
 			for (curchar = parsestart; *curchar; curchar++) {
+				if (*curchar == '\\' && *(curchar+1) == '"') {
+					if (quote_open) {
+						memmove(curchar, curchar+1,
+							strlen(curchar+1));
+						continue;
+					}
+				}
 				if (*curchar == '"') {
-					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
-					 * curchar-1 has to be within bounds */
-					if (quote_open && 
-					    *(curchar-1) != '\\') {
+					if (quote_open) {
 						quote_open = 0;
 						*curchar = ' ';
 					} else {

--------------060509060001060309060409--
