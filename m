From: James Morris <jmorris@namei.org>
Subject: [RFC][SECMARK 06/08] Define a relabelto permission in the SELinux
 packet class (fwd)
Date: Sun, 7 May 2006 13:47:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605071346560.9423@d.namei>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

---------- Forwarded message ----------
Date: Sun, 7 May 2006 11:38:08 -0400 (EDT)
From: James Morris <jmorris@namei.org>
To: selinux@tycho.nsa.gov
Cc: netdev@vger.kernel.org, netfilter-devel@lists.samba.org,
    Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>
Subject: [RFC][SECMARK 06/08] Define a relabelto permission in the SELinux
    packet class

This patch defines a new permission ('relabelto') in the new SELinux 
packet object class, to be used when setting SECMARK rules for labeling 
packets.

Signed-off-by: James Morris <jmorris@namei.org>

---

 security/selinux/include/av_perm_to_string.h |    1 +
 security/selinux/include/av_permissions.h    |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -purN -X dontdiff linux-2.6.17-rc3-git7.p/security/selinux/include/av_permissions.h linux-2.6.17-rc3-git7.w/security/selinux/include/av_permissions.h
--- linux-2.6.17-rc3-git7.p/security/selinux/include/av_permissions.h	2006-05-03 11:34:17.000000000 -0400
+++ linux-2.6.17-rc3-git7.w/security/selinux/include/av_permissions.h	2006-05-07 00:14:13.000000000 -0400
@@ -935,4 +935,4 @@
 
 #define PACKET__SEND                              0x00000001UL
 #define PACKET__RECV                              0x00000002UL
-
+#define PACKET__RELABELTO                         0x00000004UL
diff -purN -X dontdiff linux-2.6.17-rc3-git7.p/security/selinux/include/av_perm_to_string.h linux-2.6.17-rc3-git7.w/security/selinux/include/av_perm_to_string.h
--- linux-2.6.17-rc3-git7.p/security/selinux/include/av_perm_to_string.h	2006-05-03 11:34:17.000000000 -0400
+++ linux-2.6.17-rc3-git7.w/security/selinux/include/av_perm_to_string.h	2006-05-07 00:14:34.000000000 -0400
@@ -241,3 +241,4 @@
    S_(SECCLASS_ASSOCIATION, ASSOCIATION__SETCONTEXT, "setcontext")
    S_(SECCLASS_PACKET, PACKET__SEND, "send")
    S_(SECCLASS_PACKET, PACKET__RECV, "recv")
+   S_(SECCLASS_PACKET, PACKET__RELABELTO, "relabelto")
