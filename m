From: Robbie Dinn <robbie@microbus.com>
Subject: bug report/fix for 'proc-no-internal-targets' patch
Date: Fri, 07 May 2004 10:50:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409B5BF9.5040103@microbus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Patrick,

I would like to report a trivial bug in the proc-no-internal-targets
patch in patch-o-matic-ng which I recently downloaded from CVS.

I was able to fix it myself.

I am working with kernel-2.6.6-rc3-mm2 + patch-o-matic from CVS.
I believe the 2.4.XX kernel has the same problem.

--- net/ipv4/netfilter/ip_tables.c	2004-05-07 10:40:28.230993459 +0100
+++ net/ipv4/netfilter/ip_tables.c.orig	2004-05-07 10:29:33.812943895 +0100
@@ -1756,7 +1756,7 @@
                                 off_t start_offset, char *buffer, int 
length,
                                 off_t *pos, unsigned int *count)
  {
-	if (t == &ipt_standard_target || t == &ipt_error_target)
+	if (t != &ipt_standard_target && t != &ipt_error_target)
  		return 0;
  	return print_name((char *)t, start_offset, buffer, length, pos, count);
  }


with proc-no-internal-targets applied, but without the above diff

   robbie@rjd:~> cat /proc/net/ip_tables_targets

   ERROR
   robbie@rjd:~>

with proc-no-internal-targets applied, plus the one line fix above

   robbie@rjd:~> cat /proc/net/ip_tables_targets
   TCPMSS
   TOS
   MARK
   LOG
   REJECT
   DNAT
   SNAT
   robbie@rjd:~>

Hope that helps.
