From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: merge registration structure to
 NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 11:35:10 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003311109310.7837@obet.zrqbmnf.qr>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de> <1270022629-2494-5-git-send-email-jengelh@medozas.de> <4BB30861.3060101@trash.net> <alpine.LSU.2.01.1003311036110.4527@obet.zrqbmnf.qr> <4BB30AA0.9000904@trash.net>
 <alpine.LSU.2.01.1003311052490.6475@obet.zrqbmnf.qr> <4BB30F63.2030509@trash.net> <alpine.LSU.2.01.1003311105290.7837@obet.zrqbmnf.qr> <4BB31127.7010409@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56832 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab0CaJfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:35:12 -0400
In-Reply-To: <4BB31127.7010409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-31 11:08, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Wednesday 2010-03-31 11:01, Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>>>> This will work because x_tables scans for NFPROTO_UNSPEC,
>>>>>> and arp/ebtables just using x_tables :-)
>>>>> I'm not sure I'm parsing this correctly. Both will find the match,
>>>>> however the nf_ct_l3proto_try_module_get() call will fail
>>>> It won't fail - it is using par->family, not par->match->family.
>>> That's broken then.
>> 
>> How so?
>
>Because arptables and ebtables shouldn't be able to use this module
>directly. Even less so after a patch stating "merge registration
>structure".

arp/ebtables _couldn't_ even use this module. The simple showstopper:
arp/ebtables simply don't have a corresponding userspace portion for
it. Indeed nf_ct_l3proto_try_module_get(NFPROTO_BRIDGE) does not make
much sense, but, in all honesty, xt_state *is* testing for a
protocol-independent feature, so NFPROTO_UNSPEC is justified IMO.

Also, NFPROTO_BRIDGE is special anyway - it does not refer to an L3
protocol actually, but to L2 - so, well, it's kinda moot to muse
about the possibility of calling nf_ct_get(NFPROTO_BRIDGE). If you
_really_ wanted to support state matching at the ARP/EB level, you
would anyhow have to add a separate ->check function that loads all
possible L3 trackers. Which is not a big problem per se
(see patch - no touching of NFPROTO_UNSPEC was needed).
Or, as an alternate possibility, someone adds a nf_conntrack-proto-bridge
module that is just an empty module depending on nf_conntrack_ipv4 and
_ipv6.

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 3348706..ac817b1 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -210,51 +210,85 @@ static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
 	int ret;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
 	return ret;
 }
 
 static void conntrack_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	nf_ct_l3proto_module_put(par->family);
 }
 
+static int conntrack_br_check(const struct xt_mtchk_param *par)
+{
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(NFPROTO_IPV4);
+	if (ret < 0) {
+		pr_info("cannot load conntrack support for NFPROTO_IPV4\n");
+		return ret;
+	}
+	ret = nf_ct_l3proto_try_module_get(NFPROTO_IPV6);
+	if (ret < 0) {
+		nf_ct_l3proto_module_put(NFPROTO_IPV4);
+		pr_info("cannot load conntrack support for NFPROTO_IPV6\n");
+		return ret;
+	}
+	return 0;
+}
+
+static void conntrack_br_destroy(const struct xt_mtdtor_param *par)
+{
+	nf_ct_l3proto_module_put(NFPROTO_IPV4);
+	nf_ct_l3proto_module_put(NFPROTO_IPV6);
+}
+
 static struct xt_match conntrack_mt_reg[] __read_mostly = {
 	{
 		.name       = "conntrack",
 		.revision   = 1,
 		.family     = NFPROTO_UNSPEC,
 		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
 		.match      = conntrack_mt_v1,
 		.checkentry = conntrack_mt_check,
 		.destroy    = conntrack_mt_destroy,
 		.me         = THIS_MODULE,
 	},
 	{
 		.name       = "conntrack",
 		.revision   = 2,
 		.family     = NFPROTO_UNSPEC,
 		.matchsize  = sizeof(struct xt_conntrack_mtinfo2),
 		.match      = conntrack_mt_v2,
 		.checkentry = conntrack_mt_check,
 		.destroy    = conntrack_mt_destroy,
 		.me         = THIS_MODULE,
 	},
+	{
+		.name       = "conntrack",
+		.revision   = 2,
+		.family     = NFPROTO_BRIDGE,
+		.matchsize  = sizeof(struct xt_conntrack_mtinfo2),
+		.match      = conntrack_mt_v2,
+		.checkentry = conntrack_br_check,
+		.destroy    = conntrack_br_destroy,
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init conntrack_mt_init(void)
 {
 	return xt_register_matches(conntrack_mt_reg,
 	       ARRAY_SIZE(conntrack_mt_reg));
 }
 
 static void __exit conntrack_mt_exit(void)
 {
 	xt_unregister_matches(conntrack_mt_reg, ARRAY_SIZE(conntrack_mt_reg));
 }
 
 module_init(conntrack_mt_init);
 module_exit(conntrack_mt_exit);
