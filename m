From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] ip_ct_refresh_optimization.patch
Date: 12 Sep 2002 10:41:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <vebs73bnx1.fsf@inigo.ingate.se>
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

The ip_ct_refresh_optimization.patch in p-o-m is completely broken,
as it doesn't handle when the timeout is decreased. This results
in TCP-connections in CLOSE and TIME_WAIT states still having the
5 day timeout they had when they were in ESTABLISHED state.

This patch always updates the timeout if the difference is >= HZ.

diff -u -r1.1 ip_ct_refresh_optimization.patch
--- patch-o-matic/optimizations/ip_ct_refresh_optimization.patch	11 Jun 2002 08:02:57 -0000	1.1
+++ patch-o-matic/optimizations/ip_ct_refresh_optimization.patch	12 Sep 2002 08:11:52 -0000
@@ -69,7 +69,7 @@
 +		/* Don't update timer for each packet, only if it's been >HZ
 +		 * ticks since last update.
 +		 * Need del_timer for race avoidance (may already be dying). */
-+		if (time_after(jiffies, ct->timeout.expires - extra_jiffies + HZ) && del_timer(&ct->timeout)) {
++		if (abs(jiffies + extra_jiffies - ct->timeout.expires) >= HZ && del_timer(&ct->timeout)) {
  			ct->timeout.expires = jiffies + extra_jiffies;
  			add_timer(&ct->timeout);
  		}

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
