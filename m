From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Add support of Boyer-Moore to the string match
Date: Fri, 26 Aug 2005 01:49:08 +0200
Message-ID: <430E58F4.6090008@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070604030000060400090000"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------070604030000060400090000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Davem has recently applied my patch to add support for Boyer-Moore 
algorithm. So, the patch attached enables the use of it in the string 
match for iptables that I submitted[1] some days ago.

[1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/021002.html

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--------------070604030000060400090000
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: netfilter-2.6.14/net/ipv4/netfilter/Kconfig
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/Kconfig	2005-08-25 21:22:55.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/Kconfig	2005-08-26 01:41:51.000000000 +0200
@@ -416,6 +416,7 @@
 	select TEXTSEARCH
 	select TEXTSEARCH_KMP
 	select TEXTSEARCH_FSM
+	select TEXTSEARCH_BM
 	help
 	  This option adds a `string' match, which allows you to look for
 	  pattern matchings in packets.

--------------070604030000060400090000--
