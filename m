From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: fix ipt_MASQUERADE in latest -bk
Date: Fri, 29 Aug 2003 02:10:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4E99F2.8040907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080401090008010606030208"
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
--------------080401090008010606030208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this change broke masquerading, key.oif is uninitialized and routing
lookups fail:

[NETFILTER]: Fix masquerade routing check, backport to 2.4 by 
kurd@cp.rtfm.se

This patch fixes it.

Best regards,
Patrick

--------------080401090008010606030208
Content-Type: text/plain;
 name="ipt_MASQUERADE-oif.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_MASQUERADE-oif.diff"

===== net/ipv4/netfilter/ipt_MASQUERADE.c 1.6 vs edited =====
--- 1.6/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Aug 12 11:30:12 2003
+++ edited/net/ipv4/netfilter/ipt_MASQUERADE.c	Fri Aug 29 02:09:24 2003
@@ -87,6 +87,7 @@
 	key.dst = (*pskb)->nh.iph->daddr;
 	key.src = 0; /* Unknown: that's what we're trying to establish */
 	key.tos = RT_TOS((*pskb)->nh.iph->tos)|RTO_CONN;
+	key.oif = 0;
 #ifdef CONFIG_IP_ROUTE_FWMARK
 	key.fwmark = (*pskb)->nfmark;
 #endif

--------------080401090008010606030208--
