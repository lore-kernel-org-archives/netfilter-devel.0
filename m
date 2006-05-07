From: James Morris <jmorris@namei.org>
Subject: [RFC][SECMARK 02/08] Export selinux_string_to_sid from SELinux (fwd)
Date: Sun, 7 May 2006 13:46:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605071346000.9423@d.namei>
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
Date: Sun, 7 May 2006 11:34:17 -0400 (EDT)
From: James Morris <jmorris@namei.org>
To: selinux@tycho.nsa.gov
Cc: netdev@vger.kernel.org, netfilter-devel@lists.samba.org,
    Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>
Subject: [RFC][SECMARK 02/08] Export selinux_string_to_sid from SELinux

This patch exports adds a new function to the in-kernel
SELinux API: selinux_string_to_sid().  It maps a text
security context to an SELiux security ID (SID).


Signed-off-by: James Morris <jmorris@namei.org>

---

 include/linux/selinux.h    |   16 ++++++++++++++++
 security/selinux/exports.c |   11 +++++++++++
 2 files changed, 27 insertions(+)

diff -purN -X dontdiff linux-2.6.17-rc2-mm1.p/include/linux/selinux.h linux-2.6.17-rc2-mm1.w/include/linux/selinux.h
--- linux-2.6.17-rc2-mm1.p/include/linux/selinux.h	2006-04-27 10:44:26.000000000 -0400
+++ linux-2.6.17-rc2-mm1.w/include/linux/selinux.h	2006-04-28 00:53:27.000000000 -0400
@@ -118,6 +118,16 @@ void selinux_get_ipc_sid(const struct ke
  */
 void selinux_get_task_sid(struct task_struct *tsk, u32 *sid);
 
+/**
+ *     selinux_string_to_sid - map a security context string to a security ID
+ *     @str: the security context string to be mapped
+ *     @sid: ID value returned via this.
+ *
+ *     Returns 0 if successful, with the SID stored in sid.  A value
+ *     of zero for sid indicates no SID could be determined (but no error
+ *     occurred).
+ */
+int selinux_string_to_sid(char *str, u32 *sid);
 
 #else
 
@@ -172,6 +182,12 @@ static inline void selinux_get_task_sid(
 	*sid = 0;
 }
 
+static inline int selinux_string_to_sid(const char *str, u32 *sid)
+{
+       *sid = 0;
+       return 0;
+}
+
 #endif	/* CONFIG_SECURITY_SELINUX */
 
 #endif /* _LINUX_SELINUX_H */
diff -purN -X dontdiff linux-2.6.17-rc2-mm1.p/security/selinux/exports.c linux-2.6.17-rc2-mm1.w/security/selinux/exports.c
--- linux-2.6.17-rc2-mm1.p/security/selinux/exports.c	2006-04-27 10:44:26.000000000 -0400
+++ linux-2.6.17-rc2-mm1.w/security/selinux/exports.c	2006-04-28 00:51:25.000000000 -0400
@@ -72,3 +72,14 @@ void selinux_get_task_sid(struct task_st
 	*sid = 0;
 }
 
+int selinux_string_to_sid(char *str, u32 *sid)
+{
+	if (selinux_enabled)
+		return security_context_to_sid(str, strlen(str), sid);
+	else {
+		*sid = 0;
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(selinux_string_to_sid);
+
