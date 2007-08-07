From: Greg KH <gregkh@suse.de>
Subject: [2.6.22.2 review 81/84] Netfilter: Fix logging regression
Date: Tue, 7 Aug 2007 13:49:36 -0700
Message-ID: <20070807204936.GE23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Justin Forbes <jmforbes@linuxtx.org>, Domenico Andreoli <cavokz@gmail.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, Patrick McHardy <kaber@trash.net>,
	Randy Dunlap <rdunlap@xenotime.net>, Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline; filename="netfilter-fix-logging-regression.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
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

From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: Fix logging regression

Loading one of the LOG target fails if a different target has already
registered itself as backend for the same family. This can affect the
ipt_LOG and ipt_ULOG modules when both are loaded.

Reported and tested by: <t.artem@mailcity.com>
Upstream-commit: 7e2acc7e

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/netfilter/ebt_log.c  |    6 ++----
 net/bridge/netfilter/ebt_ulog.c |    8 ++------
 net/ipv4/netfilter/ipt_LOG.c    |    6 ++----
 net/ipv6/netfilter/ip6t_LOG.c   |    6 ++----
 4 files changed, 8 insertions(+), 18 deletions(-)

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

-- 
