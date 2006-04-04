From: Stephen Hemminger <shemminger@osdl.org>
Subject: [PATCH] ip_conntrack section mismatch warning fix
Date: Tue, 4 Apr 2006 11:32:33 -0700
Message-ID: <20060404113233.4de507d3@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

This is a bit of a hack. It eliminates the section mismatch warning from
latest linker. What happens is the init_or_cleanup code gets called
from cleanup() hook and the linker thinks it will reference __initdata
because of it's limited static analysis.  By asking compiler to
inline, it can eliminate that dead code. It does the __init text
section to grow, but then the space can be reclaimed.

Signed-off-by: Stephen Hemminger <shemminger@osdl.org>


--- test-2.6.orig/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ test-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -783,7 +783,7 @@ static ctl_table ip_ct_net_table[] = {
 EXPORT_SYMBOL(ip_ct_log_invalid);
 #endif /* CONFIG_SYSCTL */
 
-static int init_or_cleanup(int init)
+static inline int init_or_cleanup(int init)
 {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
