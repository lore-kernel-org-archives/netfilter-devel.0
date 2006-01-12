From: "David S. Miller" <davem@davemloft.net>
Subject: Re: "local_bh_disable" [net/ipv4/netfilter/ip_conntrack_pptp.ko]
 undefined!
Date: Wed, 11 Jan 2006 16:03:53 -0800 (PST)
Message-ID: <20060111.160353.29305641.davem@davemloft.net>
References: <BAY103-F14AC8393B0461DA69156BCB2240@phx.gbl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pupilla@hotmail.com
In-Reply-To: <BAY103-F14AC8393B0461DA69156BCB2240@phx.gbl>
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

From: "Marco Berizzi" <pupilla@hotmail.com>
Date: Wed, 11 Jan 2006 10:49:12 +0100

> I'm compiling pptp conntrack/nat as module and I getting this warning:

This should fix it:

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 799be67..7db4df8 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -53,6 +53,7 @@
 #include <linux/thread_info.h>
 #include <linux/kernel.h>
 #include <linux/stringify.h>
+#include <linux/interrupt.h>
 
 #include <asm/system.h>
 
