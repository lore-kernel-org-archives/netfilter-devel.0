From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: nfnetlink_log and trace problems [was Re: [RFC] nft trace]
Date: Mon, 2 Mar 2015 01:10:28 +0100
Message-ID: <20150302001028.GA3978@salvia>
References: <54F35515.5050807@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Markus =?iso-8859-1?Q?K=F6tter?= <koetter@rrzn.uni-hannover.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54471 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbbCBAGw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2015 19:06:52 -0500
Content-Disposition: inline
In-Reply-To: <54F35515.5050807@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Mar 01, 2015 at 07:06:13PM +0100, Markus Kötter wrote:
[...]
> None of this works with current kernels, as changes to the netlink
> logging infrastructure in v3.17 prevent TRACE messages from being
> relayed to netlink.
> I filed a report here:
> http://bugzilla.netfilter.org/show_bug.cgi?id=1003
> 
> Using NULL as nf_loginfo works for me (messages end up in group 0 as
> before) [...]

It seems we cannot pass NULL since it will default on log level 5
instead of 4, and I think there may be users relying on that too.

I'm attaching a patch to address this problem.

Thanks for reporting.

--X1bOJ3K7DJ5YkBrT
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-netfilter-restore-rule-tracing-via-nfnetlink_log.patch"
Content-Transfer-Encoding: 8bit

>From adab0dd4789936495bb2f0d6892ad26437ebb31e Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 2 Mar 2015 01:04:55 +0100
Subject: [PATCH] netfilter: restore rule tracing via nfnetlink_log
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since fab4085 ("netfilter: log: nf_log_packet() as real unified
interface"), the loginfo structure that is passed to nf_log_packet()
is used to explicitly indicate the logger type you want to use.

This is a problem for people tracing rules through nfnetlink_log since
packets are always routed to the NF_LOG_TYPE logger after the
aforementioned patch.

We can fix this by removing the trace loginfo structures, but that still
changes the log level from 4 to 5 for tracing messages and there may be
someone relying on this outthere. So let's just introduce some compat
code to restore the former behaviour.

Reported-by: Markus Kötter <koetter@rrzn.uni-hannover.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_log.h  |   10 ++++++++++
 net/ipv4/netfilter/ip_tables.c  |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 net/netfilter/nf_log.c          |   25 +++++++++++++++++++++++++
 net/netfilter/nf_tables_core.c  |    2 +-
 5 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 534e1f2..b11f2a0 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -79,6 +79,16 @@ void nf_log_packet(struct net *net,
 		   const struct nf_loginfo *li,
 		   const char *fmt, ...);
 
+__printf(8, 9)
+void nf_log_compat(struct net *net,
+		   u_int8_t pf,
+		   unsigned int hooknum,
+		   const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   const struct nf_loginfo *li,
+		   const char *fmt, ...);
+
 struct nf_log_buf;
 
 struct nf_log_buf *nf_log_buf_open(void);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 99e810f..b438ab5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -272,7 +272,7 @@ static void trace_packet(const struct sk_buff *skb,
 		    &chainname, &comment, &rulenum) != 0)
 			break;
 
-	nf_log_packet(net, AF_INET, hook, skb, in, out, &trace_loginfo,
+	nf_log_compat(net, AF_INET, hook, skb, in, out, &trace_loginfo,
 		      "TRACE: %s:%s:%s:%u ",
 		      tablename, chainname, comment, rulenum);
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e080fbb..fdfe86b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -298,7 +298,7 @@ static void trace_packet(const struct sk_buff *skb,
 		    &chainname, &comment, &rulenum) != 0)
 			break;
 
-	nf_log_packet(net, AF_INET6, hook, skb, in, out, &trace_loginfo,
+	nf_log_compat(net, AF_INET6, hook, skb, in, out, &trace_loginfo,
 		      "TRACE: %s:%s:%s:%u ",
 		      tablename, chainname, comment, rulenum);
 }
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 0d8448f..d6d2254 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -212,6 +212,31 @@ void nf_log_packet(struct net *net,
 }
 EXPORT_SYMBOL(nf_log_packet);
 
+void nf_log_compat(struct net *net,
+		   u_int8_t pf,
+		   unsigned int hooknum,
+		   const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   const struct nf_loginfo *loginfo, const char *fmt, ...)
+{
+	va_list args;
+	char prefix[NF_LOG_PREFIXLEN];
+	const struct nf_logger *logger;
+
+	rcu_read_lock();
+	logger = rcu_dereference(net->nf.nf_loggers[pf]);
+
+	if (logger) {
+		va_start(args, fmt);
+		vsnprintf(prefix, sizeof(prefix), fmt, args);
+		va_end(args);
+		logger->logfn(net, pf, hooknum, skb, in, out, loginfo, prefix);
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nf_log_compat);
+
 #define S_SIZE (1024 - (sizeof(unsigned int) + 1))
 
 struct nf_log_buf {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 3b90eb2..7c9f3ec 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -94,7 +94,7 @@ static void nft_trace_packet(const struct nft_pktinfo *pkt,
 {
 	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
 
-	nf_log_packet(net, pkt->xt.family, pkt->ops->hooknum, pkt->skb, pkt->in,
+	nf_log_compat(net, pkt->xt.family, pkt->ops->hooknum, pkt->skb, pkt->in,
 		      pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
 		      chain->table->name, chain->name, comments[type],
 		      rulenum);
-- 
1.7.10.4


--X1bOJ3K7DJ5YkBrT--
