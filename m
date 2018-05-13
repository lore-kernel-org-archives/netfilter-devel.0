From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak81 RFC V2 1/5] audit: normalize loginuid read access
Date: Sat, 12 May 2018 21:58:18 -0400
Message-ID: <33f131a40a50bd7532ed74ff51e3da920e9e8df5.1526173613.git.rgb@redhat.com>
References: <cover.1526173613.git.rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
To: Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        Linux Security Module list
        <linux-security-module@vger.kernel.org>,
        Integrity Measurement Architecture
        <linux-integrity@vger.kernel.org>,
        SElinux list <selinux@tycho.nsa.gov>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1526173613.git.rgb@redhat.com>
In-Reply-To: <cover.1526173613.git.rgb@redhat.com>
References: <cover.1526173613.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Recognizing that the loginuid is an internal audit value, use an access
function to retrieve the audit loginuid value for the task rather than
reaching directly into the task struct to get it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 479c031..0d4e269 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -374,7 +374,7 @@ static int audit_field_compare(struct task_struct *tsk,
 	case AUDIT_COMPARE_EGID_TO_OBJ_GID:
 		return audit_compare_gid(cred->egid, name, f, ctx);
 	case AUDIT_COMPARE_AUID_TO_OBJ_UID:
-		return audit_compare_uid(tsk->loginuid, name, f, ctx);
+		return audit_compare_uid(audit_get_loginuid(tsk), name, f, ctx);
 	case AUDIT_COMPARE_SUID_TO_OBJ_UID:
 		return audit_compare_uid(cred->suid, name, f, ctx);
 	case AUDIT_COMPARE_SGID_TO_OBJ_GID:
@@ -385,7 +385,7 @@ static int audit_field_compare(struct task_struct *tsk,
 		return audit_compare_gid(cred->fsgid, name, f, ctx);
 	/* uid comparisons */
 	case AUDIT_COMPARE_UID_TO_AUID:
-		return audit_uid_comparator(cred->uid, f->op, tsk->loginuid);
+		return audit_uid_comparator(cred->uid, f->op, audit_get_loginuid(tsk));
 	case AUDIT_COMPARE_UID_TO_EUID:
 		return audit_uid_comparator(cred->uid, f->op, cred->euid);
 	case AUDIT_COMPARE_UID_TO_SUID:
@@ -394,11 +394,11 @@ static int audit_field_compare(struct task_struct *tsk,
 		return audit_uid_comparator(cred->uid, f->op, cred->fsuid);
 	/* auid comparisons */
 	case AUDIT_COMPARE_AUID_TO_EUID:
-		return audit_uid_comparator(tsk->loginuid, f->op, cred->euid);
+		return audit_uid_comparator(audit_get_loginuid(tsk), f->op, cred->euid);
 	case AUDIT_COMPARE_AUID_TO_SUID:
-		return audit_uid_comparator(tsk->loginuid, f->op, cred->suid);
+		return audit_uid_comparator(audit_get_loginuid(tsk), f->op, cred->suid);
 	case AUDIT_COMPARE_AUID_TO_FSUID:
-		return audit_uid_comparator(tsk->loginuid, f->op, cred->fsuid);
+		return audit_uid_comparator(audit_get_loginuid(tsk), f->op, cred->fsuid);
 	/* euid comparisons */
 	case AUDIT_COMPARE_EUID_TO_SUID:
 		return audit_uid_comparator(cred->euid, f->op, cred->suid);
@@ -611,7 +611,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 				result = match_tree_refs(ctx, rule->tree);
 			break;
 		case AUDIT_LOGINUID:
-			result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
+			result = audit_uid_comparator(audit_get_loginuid(tsk), f->op, f->uid);
 			break;
 		case AUDIT_LOGINUID_SET:
 			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
@@ -2281,14 +2281,14 @@ int audit_signal_info(int sig, struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct task_struct *tsk = current;
 	struct audit_context *ctx = tsk->audit_context;
-	kuid_t uid = current_uid(), t_uid = task_uid(t);
+	kuid_t uid = current_uid(), auid, t_uid = task_uid(t);
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
 	     sig == SIGUSR1 || sig == SIGUSR2)) {
 		audit_sig_pid = task_tgid_nr(tsk);
-		if (uid_valid(tsk->loginuid))
-			audit_sig_uid = tsk->loginuid;
+		if (uid_valid(auid = audit_get_loginuid(tsk)))
+			audit_sig_uid = auid;
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(tsk, &audit_sig_sid);
-- 
1.8.3.1
