From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[2]:  [PATCH 2/2] extensions: add HMARK target
Date: Sun, 15 Jul 2012 00:53:46 +0200 (CEST)
Message-ID: <tqndgm6.1b88e2552b09f599e7127d46418a73b3@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:49521 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2GNWxu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 18:53:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>On Thu, Jul 12, 2012 at 09:34:45AM +0200, Hans Schillstrom wrote:
>> Hi Pablo
>> [snip]
>> +static void HMARK_check(struct xt_fcheck_call *cb)
>> >+{
>> >+	if (!(cb->xflags & (1 << O_HMARK_MODULUS)))
>> >+		xtables_error(PARAMETER_PROBLEM, "--hmark-mod is mandatory");
>> >+	if (!(cb->xflags & (1 << O_HMARK_RND)))
>> >+		xtables_error(PARAMETER_PROBLEM, "--hmark-rnd is mandatory");
>> 
>> I don't think rnd should be mandatory, a default value is enough.
>> offset however should be mandatory.
>
>As I said, parameters that are not set will likely not be set by
>users. If default value for random, the easier it will be for an
>attacker to direct all flows to the same target.

If he knows the modulo, and assume that default rand.value  is used....
I still don't think rnd should be mandatory, but I can live with it.

>
>I'll be OK to make --hmark-offset mandatory, BTW.
Well,  if people use it to other things than PBR it will be bad to have it mandatory
so I think we leave it as it is.

I don't like is that MODE_L3 is gone 
L3 can be substituted by using --hamrk-tuple src, dst. so that might be OK
but there is no flag set. (causing a lot of extra cpu cycles)

All masks have gone from set to  zero, (due to hmark-tuple ?)
If it's more clear or not , I don't know  but the man page needs to be updated
 --hmark-tuple ct alone doesn't do much.

iptables \-t mangle \-A PREROUTING \-m state \-\-state NEW
- \-j HMARK \-\-hmark-tuple ct \-\-hmark-offset 10000 \-\-hmark\-mod 10
change to
+ \-j HMARK \-\-hmark-tuple ct,src,dst \-\-hmark-offset 10000 \-\-hmark\-mod 10
\-\-hmark\-rnd 0xfeedcafe

Some faults found during my first sanity check.
(I have not run any real tests so far, just some manual command  tests
Due to the new behaviour and syntax the test suite needs some update)

diff --git a/extensions/libxt_HMARK.c b/extensions/libxt_HMARK.c
index ee2629d..053bc10 100644
--- a/extensions/libxt_HMARK.c
+++ b/extensions/libxt_HMARK.c
@@ -280,15 +280,15 @@ static void HMARK_check(struct xt_fcheck_call *cb)
 
 static void HMARK_print(const struct xt_hmark_info *info)
 {
-       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT))
+       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT_MASK))
                printf("sport-mask 0x%x ", htons(info->port_mask.p16.src));
-       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT))
+       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))
                printf("dport-mask 0x%x ", htons(info->port_mask.p16.dst));
        if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI))
                printf("spi-mask 0x%x ", htonl(info->port_mask.v32));
-       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT_MASK))
+       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT))
                printf("sport-set 0x%x ", htons(info->port_set.p16.src));
-       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))
+       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT))
                printf("dport-set 0x%x ", htons(info->port_set.p16.dst));
        if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK))
                printf("spi-set 0x%x ", htonl(info->port_set.v32));
@@ -333,11 +333,11 @@ static void HMARK_ip4_print(const void *ip,
        if (info->flags & XT_HMARK_FLAG(XT_HMARK_CT))
                printf("ct, ");
        if (info->flags & XT_HMARK_FLAG(XT_HMARK_SADDR_MASK))
-               printf("src-prefix %s ",
-                      xtables_ipmask_to_numeric(&info->src_mask.in) + 1);
+               printf("src-prefix %d ",
+                      xtables_ipmask_to_cidr(&info->src_mask.in));
        if (info->flags & XT_HMARK_FLAG(XT_HMARK_DADDR_MASK))
-               printf("dst-prefix %s ",
-                      xtables_ipmask_to_numeric(&info->dst_mask.in) + 1);
+               printf("dst-prefix %d ",
+                      xtables_ipmask_to_cidr(&info->dst_mask.in));
        HMARK_print(info);
 }



