From: <gregkh@suse.de>
Subject: patch netfilter-ipt_clusterip-fix-oops-in-checkentry-function.patch
	queued to -stable tree
Date: Wed, 11 Apr 2007 11:53:53 -0700
Message-ID: <20070411185425.7EA0FD1A38C@imap.suse.de>
References: <461B8759.1000507@trash.net>
Cc: stable@kernel.org
To: kaber@trash.net, davem@davemloft.net, gregkh@suse.de,
	netfilter-devel@lists.netfilter.org, perex@suse.cz
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461B8759.1000507@trash.net>
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


This is a note to let you know that we have just queued up the patch titled

     Subject: NETFILTER: ipt_CLUSTERIP: fix oops in checkentry function

to the 2.6.20-stable tree.  Its filename is

     netfilter-ipt_clusterip-fix-oops-in-checkentry-function.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Apr 10 05:49:18 2007
From: Patrick McHardy <kaber@trash.net>
Date: Tue, 10 Apr 2007 14:47:21 +0200
Subject: NETFILTER: ipt_CLUSTERIP: fix oops in checkentry function
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <461B8759.1000507@trash.net>

From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: ipt_CLUSTERIP: fix oops in checkentry function

The clusterip_config_find_get() already increases entries reference
counter, so there is no reason to do it twice in checkentry() callback.

This causes the config to be freed before it is removed from the list,
resulting in a crash when adding the next rule.

Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -411,12 +411,10 @@ checkentry(const char *tablename,
 				       "has invalid config pointer!\n");
 				return 0;
 			}
-			clusterip_config_entry_get(cipinfo->config);
 		} else {
 			/* Case B: This is a new rule referring to an existing
 			 * clusterip config. */
 			cipinfo->config = config;
-			clusterip_config_entry_get(cipinfo->config);
 		}
 	} else {
 		/* Case C: This is a completely new clusterip config */
_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable


Patches currently in stable-queue which might be from kaber@trash.net are
