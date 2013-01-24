From: Jean-Michel DILLY <jm@dilly.me>
Subject: Re: [PATCH] netfilter: fix IPv6 NTP checksum calculation
Date: Thu, 24 Jan 2013 18:09:06 +0100
Message-ID: <06023CFA-4D28-43B3-8C7F-B8223F3390DD@dilly.me>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.dillydally.fr ([87.98.128.188]:60268 "EHLO
	mail.dillydally.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3AXRPH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:15:07 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
	by mail.dillydally.fr (Postfix) with ESMTP id BCE24800D7
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jan 2013 18:09:05 +0100 (CET)
Received: from mail.dillydally.fr ([127.0.0.1])
	by localhost (mail.dillydally.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fVWqk0DgXLqK for <netfilter-devel@vger.kernel.org>;
	Thu, 24 Jan 2013 18:09:05 +0100 (CET)
Received: from [192.168.0.87] (nancy.dillydally.fr [109.190.61.4])
	by mail.dillydally.fr (Postfix) with ESMTPSA id B6758800C8
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jan 2013 18:09:04 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
This patch doesn't work as expected. I tried with few IP and each time 0x0100 were missing. csum_add seems buggy too.
I have reimplemented csum16s functions with the Ulrich's fix. It seems to work now.
I'm a noob, so I guess someone will propose a better patch for this.
diff --git a/ip6t_NPT.c b/linux-3.8-rc4/net/ipv6/netfilter/ip6t_NPT.c
index 787748b..29ef720 100644
--- a/ip6t_NPT.c
+++ b/linux-3.8-rc4/net/ipv6/netfilter/ip6t_NPT.c
@@ -14,24 +14,44 @@
 #include <linux/netfilter_ipv6/ip6t_NPT.h>
 #include <linux/netfilter/x_tables.h>
 
+static __sum16 csum16_add(__sum16 a, __sum16 b)
+{
+       __u16 result;
+
+       result = (__force __u16) a + (__force __u16) b;
+       result += result < (__force u16)b; 
+               
+
+       return (__force __sum16) result;
+}
+
+static __sum16 csum16_complement(__sum16 a)
+{
+       return (__force __sum16)(0xffff - (__force u16)a);
+}
+
+static __sum16 csum16_sub(__sum16 a, __sum16 b)
+{
+       return csum16_add(a, csum16_complement(b));
+}
 
 static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 {
        struct ip6t_npt_tginfo *npt = par->targinfo;
-       __wsum src_sum = 0, dst_sum = 0;
+       __sum16 src_sum = 0, dst_sum = 0;
        unsigned int i;
 
        if (npt->src_pfx_len > 64 || npt->dst_pfx_len > 64)
                return -EINVAL;
 
        for (i = 0; i < ARRAY_SIZE(npt->src_pfx.in6.s6_addr16); i++) {
-               src_sum = csum_add(src_sum,
-                       (__force __wsum)npt->src_pfx.in6.s6_addr16[i]);
-               dst_sum = csum_add(dst_sum,
-                       (__force __wsum)npt->dst_pfx.in6.s6_addr16[i]);
+               src_sum = csum16_add(src_sum, 
+                                       (__force __sum16)npt->src_pfx.in6.s6_addr16[i]);
+               dst_sum = csum16_add(dst_sum, 
+                                       (__force __sum16)npt->dst_pfx.in6.s6_addr16[i]);
        }
 
-       npt->adjustment = (__force __sum16) csum_sub(src_sum, dst_sum);
+       npt->adjustment = csum16_sub(src_sum, dst_sum);
        return 0;
 }
 
@@ -67,8 +87,8 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
                        return false;
        }
 
-       sum = (__force __sum16) csum_add((__force __wsum)addr->s6_addr16[idx],
-                        npt->adjustment);
+       sum = csum16_add((__force __sum16)addr->s6_addr16[idx],
+                               npt->adjustment);
        if (sum == CSUM_MANGLED_0)
                sum = 0;
        *(__force __sum16 *)&addr->s6_addr16[idx] = sum;

Regards,
JMichel

On Fri, Jan 04, 2013 at 10:20:43AM +0100, Patrick McHardy wrote:
> > On Wed, Jan 02, 2013 at 04:24:40PM +0100, Ulrich Weber wrote:
> > > csum16_add() has a broken carry detection, should be:
> > > sum += sum < (__force u16)b;
> > > 
> > > Instead of fixing csum16_add, remove the custom checksum
> > > functions and use the generic csum_add/csum_sub ones.
> > 
> > Looks good to me.
> > 
> > Acked-by: Patrick McHardy <kaber@trash.net>

>Applied, thanks!

