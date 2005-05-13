From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] fix ipt_ACCOUNT for 32bit netmasks
Date: Fri, 13 May 2005 13:08:09 +0200
Message-ID: <200505131308.09535.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZqIhCMFkePbjm0i"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_ZqIhCMFkePbjm0i
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

attached is a patch to fix ipt_ACCOUNT for /32 netmasks.
While looking through the code I also found and fixed a locking bug.

Please apply the patch or let me know if there's trouble applying.

Cheers,
Thomas

--Boundary-00=_ZqIhCMFkePbjm0i
Content-Type: text/x-diff; charset="us-ascii";
	name="ipt_ACCOUNT-32bitnetmask-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ipt_ACCOUNT-32bitnetmask-fix.patch"

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -U3 -r1.32 -r1.34
--- ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c	14 Apr 2005 20:55:52 -0000	1.32
+++ ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c	13 May 2005 10:04:31 -0000	1.34
@@ -137,7 +137,8 @@
     for (i = 0; i < ACCOUNT_MAX_TABLES; i++) {
         /* Found free slot */
         if (ipt_acc_tables[i].name[0] == 0) {
-            u_int32_t j, calc_mask, netsize=0;
+            u_int32_t calc_mask, netsize=0;
+            int j;  /* needs to be signed, otherwise we risk endless loop */
             
             DEBUGP("ACCOUNT: Found free slot: %d\n", i);
             strncpy (ipt_acc_tables[i].name, name, ACCOUNT_TABLE_NAME_LEN-1);
@@ -890,6 +891,7 @@
             down(&ipt_acc_userspace_mutex);
             if ((handle.handle_nr = ipt_acc_handle_find_slot()) == -1) {
                 ipt_acc_data_free(dest.data, dest.depth);
+                up(&ipt_acc_userspace_mutex);
                 return -EINVAL;
             }
             memcpy(&ipt_acc_handles[handle.handle_nr], &dest,

--Boundary-00=_ZqIhCMFkePbjm0i--
