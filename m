From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] fix owner-socketlookup patch
Date: Thu, 17 Apr 2003 16:24:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9EB90A.4050701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060007010608070203020805"
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
--------------060007010608070203020805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this patch fixes build of the ipt_owner.c as module with the 
owner-socketlookup patch.
When neither of CONFIG_IPV6_MODULE/CONFIG_KHTTPD/CONFIG_KHTTPD_MODULE
are defined tcp_timewait_cachep needs to be exported for tcp_tw_put().

Please apply to CVS.

Best regards,
Patrick


--------------060007010608070203020805
Content-Type: text/plain;
 name="owner.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="owner.diff"

Index: patch-o-matic/extra/owner-socketlookup.patch
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic/extra/owner-socketlookup.patch,v
retrieving revision 1.1
diff -u -r1.1 owner-socketlookup.patch
--- patch-o-matic/extra/owner-socketlookup.patch	1 Apr 2003 18:02:42 -0000	1.1
+++ patch-o-matic/extra/owner-socketlookup.patch	17 Apr 2003 14:17:45 -0000
@@ -201,14 +201,17 @@
  
 diff -urN a/net/netsyms.c b/net/netsyms.c
 --- a/net/netsyms.c	2002-11-29 00:53:16.000000000 +0100
-+++ b/net/netsyms.c	2003-03-27 15:33:45.000000000 +0100
-@@ -596,4 +596,9 @@
++++ b/net/netsyms.c	2003-04-17 16:10:31.000000000 +0200
+@@ -596,4 +596,12 @@
  EXPORT_SYMBOL(wireless_send_event);
  #endif /* CONFIG_NET_RADIO || CONFIG_NET_PCMCIA_RADIO */
  
 +#if defined(CONFIG_IP_NF_MATCH_OWNER)||defined(CONFIG_IP_NF_MATCH_OWNER_MODULE)
 +EXPORT_SYMBOL(tcp_v4_lookup);
 +EXPORT_SYMBOL(udp_v4_lookup);
++#if !(defined (CONFIG_IPV6_MODULE) || defined (CONFIG_KHTTPD) || defined (CONFIG_KHTTPD_MODULE))
++EXPORT_SYMBOL(tcp_timewait_cachep);
++#endif
 +#endif /* CONFIG_IP_NF_MATCH_OWNER */
 +
  #endif  /* CONFIG_NET */

--------------060007010608070203020805--
