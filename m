From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: [PATCH] fix missing include in iptables-1.2.9-20040409
Date: Sun, 11 Apr 2004 12:37:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40791FF8.9030503@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000703080304090908080205"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------000703080304090908080205
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi netfilter team!

iptables-save.c in iptables-1.2.9-20040409 needs "#include <netdb.h>" for 
getprotobynumber() so it compiles.

-- 
MfG / Regards
Friedrich Lobenstock

--------------000703080304090908080205
Content-Type: text/plain;
 name="patch-iptables-1.2.9-20040409"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-iptables-1.2.9-20040409"

--- iptables-1.2.9-20040409/iptables-save.c~	2004-04-11 13:22:32.000000000 +0200
+++ iptables-1.2.9-20040409/iptables-save.c	2004-04-11 13:22:32.000000000 +0200
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <dlfcn.h>
 #include <time.h>
+#include <netdb.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
 

--------------000703080304090908080205--
