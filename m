From: achurch@achurch.org (Andrew Church)
Subject: [PATCH] Fix oops on bad entry list
Date: Wed, 19 Jun 2002 09:57:31 JST
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3d0fd9cc.63276@achurch.org>
Content-Type: text/plain; charset=ISO-2022-JP
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

[Note: I am not subscribed to netfilter-devel; please CC me on any replies]

     The patch below fixes an oops that occurs in Linux kernels
<= 2.4.19-pre10 if an entry list passed to IPT_SO_SET_REPLACE contains an
entry with a jump to an invalid position (into the middle of another entry
or outside the list).

  --Andrew Church
    achurch@achurch.org
    http://achurch.org/

--- net/ipv4/netfilter/ip_tables.c.old	Fri Jun  7 11:50:39 2002
+++ net/ipv4/netfilter/ip_tables.c	Wed Jun 19 09:49:01 2002
@@ -739,6 +739,7 @@
 			   unsigned int *i)
 {
 	unsigned int h;
+	struct ipt_standard_target *t;
 
 	if ((unsigned long)e % __alignof__(struct ipt_entry) != 0
 	    || (unsigned char *)e + sizeof(struct ipt_entry) >= limit) {
@@ -751,6 +752,35 @@
 		duprintf("checking: element %p size %u\n",
 			 e, e->next_offset);
 		return -EINVAL;
+	}
+
+	if (e->target_offset + sizeof(struct ipt_entry_target)
+	    >= e->next_offset) {
+		duprintf("checking: element %p size %u target %u\n",
+			 e, e->next_offset, e->target_offset);
+		return -EINVAL;
+	}
+
+	/* If the target is another chain, make sure the pointer is valid */
+	t = (void *)ipt_get_target(e);
+	if (strcmp(t->target.u.user.name, IPT_STANDARD_TARGET) == 0
+	    && t->verdict >= 0) {
+		int checkpos = 0;
+		if (t->verdict >= newinfo->size) {
+			duprintf("checking: element %p: jump target %u"
+				 " out of range", e, t->verdict);
+			return -EINVAL;
+		}
+		while (checkpos < t->verdict) {
+			struct ipt_entry *e2;
+			e2 = (void *)newinfo->entries + checkpos;
+			checkpos += e2->next_offset;
+		}
+		if (checkpos > t->verdict) {
+			duprintf("checking: element %p: jump target %u"
+				 " invalid", e, t->verdict);
+			return -EINVAL;
+		}
 	}
 
 	/* Check hooks & underflows */
