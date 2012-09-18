From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [RFC] Inter-match communication cache
Date: Tue, 18 Sep 2012 23:01:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:59224 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab2IRVBg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:01:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 944F91F40D0
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Sep 2012 23:01:34 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZEuAe20hYvXG for <netfilter-devel@vger.kernel.org>;
	Tue, 18 Sep 2012 23:01:34 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 7B9B81F40C0
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Sep 2012 23:01:34 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I propose a small cache for inter-match communication purpose:

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8d674a7..f07eab2 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -216,6 +216,9 @@ struct xt_action_param {
 		const void *matchinfo, *targinfo;
 	};
 	const struct net_device *in, *out;
+#ifdef CONFIG_NETFILTER_XTABLES_CACHE
+	u_int32_t cache;
+#endif
 	int fragoff;
 	unsigned int thoff;
 	unsigned int hooknum;
@@ -223,6 +226,15 @@ struct xt_action_param {
 	bool hotdrop;
 };
 
+enum xt_cache_owner {
+	XT_CACHE_OWNER_NONE	= 0,
+	XT_CACHE_OWNER_IPSET	= 1,
+};
+
+#define XT_CACHE_GET_OWNER(cache)	 (((cache) & 0xFF000000) >> 24)
+#define XT_CACHE_SET_OWNER(cache, owner) ((cache) |= (owner) << 24)
+#define XT_CACHE_GET_VALUE(cache)	 ((cache) & 0x00FFFFFF)
+
 /**
  * struct xt_mtchk_param - parameters for match extensions'
  * checkentry functions

The cache makes possible to pass data between matches in a rule or in 
different rules in the same table. Currently there's no easy way to 
communicate between matches.

Long story:

The hash:*net* types of sets of ipset support storing "negated" (nomatch) 
entries in a set, which makes possible to build up exceptions.  For 
example if we want to match all IP addresses from 192.168.0.0/16 except 
192.168.0.0/24 and 192.168.16.0/24 as source addresses, then we could use 
the set

ipset new foo hash:net
ipset add foo 192.168.0.0/16
ipset add foo 192.168.0.0/24 nomatch
ipset add foo 192.168.16.0/24 nomatch

and the rule

iptables ... -m set --match-set foo src -j ...

However, actually we face a three-valued decision when matching an IP
address against such sets:

- Can the IP addess be found in the set as a plain element without a mark?
- Can the IP address be found in the set, but marked with "nomatch"?
- Can the IP address be found in the set at all?

We could get the three different values using two evaluations, which
requires the new flag of the set match coming with the next ipset release:

# 1. Match if the IP address is in the set marked with "nomatch" flag
iptables ... -m set --match-set foo src --return-nomatch -j ...
# 2. Match if the IP address is in the set without the "nomatch" flag
iptables ... -m set --match-set foo src -j ...
# 3. Fall through, no match in the set
...

However, that means two full set evaluation, when actually we already know 
the result at the first match: only we are not capable of branching or 
reusing the result. With the proposed patch the set match could store the 
result at 1. in the cache (MATCH flagged with NOMATCH, MATCH, NONE) and 
the second match at 2. above could reuse it, skipping the full evaluation 
of the set.

I pondered a lot on the possible solutions and the cache seemed to be the 
least intrusive and complex. Please review, all comments are highly 
welcomed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
