From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [2/2] ipt_osf: includes cleanup.
Date: Sun, 27 Feb 2005 20:13:55 +0300
Message-ID: <20050227201355.3714a5df@zanzibar.2ka.mipt.ru>
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

Includes cleanup.
ipt_osf requires inetdevice.h and tcp.h.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
+++ mod/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
@@ -44,9 +44,9 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/if.h>
-
-#include <net/sock.h>
+#include <linux/inetdevice.h>
 #include <net/ip.h>
+#include <linux/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 





	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
