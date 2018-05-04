From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak81 RFC V1 1/5] audit: normalize loginuid read access
Date: Fri,  4 May 2018 16:54:34 -0400
Message-ID: <611e9c85fca8bcdb24e6fb6da412773663c007b3.1525466167.git.rgb@redhat.com>
References: <cover.1525466167.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Guy Briggs <rgb@redhat.com>, David Howells <dhowells@redhat.com>,
	Ingo Molnar <mingo@redhat.com>
To: Linux-Audit Mailing List <linux-audit@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
	Netfilter Devel List <netfilter-devel@vger.kernel.org>,
	Linux Security Module list <linux-security-module@vger.kernel.org>,
	Integrity Measurement Architecture <linux-integrity@vger.kernel.org>,
	SElinux list <selinux@tycho.nsa.gov>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <cover.1525466167.git.rgb@redhat.com>
In-Reply-To: <cover.1525466167.git.rgb@redhat.com>
References: <cover.1525466167.git.rgb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

Recognizing that the loginuid is an internal audit value, use an access
function to retrieve the audit loginuid value for the task rather than
reaching directly into the task struct to get it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 479c031..f3817d0 100644
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
@@ -2287,8 +2287,8 @@ int audit_signal_info(int sig, struct task_struct *t)
 	    (sig == SIGTERM || sig == SIGHUP ||
 	     sig == SIGUSR1 || sig == SIGUSR2)) {
 		audit_sig_pid = task_tgid_nr(tsk);
-		if (uid_valid(tsk->loginuid))
-			audit_sig_uid = tsk->loginuid;
+		if (uid_valid(audit_get_loginuid(tsk)))
+			audit_sig_uid = audit_get_loginuid(tsk);
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(tsk, &audit_sig_sid);
-- 
1.8.3.1
