From: Raivis Bucis <raivis@mt.lv>
Subject: kernel crash [problem with helpers]
Date: Wed, 26 May 2004 14:12:32 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405261412.32587.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

ip_conntrack assumes that expect->expectant->helper allways will be non null, 
but that is not allways the case.

When tftp conntrack is used, on first received UDP packet, tfp helper adds 
expectation. If it gets NATed later to some other port, 
ip_conntrack_alter_reply will set its helper to NULL, but expectation is 
still kept, and when expected conntrack is created, its master conntrack 
doesn't have helper anymore. This leads to kernel oops in list_conntracks 
when reading "/proc/net/ip_conntrack", etc.

Therefore I propose following fix:

diff -u -r1.13 ip_conntrack_core.c
--- ip_conntrack_core.c 9 Jan 2004 07:52:10 -0000       1.13
+++ ip_conntrack_core.c 26 May 2004 11:05:23 -0000
@@ -1139,10 +1139,13 @@
        DUMP_TUPLE(newreply);

        conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-       if (!conntrack->master)
-               conntrack->helper = LIST_FIND(&helpers, helper_cmp,
-                                             struct ip_conntrack_helper *,
-                                             newreply);
+       if (!conntrack->master) {
+               struct ip_conntrack_helper *newhelper;
+               newhelper = LIST_FIND(&helpers, helper_cmp,
+                                     struct ip_conntrack_helper *,
+                                     newreply);
+               if (newhelper) conntrack->helper = newhelper;
+       }
        WRITE_UNLOCK(&ip_conntrack_lock);

        return 1;


Or maybe, we should check whether it has expectations before looking for new 
helper.

Raivis Bucis
