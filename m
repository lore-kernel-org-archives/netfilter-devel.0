From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] Fix ipt_ACCOUNT for large networks
Date: Mon, 4 Apr 2005 11:02:57 +0200
Message-ID: <200504041102.57717.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Peter Surda <shurdeek@routehat.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
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

Hi Patrick,

attached is a small patch to fix the ACCOUNT target
for large networks. The bug was introduced when
the code was more modularized.

Kudos go to Peter Surda for finding the bug.

Cheers,
Thomas

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -u -r -p ipt_ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c ipt_ACCOUNT.fixed/linux/net/ipv4/netfilter/ipt_ACCOUNT.c
--- ipt_ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c  2005-04-04 10:36:22.000000000 +0200
+++ ipt_ACCOUNT.fixed/linux/net/ipv4/netfilter/ipt_ACCOUNT.c    2005-04-04 10:36:57.802104874 +0200
@@ -714,9 +714,9 @@ int ipt_acc_handle_copy_data(void *to_us

             /* Temporary buffer full? Flush to userspace */
             if (*pos+handle_ip_size >= PAGE_SIZE) {
-                *pos = 0;
                 if (copy_to_user(to_user, ipt_acc_tmpbuf, *pos))
                     return -EFAULT;
+                *pos = 0;
             }
             memcpy(ipt_acc_tmpbuf+*pos, &handle_ip, handle_ip_size);
             *pos += handle_ip_size;
