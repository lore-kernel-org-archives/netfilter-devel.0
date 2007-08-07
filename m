From: <gregkh@suse.de>
Subject: patch netfilter-fix-logging-regression.patch queued to -stable tree
Date: Tue, 07 Aug 2007 11:43:48 -0700
Message-ID: <20070807184850.3102814458DB@imap.suse.de>
References: <46A7657F.20906@trash.net>
Cc: stable-commits@vger.kernel.org
To: kaber@trash.net, davem@davemloft.net, gregkh@suse.de,
	netfilter-devel@lists.netfilter.org, t.artem@mailcity.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A7657F.20906@trash.net>
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

     Subject: Netfilter: Fix logging regression

to the 2.6.22-stable tree.  Its filename is

     netfilter-fix-logging-regression.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Wed Jul 25 08:01:19 2007
From: Patrick McHardy <kaber@trash.net>
Date: Wed, 25 Jul 2007 17:00:15 +0200
Subject: Netfilter: Fix logging regression
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <46A7657F.20906@trash.net>

From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: Fix logging regression

Loading one of the LOG target fails if a different target has already
registered itself as backend for the same family. This can affect the
ipt_LOG and ipt_ULOG modules when both are loaded.

Reported and tested by: <t.artem@mailcity.com>
Upstream-commit: 7e2acc7e

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -196,10 +196,8 @@ static int __init ebt_log_init(void)
 	ret = ebt_register_watcher(&log);
 	if (ret < 0)
 		return ret;
-	ret = nf_log_register(PF_BRIDGE, &ebt_log_logger);
-	if (ret < 0 && ret != -EEXIST)
-		ebt_unregister_watcher(&log);
-	return ret;
+	nf_log_register(PF_BRIDGE, &ebt_log_logger);
+	return 0;
 }
 
 static void __exit ebt_log_fini(void)
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 9411db6..6fec352 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -308,12 +308,8 @@ static int __init ebt_ulog_init(void)
 	else if ((ret = ebt_register_watcher(&ulog)))
 		sock_release(ebtulognl->sk_socket);
 
-	if (nf_log_register(PF_BRIDGE, &ebt_ulog_logger) < 0) {
-		printk(KERN_WARNING "ebt_ulog: not logging via ulog "
-		       "since somebody else already registered for PF_BRIDGE\n");
-		/* we cannot make module load fail here, since otherwise
-		 * ebtables userspace would abort */
-	}
+	if (ret == 0)
+		nf_log_register(PF_BRIDGE, &ebt_ulog_logger);
 
 	return ret;
 }
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index a42c5cd..361be2b 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -477,10 +477,8 @@ static int __init ipt_log_init(void)
 	ret = xt_register_target(&ipt_log_reg);
 	if (ret < 0)
 		return ret;
-	ret = nf_log_register(PF_INET, &ipt_log_logger);
-	if (ret < 0 && ret != -EEXIST)
-		xt_unregister_target(&ipt_log_reg);
-	return ret;
+	nf_log_register(PF_INET, &ipt_log_logger);
+	return 0;
 }
 
 static void __exit ipt_log_fini(void)
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 5bb9cd3..a7a2517 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -490,10 +490,8 @@ static int __init ip6t_log_init(void)
 	ret = xt_register_target(&ip6t_log_reg);
 	if (ret < 0)
 		return ret;
-	ret = nf_log_register(PF_INET6, &ip6t_logger);
-	if (ret < 0 && ret != -EEXIST)
-		xt_unregister_target(&ip6t_log_reg);
-	return ret;
+	nf_log_register(PF_INET6, &ip6t_logger);
+	return 0;
 }
 
 static void __exit ip6t_log_fini(void)
_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable



Patches currently in stable-queue which might be from kaber@trash.net are

queue-2.6.22/fix-ipcomp-crashes.patch
queue-2.6.22/fix-tc-deadlock.patch
queue-2.6.22/gen-estimator-timer-unload-race.patch
queue-2.6.22/gen-estimator-deadlock-fix.patch
queue-2.6.22/dm-io-fix-panic-on-large-request.patch
queue-2.6.22/nf_conntrack-don-t-track-locally-generated-special-icmp-error.patch
queue-2.6.22/netfilter-fix-logging-regression.patch
