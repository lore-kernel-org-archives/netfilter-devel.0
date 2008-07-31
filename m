From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Thu, 31 Jul 2008 10:36:04 +0200
Message-ID: <48917974.3090304@netfilter.org>
References: <48904A9F.8010509@netfilter.org> <48904C3B.7060004@trash.net> <48905083.1040002@netfilter.org> <4890519C.80407@netfilter.org> <48906E10.9020902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020800020707080708070104"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55118 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752494AbYGaIgR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:36:17 -0400
In-Reply-To: <48906E10.9020902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020800020707080708070104
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Sorry, it's wrong. Please, take this.
> 
>> @@ -1672,9 +1660,24 @@ ctnetlink_create_expect(struct nlattr *c
>>      help = nfct_help(ct);
>>  
>>      if (!help || !help->helper) {
>> -        /* such conntrack hasn't got any helper, abort */
>> +#ifdef CONFIG_KMOD
>> +        char *name;
>> +
>>          err = -EINVAL;
>> +        if (!cda[CTA_EXPECT_HELP_NAME])
>> +            goto out;
>> +
>> +        err = -ENOTSUPP;
>> +        name = nla_data(cda[CTA_EXPECT_HELP_NAME]);
>> +        if (request_module("nfct-helper-%s", name) < 0)
>> +            goto out;
>> +
>> +        if (nf_ct_set_helper(ct, GFP_KERNEL) < 0)
>> +            goto out;
> 
> This strikes me as quite inconsistent. First, we only perform
> autoloading for expectation creation, but not for conntracks.

The module autoloading for conntracks is tricky, it's easy to add for
the creation case, but I don't see a sane way to do this in the update
case because of the spin lock that we hold most of the time.

The only idea that comes to my mind is to do the module load-on-demand
in a very early stage - just after the tuple parsing in the
new_conntrack function - but then we'll have to do another look up for
the helper inside the change_helper function - that would make two
invocations of find_byname() to assign the helper.

Moreover, someone may remove the module in the middle just after the
module loading but, well, we have lost the race in the case.

> Second, this implicit helper assignment is also a bit unusual,
> why don't we simply insist that the conntrack has a helper
> assigned through the ctnetlink conntrack interface?

If I understood well, then we simply assign the helper to the conntrack
and the expectation part of ctnetlink should rely on the existing
assigned helper, right?

Please, have a look at the patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------020800020707080708070104
Content-Type: text/x-diff;
 name="03.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.patch"

[PATCH] Helper modules load-on-demand support for ctnetlink

This patch adds module loading for helpers via ctnetlink. We perform
the module loading before we enter the spin lock area. Thus, the number
of lookups to assign a helper is two: one to check if the helper is
present and one to assign it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-31 10:15:37.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-31 10:33:13.000000000 +0200
@@ -1203,6 +1203,35 @@ ctnetlink_new_conntrack(struct sock *ctn
 			return err;
 	}
 
+	if (cda[CTA_HELP]) {
+		const struct nf_conntrack_helper *helper;
+		char *helpname;
+
+		err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
+		if (err < 0)
+			return err;
+
+		rcu_read_lock();
+		helper = __nf_conntrack_helper_find_byname(helpname);
+		if (helper == NULL) {
+			rcu_read_unlock();
+#ifdef CONFIG_KMOD
+			if (request_module("nfct-helper-%s", helpname) < 0)
+				return -EOPNOTSUPP;
+
+			rcu_read_lock();
+			helper = __nf_conntrack_helper_find_byname(helpname);
+			if (helper == NULL) {
+				rcu_read_unlock();
+				return -EOPNOTSUPP;
+			}
+#else
+			return -EOPNOTSUPP;
+#endif
+		}
+		rcu_read_unlock();
+	}
+
 	spin_lock_bh(&nf_conntrack_lock);
 	if (cda[CTA_TUPLE_ORIG])
 		h = __nf_conntrack_find(&otuple);

--------------020800020707080708070104--
