From: Henrik Nordstrom <hno@marasystems.com>
Subject: ctnetlink & helper_locking_fix conflict
Date: Tue, 9 Nov 2004 08:13:33 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411090808200.30695@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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

Hi,

there is a conflict between the above two patches. The helper_locking_fix 
removes the locks from the helpers, but ctnetlink adds code using these 
locks.

>From reading the code I think the helper side locking should be removed 
from the ctnetlink additions as well, but just wanted to verify with you.

Example of the offending code (ip_conntrack_irc.c, and many more):

+static void ctnl_change(struct ip_conntrack *ct, union ip_conntrack_help 
*h)
+{
+	LOCK_BH(&ip_irc_lock);
+	memcpy(&ct->help, h, sizeof(ct->help));
+	UNLOCK_BH(&ip_irc_lock);
+}
+
+static void ctnl_new_expect(struct ip_conntrack_expect *exp,
+                            union ip_conntrack_expect_proto *p,
+                            union ip_conntrack_expect_help *h)
+{
+	if (h == NULL)
+		return;
+	LOCK_BH(&ip_irc_lock);
+	memcpy(&exp->help, h, sizeof(exp->help));
+	UNLOCK_BH(&ip_irc_lock);
+}
+

where ip_irc_lock was killed by helper_locking_fix.


Regards
Henrik
