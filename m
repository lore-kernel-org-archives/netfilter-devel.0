From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/2] ipt_osf: move kernel headers into appropriate ifdef/endif
 area.
Date: Sun, 27 Feb 2005 20:11:50 +0300
Message-ID: <20050227201150.68e7239f@zanzibar.2ka.mipt.ru>
References: <1109308057.6728.54.camel@uganda>
	<4221F609.3060305@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4221F609.3060305@trash.net>
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

Move kernel headers into appropriate ifdef/endif area.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h 2005-02-07 19:11:08.237624320+0300
+++ mod/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h 2005-02-07 19:11:43.854209776 +0300 
@@ -33,9 +33,6 @@
 #define IPT_OSF_LOGLEVEL_ALL   0
 #define IPT_OSF_LOGLEVEL_FIRST 1

-#include <linux/list.h>
-#include <net/tcp.h>
-
 #ifndef __KERNEL__
 #include <netinet/ip.h>
 #include <netinet/tcp.h>
@@ -98,6 +95,10 @@

 #ifdef __KERNEL__

+#include <linux/list.h>
+#include <net/tcp.h>
+
+
 /* Defines for IANA option kinds */

 #define OSFOPT_EOL             0       /* End of options */



	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
