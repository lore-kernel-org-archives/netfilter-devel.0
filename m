From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT accounting to be
 enabled
Date: Thu, 24 Jun 2010 12:49:37 -0600
Message-ID: <4C23A8C1.2070506@canonical.com>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com> <1277393257-15281-3-git-send-email-tim.gardner@canonical.com> <alpine.LSU.2.01.1006241915040.324@obet.zrqbmnf.qr>
Reply-To: tim.gardner@canonical.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090405020301070507000502"
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3890 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab0FXSuI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:50:08 -0400
In-Reply-To: <alpine.LSU.2.01.1006241915040.324@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090405020301070507000502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/24/2010 11:15 AM, Jan Engelhardt wrote:
>
> On Thursday 2010-06-24 17:27, Tim Gardner wrote:
>> diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
>> index 7351783..b0cda8c 100644
>> --- a/net/netfilter/xt_connbytes.c
>> +++ b/net/netfilter/xt_connbytes.c
>> @@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
>> 	if (ret<  0)
>> 		pr_info("cannot load conntrack support for proto=%u\n",
>> 			par->family);
>> +
>> +	/*
>> +	 * This filter cannot function correctly unless connection tracking
>> +	 * accounting is enabled, so complain in the hope that someone notices.
>> +	 */
>> +	if (nf_ct_acct_enabled(par) == false) {
>
> 	if (!nfct_acct_enabled(par)) {
>
>> +		pr_warning("Forcing CT accounting to be enabled\n");
>> +		nf_ct_set_acct(par, true);
>> +	}
>> +
>> 	return ret;
>> }
> --

meh, I suppose portability isn't the issue it once was with respect to 
boolean and signed integers. Here is the combined 1 and 2 patches. If 
its sufficient I'll resend the pull request as a V4.

rtg

-- 
Tim Gardner tim.gardner@canonical.com

--------------090405020301070507000502
Content-Type: text/x-patch;
 name="0001-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.pa";
 filename*1="tch"

>From 826648076bfdbb9e166c3eeac6c122ef8c7f5902 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 22 Jun 2010 09:25:48 -0600
Subject: [PATCH 1/2] netfilter: xt_connbytes: Force CT accounting to be enabled

Check at rule install time that CT accounting is enabled. Force it
to be enabled if not while also emitting a warning since this is not
the default state.

This is in preparation for deprecating CONFIG_NF_CT_ACCT upon which
CONFIG_NETFILTER_XT_MATCH_CONNBYTES depended being set.

Added 2 CT accounting support functions:

nf_ct_acct_enabled() - Get CT accounting state.
nf_ct_set_acct() - Enable/disable CT accountuing.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/net/netfilter/nf_conntrack_acct.h |   12 ++++++++++++
 net/netfilter/xt_connbytes.c              |   10 ++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 03e218f..4e9c63a 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -45,6 +45,18 @@ struct nf_conn_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 extern unsigned int
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
 
+/* Check if connection tracking accounting is enabled */
+static inline bool nf_ct_acct_enabled(struct net *net)
+{
+	return net->ct.sysctl_acct != 0;
+}
+
+/* Enable/disable connection tracking accounting */
+static inline void nf_ct_set_acct(struct net *net, bool enable)
+{
+	net->ct.sysctl_acct = enable;
+}
+
 extern int nf_conntrack_acct_init(struct net *net);
 extern void nf_conntrack_acct_fini(struct net *net);
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7351783..5b13850 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
+
+	/*
+	 * This filter cannot function correctly unless connection tracking
+	 * accounting is enabled, so complain in the hope that someone notices.
+	 */
+	if (!nf_ct_acct_enabled(par->net)) {
+		pr_warning("Forcing CT accounting to be enabled\n");
+		nf_ct_set_acct(par->net, true);
+	}
+
 	return ret;
 }
 
-- 
1.7.0.4


--------------090405020301070507000502--
