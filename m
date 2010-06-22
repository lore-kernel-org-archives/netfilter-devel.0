From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT tracking to be
 enabled
Date: Tue, 22 Jun 2010 11:55:59 -0600
Message-ID: <4C20F92F.3070200@canonical.com>
References: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com> <1277225075-30428-3-git-send-email-tim.gardner@canonical.com> <alpine.LSU.2.01.1006221847540.4850@obet.zrqbmnf.qr>
Reply-To: tim.gardner@canonical.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030309060608030906010909"
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org, ole@ans.pl
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4020 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757815Ab0FVR4F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:56:05 -0400
In-Reply-To: <alpine.LSU.2.01.1006221847540.4850@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030309060608030906010909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/22/2010 10:49 AM, Jan Engelhardt wrote:
>
>
> On Tuesday 2010-06-22 18:44, tim.gardner@canonical.com wrote:
>> net/netfilter/xt_connbytes.c |   13 ++++++++++++-
>> 1 files changed, 12 insertions(+), 1 deletions(-)
>>
>> +	 * accounting is enabled, so complain about it until someone notices.
>> +	 * It _should_ only print one warning message.
>> +	 */
>> +	if (unlikely(nf_ct_acct_enabled(ct) == false)) {
>> +		if (net_ratelimit())
>> +			pr_warning("ipt_connbytes: Force enabling CT accounting\n");
>> +		nf_ct_set_acct(ct, true);
>> +	}
>
> Am I in a timewarp vortex? It's xt_connbytes, not ipt_connbytes.
> Better yet, use KBUILD_MODNAME together with pr_fmt.
> --

It turns out that pr_warning() already uses pr_fmt(). Change pushed.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------030309060608030906010909
Content-Type: text/x-patch;
 name="0002-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.pa";
 filename*1="tch"

>From 5b47470d916e85bfc5df835580c5898997fdeb81 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 22 Jun 2010 09:27:30 -0600
Subject: [PATCH 2/3] netfilter: xt_connbytes: Force CT accounting to be enabled

Check at runtime that CT accounting is enabled, and force it
to be enabled if not.

This is in preparation for deprecating CONFIG_NF_CT_ACCT.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/netfilter/xt_connbytes.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7351783..b25bf54 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -21,7 +21,7 @@ static bool
 connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
-	const struct nf_conn *ct;
+	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
 	u_int64_t bytes = 0;
@@ -32,6 +32,17 @@ connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (!ct)
 		return false;
 
+	/*
+	 * This filter cannot function correctly unless connection tracking
+	 * accounting is enabled, so complain about it until someone notices.
+	 * It _should_ only print one warning message.
+	 */
+	if (unlikely(nf_ct_acct_enabled(ct) == false)) {
+		if (net_ratelimit())
+			pr_warning("Force enabling CT accounting\n");
+		nf_ct_set_acct(ct, true);
+	}
+
 	counters = nf_conn_acct_find(ct);
 	if (!counters)
 		return false;
-- 
1.7.0.4


--------------030309060608030906010909--
