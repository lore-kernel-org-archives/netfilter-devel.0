From: Jerome Borsboom <j.borsboom@erasmusmc.nl>
Subject: [PATCH] reorder delimiters in xdigit2bin
Date: Tue, 16 Jan 2007 10:13:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0701161002330.1007@knorkaan.xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@lists.netfilter.org
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

The nf_conntrack SIP helper does not catch ip-address cases like 
192.168.1.1:5060 due to the ':' not being catched by the recently 
introduced wildcard delimiters in in[46]_pton. Reordering the xdigit2bin 
function solves this.

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>

--- linux-2.6.20-rc5/net/core/utils.c	2007-01-16 09:57:05.000000000 +0100
+++ linux-2.6.20-rc5.new/net/core/utils.c	2007-01-16 09:59:49.000000000 +0100
@@ -103,8 +103,6 @@
  {
  	if (c == delim || c == '\0')
  		return IN6PTON_DELIM;
-	if (c == ':')
-		return IN6PTON_COLON_MASK;
  	if (c == '.')
  		return IN6PTON_DOT;
  	if (c >= '0' && c <= '9')
@@ -115,6 +113,8 @@
  		return (IN6PTON_XDIGIT | (c - 'A' + 10));
  	if (delim == -1)
  		return IN6PTON_DELIM;
+	if (c == ':')
+		return IN6PTON_COLON_MASK;
  	return IN6PTON_UNKNOWN;
  }
