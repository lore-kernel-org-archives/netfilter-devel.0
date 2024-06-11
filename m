Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E79173320;
	Tue, 11 Jun 2024 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718092728; cv=none; b=p/Ajnku+Rlg1pYbyaHuaXGAEgG0haW2uq+xOfXX5HKQAGyyLcZFZiX2rbQHX4TeEac18nkFyGNvgjB5/qYTkqaqj3x7aPS9CFNxgy0/7LNKlvNMrYotcydvbUsRFTTE5Uzdb1iffzXgcaaCP/L/fKo2DFpeA4vF+nVwun5OC7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718092728; c=relaxed/simple;
	bh=CS7CMvTxSk7CyhSPH+19x6CjS6eE7Q7coTMCFgaeI+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRa9/j05VOWgZ9rOEyGfFMiXFdaoDPv8PTDTaHyEF1vulxMyqOpCTzxW5hKrfsQymXwVrTdM3ZGbgQcF4iGO3eG/PGQP8r+L0lYGk++bQdJiEPNDmadVLXt0bb9PTpb2GdJc8Yt7FUxdITKvD053fBNQ43e6udqEADg4I9LAI0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZOTj1mSF; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZOTj1mSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=yoRsE3XMCqVssz/yXETnkP2iLCRZh1VO87wImbfmzoE=;
	b=ZOTj1mSFWeu190IXHKw2QR3wN2OPtUQezhvlRlRDMKY7WUg6jHQfrOrDOlu7rK
	L3CDXag8zzpVLppKYsiW6mqVBM9lj+8QpAgMCTLQB+PAVRY4lZf3izdBIGNnbypR
	2+csc/fmmPHpaUJ9Kdiy0OyEZzQkXAPhpLT+Xy1PqS9Dk=
Received: from [172.22.5.12] (unknown [27.148.194.72])
	by gzga-smtp-mta-g1-3 (Coremail) with SMTP id _____wA3PymGA2hmh78JHw--.60394S2;
	Tue, 11 Jun 2024 15:57:59 +0800 (CST)
Message-ID: <f30a9a63-5189-42d4-96e1-09f64a4fea37@163.com>
Date: Tue, 11 Jun 2024 15:58:02 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 2/3] selftests: add selftest for the SRv6 End.DX4
 behavior with netfilter
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jakub Kicinski <kuba@kernel.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>, wujianguo
 <wujianguo@chinatelecom.cn>, netdev@vger.kernel.org, edumazet@google.com,
 contact@proelbtn.com, dsahern@kernel.org, pabeni@redhat.com,
 netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20240604144949.22729-1-wujianguo@chinatelecom.cn>
 <20240604144949.22729-3-wujianguo@chinatelecom.cn>
 <Zl_OWcrrEipnN_VP@Laptop-X1> <eaf06c77-2457-46fc-aaf1-fb5ae0080072@163.com>
 <20240605173532.304798bd@kernel.org> <ZmEapORjk3v3FYke@Laptop-X1>
 <20240605192309.591dfedb@kernel.org> <ZmFNSbHqOF96LtVO@calendula>
From: Jianguo Wu <wujianguo106@163.com>
In-Reply-To: <ZmFNSbHqOF96LtVO@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wA3PymGA2hmh78JHw--.60394S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xr15tF4Dtw1DuF4fJFyDtrb_yoWfWF4UpF
	s8G3y3tr4UWF1Yyw4vkryIvFnxtrZ3Ga4j9r98C34rAwnFgw1UGa1Skay7WanrWrWDtrW3
	AF1Utw13Zws8t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UOzV8UUUUU=
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiRAr6kGVODLAC+QAAsI

Hi, Pablo

On 2024/6/6 13:46, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Wed, Jun 05, 2024 at 07:23:09PM -0700, Jakub Kicinski wrote:
>> On Thu, 6 Jun 2024 10:10:44 +0800 Hangbin Liu wrote:
>>>> Please follow the instructions from here:
>>>> https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
>>>> the kernel we build for testing is minimal.
>>>>
>>>> We see this output:
>>>>
>>>> # ################################################################################
>>>> # TEST SECTION: SRv6 VPN connectivity test with netfilter enabled in routers
>>>> # ################################################################################  
>>>
>>> If I run the test specifically, I also got error:
>>> sysctl: cannot stat /proc/sys/net/netfilter/nf_hooks_lwtunnel: No such file or directory
>>>
>>> This is because CONFIG_NF_CONNTRACK is build as module. The test need to load
>>> nf_conntrack specifically. I guest the reason you don't have this error is
>>> because you have run the netfilter tests first? Which has loaded this module.
> 
> Hm, this dependency with conntrack does not look good. This sysctl
> nf_hooks_lwtunnel should be in the netfilter core. The connection
> tracking gets loaded on demand, the availability of this sysctl is
> fragile.
> 

How about this?


[PATCH] netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core

Currently, the sysctl net.netfilter.nf_hooks_lwtunnel depends on the
nf_conntrack module, but the nf_conntrack module is not always loaded.
Therefore, accessing net.netfilter.nf_hooks_lwtunnel may have an error.

Move sysctl nf_hooks_lwtunnel into the netfilter core.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 include/net/netns/netfilter.h           |  3 ++
 net/netfilter/core.c                    | 13 ++++++-
 net/netfilter/nf_conntrack_standalone.c | 15 --------
 net/netfilter/nf_hooks_lwtunnel.c       | 68 +++++++++++++++++++++++++++++++++
 net/netfilter/nf_internals.h            |  6 +++
 5 files changed, 88 insertions(+), 17 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 02bbdc5..a6a0bf4 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -15,6 +15,9 @@ struct netns_nf {
 	const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *nf_log_dir_header;
+#ifdef CONFIG_LWTUNNEL
+	struct ctl_table_header *nf_lwtnl_dir_header;
+#endif
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3126911..b00fc28 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -815,12 +815,21 @@ int __init netfilter_init(void)
 	if (ret < 0)
 		goto err;

+#ifdef CONFIG_LWTUNNEL
+	ret = netfilter_lwtunnel_init();
+	if (ret < 0)
+		goto err_lwtunnel_pernet;
+#endif
 	ret = netfilter_log_init();
 	if (ret < 0)
-		goto err_pernet;
+		goto err_log_pernet;

 	return 0;
-err_pernet:
+err_log_pernet:
+#ifdef CONFIG_LWTUNNEL
+	netfilter_lwtunnel_fini();
+err_lwtunnel_pernet:
+#endif
 	unregister_pernet_subsys(&netfilter_net_ops);
 err:
 	return ret;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 74112e9..6c40bdf 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -22,9 +22,6 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
-#ifdef CONFIG_LWTUNNEL
-#include <net/netfilter/nf_hooks_lwtunnel.h>
-#endif
 #include <linux/rculist_nulls.h>

 static bool enable_hooks __read_mostly;
@@ -612,9 +609,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
 #endif
-#ifdef CONFIG_LWTUNNEL
-	NF_SYSCTL_CT_LWTUNNEL,
-#endif

 	NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -946,15 +940,6 @@ enum nf_ct_sysctl_index {
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 #endif
-#ifdef CONFIG_LWTUNNEL
-	[NF_SYSCTL_CT_LWTUNNEL] = {
-		.procname	= "nf_hooks_lwtunnel",
-		.data		= NULL,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
-	},
-#endif
 };

 static struct ctl_table nf_ct_netfilter_table[] = {
diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 00e89ff..11712d2 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -3,6 +3,9 @@
 #include <linux/sysctl.h>
 #include <net/lwtunnel.h>
 #include <net/netfilter/nf_hooks_lwtunnel.h>
+#include <linux/netfilter.h>
+
+#include "nf_internals.h"

 static inline int nf_hooks_lwtunnel_get(void)
 {
@@ -50,4 +53,69 @@ int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
+
+static struct ctl_table nf_lwtunnel_sysctl_table[] = {
+	{
+		.procname	= "nf_hooks_lwtunnel",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
+	},
+	{},
+};
+
+static int nf_lwtunnel_net_init(struct net *net)
+{
+	struct ctl_table *table;
+	struct ctl_table_header *hdr;
+
+	table = nf_lwtunnel_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(nf_lwtunnel_sysctl_table,
+				sizeof(nf_lwtunnel_sysctl_table),
+				GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
+
+	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
+				     ARRAY_SIZE(nf_lwtunnel_sysctl_table));
+	if (!hdr)
+		goto err_reg;
+
+	net->nf.nf_lwtnl_dir_header = hdr;
+	return 0;
+
+err_reg:
+	if (!net_eq(net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static void __net_exit nf_lwtunnel_net_exit(struct net *net)
+{
+	const struct ctl_table *table;
+
+	table = net->nf.nf_lwtnl_dir_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->nf.nf_lwtnl_dir_header);
+	if (!net_eq(net, &init_net))
+		kfree(table);
+}
+
+static struct pernet_operations nf_lwtunnel_net_ops = {
+	.init = nf_lwtunnel_net_init,
+	.exit = nf_lwtunnel_net_exit,
+};
+
+int __init netfilter_lwtunnel_init(void)
+{
+	return register_pernet_subsys(&nf_lwtunnel_net_ops);
+}
+
+void __exit netfilter_lwtunnel_fini(void)
+{
+	unregister_pernet_subsys(&nf_lwtunnel_net_ops);
+}
 #endif /* CONFIG_SYSCTL */
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 832ae64..5c281b7 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -29,6 +29,12 @@
 /* nf_log.c */
 int __init netfilter_log_init(void);

+#ifdef CONFIG_LWTUNNEL
+/* nf_hooks_lwtunnel.c */
+int __init netfilter_lwtunnel_init(void);
+void __exit netfilter_lwtunnel_fini(void);
+#endif
+
 /* core.c */
 void nf_hook_entries_delete_raw(struct nf_hook_entries __rcu **pp,
 				const struct nf_hook_ops *reg);
-- 
1.8.3.1


>> Ah, quite possibly, good catch! We don't reboot between tests,
>> and the VM must have run 10 or so other tests before.
>>
>>>> # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
>>>> # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
>>>> # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
>>>> # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING  
>>>
>>> Just checked, we need CONFIG_IP_NF_MATCH_RPFILTER=m in config file.
>>
>> :( Must be lack of compat support then? I CCed netfilter, perhaps they
>> can advise. I wonder if there is a iptables-nftables compatibility list
>> somewhere.
> 
> iptables-nft potentially requires all CONFIG_IP_NF_MATCH_* and
> CONFIG_IP_NF_TARGET_* extensions, in this new testcase it uses
> rpfilter which seems not to be used in any of the existing tests so
> far, that is why CONFIG_IP_NF_MATCH_RPFILTER=m is required.

And this?

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 04de7a6..d4891f7 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -101,3 +101,5 @@ CONFIG_NETFILTER_XT_MATCH_POLICY=m
 CONFIG_CRYPTO_ARIA=y
 CONFIG_XFRM_INTERFACE=m
 CONFIG_XFRM_USER=m
+CONFIG_IP_NF_MATCH_RPFILTER=m
+CONFIG_IP6_NF_MATCH_RPFILTER=m

