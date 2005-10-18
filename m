From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] connmark requires ip_conntrack
Date: Wed, 19 Oct 2005 00:57:53 +0200
Message-ID: <43557DF1.60207@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040405090805000407090909"
Cc: Piotr Chytla <pch@packetconsulting.pl>, Patrick McHardy <kaber@trash.net>
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
--------------040405090805000407090909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

The connmark match/target require ip_conntrack to work. This patch add 
such dependency via need_ip_conntrack(). Thanks to Piotr Chytla for 
spotting this problem.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--------------040405090805000407090909
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ipt_CONNMARK.c b/net/ipv4/netfilter/ipt_CONNMARK.c
index 1346380..05d66ab 100644
--- a/net/ipv4/netfilter/ipt_CONNMARK.c
+++ b/net/ipv4/netfilter/ipt_CONNMARK.c
@@ -109,6 +109,7 @@ static struct ipt_target ipt_connmark_re
 
 static int __init init(void)
 {
+	need_ip_conntrack();
 	return ipt_register_target(&ipt_connmark_reg);
 }
 
diff --git a/net/ipv4/netfilter/ipt_connmark.c b/net/ipv4/netfilter/ipt_connmark.c
index bf8de47..d99cf71 100644
--- a/net/ipv4/netfilter/ipt_connmark.c
+++ b/net/ipv4/netfilter/ipt_connmark.c
@@ -76,6 +76,7 @@ static struct ipt_match connmark_match =
 
 static int __init init(void)
 {
+	need_ip_conntrack();
 	return ipt_register_match(&connmark_match);
 }
 

--------------040405090805000407090909--
