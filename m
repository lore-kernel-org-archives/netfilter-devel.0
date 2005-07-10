From: Jens Hoelldampf <jens@hoelldampf.net>
Subject: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 16:18:16 +0200
Message-ID: <42D12E28.7020707@hoelldampf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

the upstream patch from

https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=91

destroys the functionality of SO_ORIGINAL_DST for local generated
packets. It returns the local address the connection is redirected to
instead of the original destination address. As a result you cannot use
local transparent proxies anymore.

The responsible change is

diff -ru linux-orig/net/ipv4/ip_output.c linux-new/net/ipv4/ip_output.c
--- linux-orig/net/ipv4/ip_output.c	2005-03-25 14:48:13.543911760 -0500
+++ linux-new/net/ipv4/ip_output.c	2005-03-26 01:01:13.064616240 -0500
@@ -195,6 +195,8 @@
 	nf_debug_ip_finish_output2(skb);
 #endif /*CONFIG_NETFILTER_DEBUG*/

+	nf_reset(skb);
+
 	if (hh) {
 		int hh_alen;

After removing the added line SO_ORIGINAL_DST returns the expected address.

Should I open a new bug or reopen the old one?

Regards,
 Jens
