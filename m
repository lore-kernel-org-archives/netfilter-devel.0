From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3/6 RFC] netfilter: audit only on xtables and ebtables syscall rule or standalone
Date: Thu, 18 May 2017 13:21:49 -0400
Message-ID: <ac9a2120311288328a81d3e07a68857ebd32a21b.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932421AbdERRXY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 13:23:24 -0400
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There were syscall events unsolicited by any audit rule caused by a missing
!audit_dummy_context() check before creating an
iptables/ip6tables/arptables/ebtables NETFILTER_CFG record.  Check
!audit_dummy_context() before creating the NETFILTER_CFG record.

The vast majority of observed unaccompanied records are caused by the fedora
default rule: "-a never,task" and the occasional early startup one is I believe
caused by the iptables filter table module hard linked into the kernel rather
than a loadable module. The !audit_dummy_context() check above should avoid
them.  Audit only when there is an existing syscall audit rule, otherwise issue
a standalone record only on table modification rather than empty table
creation.

Add subject attributes to the new standalone NETFILTER_CFGSOLO record using
a newly exported audit_log_task().

Since the record format will change anyways, this seemed like the right time to
change the order of the fields to put the protocol family before the table
name.

Here is a new sample accompanied record:
  type=NETFILTER_CFG msg=audit(1494977049.375:9418): family=2 table=filter entries=84

and unaccompanied case:
  type=UNKNOWN[1331] msg=audit(1494815998.168:163): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:iptables_t:s0 pid=597 comm="iptables-restor" exe="/usr/sbin/xtables-multi" family=2 table=filter entries=4

See: https://github.com/linux-audit/audit-kernel/issues/25
See: https://github.com/linux-audit/audit-kernel/issues/35

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h           |    4 +++-
 include/uapi/linux/audit.h      |    1 +
 kernel/auditsc.c                |    3 ++-
 net/bridge/netfilter/ebtables.c |   25 +++++++++++++++++++------
 net/netfilter/x_tables.c        |   26 +++++++++++++++++++-------
 5 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2150bdc..b6fcab1 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -155,7 +155,7 @@ extern void		    audit_log_link_denied(const char *operation,
 static inline void	    audit_log_secctx(struct audit_buffer *ab, u32 secid)
 { }
 #endif
-
+extern void audit_log_task(struct audit_buffer *ab);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab,
 				struct task_struct *tsk);
@@ -205,6 +205,8 @@ static inline void audit_log_link_denied(const char *string,
 { }
 static inline void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 { }
+static inline void audit_log_task(struct audit_buffer *ab)
+{ }
 static inline int audit_log_task_context(struct audit_buffer *ab)
 {
 	return 0;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 0714a66..8bee3f5 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -112,6 +112,7 @@
 #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
 #define AUDIT_REPLACE		1329	/* Replace auditd if this packet unanswerd */
 #define AUDIT_KERN_MODULE	1330	/* Kernel Module events */
+#define AUDIT_NETFILTER_CFGSOLO	1331	/* Netfilter chain modifications standalone */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b2dcbe6..8ac38e6 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2383,7 +2383,7 @@ void __audit_log_kern_module(char *name)
 	context->type = AUDIT_KERN_MODULE;
 }
 
-static void audit_log_task(struct audit_buffer *ab)
+void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
 	kgid_t gid;
@@ -2404,6 +2404,7 @@ static void audit_log_task(struct audit_buffer *ab)
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_d_path_exe(ab, current->mm);
 }
+EXPORT_SYMBOL_GPL(audit_log_task);
 
 /**
  * audit_core_dumps - record information about processes that end abnormally
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 13d7fe2..743f9e6 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1071,12 +1071,25 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	if (audit_enabled) {
 		struct audit_buffer *ab;
 
-		ab = audit_log_start(current->audit_context, GFP_KERNEL,
-				     AUDIT_NETFILTER_CFG);
-		if (ab) {
-			audit_log_format(ab, "table=%s family=%u entries=%u",
-					 repl->name, AF_BRIDGE, repl->nentries);
-			audit_log_end(ab);
+		if(!audit_dummy_context()) {
+			ab = audit_log_start(current->audit_context, GFP_KERNEL,
+					     AUDIT_NETFILTER_CFG);
+			if (ab) {
+				audit_log_format(ab, "family=%u table=%s entries=%u",
+						 AF_BRIDGE, repl->name,
+						 repl->nentries);
+				audit_log_end(ab);
+			}
+		} else if(repl->nentries) {
+			ab = audit_log_start(NULL, GFP_KERNEL,
+					     AUDIT_NETFILTER_CFGSOLO);
+			if (ab) {
+				audit_log_task(ab);
+				audit_log_format(ab, " family=%u table=%s entries=%u",
+						 AF_BRIDGE, repl->name,
+						 repl->nentries);
+				audit_log_end(ab);
+			}
 		}
 	}
 #endif
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 99c27ed..8d28fff 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1195,13 +1195,25 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
 	if (audit_enabled) {
 		struct audit_buffer *ab;
 
-		ab = audit_log_start(current->audit_context, GFP_KERNEL,
-				     AUDIT_NETFILTER_CFG);
-		if (ab) {
-			audit_log_format(ab, "table=%s family=%u entries=%u",
-					 table->name, table->af,
-					 private->number);
-			audit_log_end(ab);
+		if(!audit_dummy_context()) {
+			ab = audit_log_start(current->audit_context, GFP_KERNEL,
+					     AUDIT_NETFILTER_CFG);
+			if (ab) {
+				audit_log_format(ab, "family=%u table=%s entries=%u",
+						 table->af, table->name,
+						 private->number);
+				audit_log_end(ab);
+			}
+		} else if(private->stacksize || private->number || private->initial_entries) {
+			ab = audit_log_start(NULL, GFP_KERNEL,
+					     AUDIT_NETFILTER_CFGSOLO);
+			if (ab) {
+				audit_log_task(ab);
+				audit_log_format(ab, " family=%u table=%s entries=%u",
+						 table->af, table->name,
+						 private->number);
+				audit_log_end(ab);
+			}
 		}
 	}
 #endif
-- 
1.7.1

