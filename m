From: laurent.ml@linuxfr.org
Subject: iptables/extensions/libipt_time.c missing include
Date: Fri, 23 Jan 2004 03:06:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <wazza.877jzj8ll6.fsf@message.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

Tell me if I'm wrong, it seems an include is missing in
extensions/libipt_time.c from iptables cvs.
(line 302 : offsetof)

--- extensions/libipt_time.c.ancien     2004-01-23 02:59:59.000000000
    +0100
+++ extensions/libipt_time.c    2004-01-23 02:54:17.000000000 +0100
@@ -3,6 +3,7 @@
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
+#include <linux/stddef.h>
 #include <getopt.h>
 
 #include <iptables.h>


-- 
Laurent
