From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 29 Jun 2005 16:22:15 +0200
Message-ID: <42C2AE97.7020305@tac.ch>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
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

> found in the patch-o-matic-ng svn repository. The 2.4 version of the
> nf-log patch (which is required) has been updated as well.

The updated nf-log patch seems to be missing the neccessary symbol exports.
Please consider adding this to your linux-2.4 patch:

 --- linux-2.4.31-orig/net/netsyms.c     2005-04-04 03:42:20 +0200
+++ linux-2.4.31-pab2/net/netsyms.c     2005-06-07 12:16:04 +0200
@@ -594,6 +594,7 @@
 #endif
 #ifdef CONFIG_NETFILTER
 #include <linux/netfilter.h>
+#include <linux/netfilter_logging.h>
 EXPORT_SYMBOL(nf_register_hook);
 EXPORT_SYMBOL(nf_unregister_hook);
 EXPORT_SYMBOL(nf_register_sockopt);
@@ -607,6 +608,10 @@
 EXPORT_SYMBOL(nf_getsockopt);
 EXPORT_SYMBOL(ip_ct_attach);
 EXPORT_SYMBOL(nf_ct_attach);
+EXPORT_SYMBOL(nf_log_register);
+EXPORT_SYMBOL(nf_log_unregister);
+EXPORT_SYMBOL(nf_log_packet);
+EXPORT_SYMBOL(nf_log);
 #ifdef CONFIG_INET
 #include <linux/netfilter_ipv4.h>
 EXPORT_SYMBOL(ip_route_me_harder);

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/nf-log/linux-2.4.patch?rev=4073&r1=4018&r2=4073
also depicts this nicely as well as a failed depmod after compilation ;).

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
