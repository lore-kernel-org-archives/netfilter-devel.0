From: Phil Oester <phil@linuxace.com>
Subject: [PATCH] conntrack match typo
Date: Sat, 21 Aug 2004 14:54:19 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040821215419.GA29488@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Status option should use IPT_CONNTRACK_STATUS, not IPT_CONNTRACK_STATE.
Originally noticed by M. J. Pomraning. 

This fixes bug #194

Phil
 

diff -ru ipt-orig/extensions/libipt_conntrack.c ipt-new/extensions/libipt_conntrack.c
--- ipt-orig/extensions/libipt_conntrack.c      2004-06-14 18:02:17.000000000 -0400
+++ ipt-new/extensions/libipt_conntrack.c       2004-08-21 17:51:05.507406408 -0400
@@ -492,7 +492,7 @@
 
        if(sinfo->flags & IPT_CONNTRACK_STATUS) {
                printf("%sctstatus ", optpfx);
-               if (sinfo->invflags & IPT_CONNTRACK_STATE)
+               if (sinfo->invflags & IPT_CONNTRACK_STATUS)
                        printf("! ");
                print_status(sinfo->statusmask);
        }
