From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] small typecast fix for ip_tables.h
Date: Sun, 11 Apr 2004 17:15:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404111715.23375.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LEWeAEp/0WF1vg9"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_LEWeAEp/0WF1vg9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

attached is a patch to fix a typecast in ip_tables.h.
(Found this one while experimenting with C++ compilation)

Cheers,
Thomas

--Boundary-00=_LEWeAEp/0WF1vg9
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="iptables-header-typecast.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-header-typecast.patch"

--- ip_tables.h.old	Sun Apr 11 16:39:56 2004
+++ ip_tables.h	Sun Apr 11 16:37:38 2004
@@ -300,7 +300,7 @@
 static __inline__ struct ipt_entry_target *
 ipt_get_target(struct ipt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct ipt_entry_target *)e + e->target_offset;
 }
 
 /* fn returns 0 to continue iteration */

--Boundary-00=_LEWeAEp/0WF1vg9--
