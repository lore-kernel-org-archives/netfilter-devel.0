From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 8/9]: changes SO_ORIGINAL_DST to
 IPV6_ORIGINAL_DST
Date: Tue, 22 Mar 2005 23:07:23 +0900 (JST)
Message-ID: <200503221407.j2ME7OdV028682@toshiba.co.jp>
References: <20050322.230550.37029177.kozakai@isl.rdc.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_23:07:23_2005_764)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
In-Reply-To: <20050322.230550.37029177.kozakai@isl.rdc.toshiba.co.jp>
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

----Next_Part(Tue_Mar_22_23:07:23_2005_764)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Sorry, I resend.

From: Yasuyuki KOZAKAI <kozakai@isl.rdc.toshiba.co.jp>
Date: Tue, 22 Mar 2005 23:05:50 +0900 (JST)

> 
> This patch changes SO_ORIGINAL_DST in netfilter_ipv6.h to IPV6_ORIGINAL_DST.
> SO_* are socket level option names, not IP level.
> 
> Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> 
> -----------------------------------------------------------------
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
> 

----Next_Part(Tue_Mar_22_23:07:23_2005_764)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="08-getorigdst.patch"

diff -Nur linux-2.6.11-nfct-symbols/include/linux/netfilter_ipv6.h linux-2.6.11-nfct-getorigdst/include/linux/netfilter_ipv6.h
--- linux-2.6.11-nfct-symbols/include/linux/netfilter_ipv6.h	2005-03-22 18:53:22.000000000 +0900
+++ linux-2.6.11-nfct-getorigdst/include/linux/netfilter_ipv6.h	2005-03-22 20:00:06.000000000 +0900
@@ -69,6 +69,6 @@
 	NF_IP6_PRI_LAST = INT_MAX,
 };
 
-#define SO_ORIGINAL_DST 80
+#define IPV6_ORIGINAL_DST 80
 
 #endif /*__LINUX_IP6_NETFILTER_H*/
diff -Nur linux-2.6.11-nfct-symbols/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.11-nfct-getorigdst/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.11-nfct-symbols/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 18:53:36.000000000 +0900
+++ linux-2.6.11-nfct-getorigdst/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 20:00:38.000000000 +0900
@@ -468,8 +468,8 @@
 
 static struct nf_sockopt_ops so_getorigdst = {
 	.pf		= PF_INET6,
-	.get_optmin	= SO_ORIGINAL_DST,
-	.get_optmax	= SO_ORIGINAL_DST+1,
+	.get_optmin	= IPV6_ORIGINAL_DST,
+	.get_optmax	= IPV6_ORIGINAL_DST+1,
 	.get		= &getorigdst,
 };
 

----Next_Part(Tue_Mar_22_23:07:23_2005_764)----
