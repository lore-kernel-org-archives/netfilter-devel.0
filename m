From: Patrick McHardy <kaber@trash.net>
Subject: [RFC][PATCH]: match supplementary gids in owner match
Date: Thu, 17 Jul 2003 15:38:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F16A6E6.8060900@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060400070909060805070703"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060400070909060805070703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds support for matching supplementary gids to the owner match.
I wrote it for someone else, i haven't even tested it. According to him, 
it works as
expected. If someone likes it, feel free to add to pom. I was thinking 
about making
an extra flag so normal behaviour would be as before and matching 
supplementary
gid matching would be optional. If someone wants this, just tell me.

Bye
Patrick

--------------060400070909060805070703
Content-Type: text/plain;
 name="ipt_owner-supgids.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_owner-supgids.diff"

===== net/ipv4/netfilter/ipt_owner.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ipt_owner.c	Thu Aug  8 16:55:29 2002
+++ edited/net/ipv4/netfilter/ipt_owner.c	Mon Jul 14 19:25:36 2003
@@ -109,6 +109,49 @@
 }
 
 static int
+match_gid(const struct sk_buff *skb, gid_t gid)
+{
+	struct task_struct *p;
+	struct files_struct *files;
+	int i;
+
+	/* direct match */
+	if (gid == skb->sk->socket->file->f_gid)
+		return 1;
+
+	/* find owner of socket and check supplementary gids */
+	read_lock(&tasklist_lock);
+	for_each_task(p) {
+		/* racy, owner could have called setfsgid */
+		if (p->fsgid != skb->sk->socket->file->f_gid)
+			continue;
+
+		task_lock(p);
+		files = p->files;
+		if(files) {
+			read_lock(&files->file_lock);
+			for (i=0; i < files->max_fds; i++) {
+				if (fcheck_files(files, i) == skb->sk->socket->file) {
+					int j, ret = 0;
+					read_unlock(&files->file_lock);
+					for (j = 0; j < p->ngroups; j++)
+						if (p->groups[j] == gid) {
+							ret = 1;
+							break;
+						}
+					task_unlock(p);
+					read_unlock(&tasklist_lock);
+					return ret;
+				}
+			}
+			read_unlock(&files->file_lock);
+		}
+		task_unlock(p);
+	}
+	read_unlock(&tasklist_lock);
+	return 0;
+}
+static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -130,7 +173,7 @@
 	}
 
 	if(info->match & IPT_OWNER_GID) {
-		if((skb->sk->socket->file->f_gid != info->gid) ^
+		if(!match_gid(skb, info->gid) ^
 		    !!(info->invert & IPT_OWNER_GID))
 			return 0;
 	}

--------------060400070909060805070703--
