From: Pablo Neira Ayuso <pneira@lsi.us.es>
Subject: [PATCH][CONNTRACK-TOOL] getopts_long returns integer
Date: Thu, 07 Sep 2006 15:18:14 +0200
Message-ID: <45001C16.2060207@lsi.us.es>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020300090403030608000502"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------020300090403030608000502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch was sent some time ago but it seems that it got lost. Please
apply.

--------------020300090403030608000502
Content-Type: text/plain;
 name="type.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="type.patch"

[PATCH][CONNTRACK-TOOL] getopts_long returns integer

getopt_long returns an integer, not a char

Index: src/conntrack.c
===================================================================
--- src/conntrack.c	(revisión: 6458)
+++ src/conntrack.c	(copia de trabajo)
@@ -602,7 +602,7 @@
 
 int main(int argc, char *argv[])
 {
-	char c;
+	int c;
 	unsigned int command = 0, options = 0;
 	unsigned int type = 0, event_mask = 0;
 	unsigned int l3flags = 0, l4flags = 0, metaflags = 0;

--------------020300090403030608000502--
