From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [Fwd: Bug fixed]
Date: 10 Jun 2002 10:50:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023699042.19837.77.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: zhongyu <zhongyu@ecfounder.com>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Forwarding your patch to netfilter-devel where it belongs.

-----Forwarded Message-----

From: zhongyu <zhongyu@ecfounder.com>
To: netfilter@lists.samba.org
Subject: Bug fixed
Date: 10 Jun 2002 16:23:34 +0800

Fix iptable_nat's memory leak problem.

--- linux-orig/net/ipv4/netfilter/ip_nat_core.c Mon Jun 10 16:15:10 2002
+++ linux/net/ipv4/netfilter/ip_nat_core.c Mon Jun 10 16:17:30 2002
@@ -913,4 +913,5 @@
{
ip_ct_selective_cleanup(&clean_nat, NULL);
ip_conntrack_destroyed = NULL;
+ vfree(bysource);
}


-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
