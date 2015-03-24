From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: #include <net/ip_vs.h> without CONFIG_IP_VS (error: 'struct net' has
 no member named 'ipvs')
Date: Tue, 24 Mar 2015 19:02:25 +0100
Message-ID: <CACna6rzvfCZfPrW5qSihJWPSTXzvz4WXkzk_GqqqBUpdxaDT=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
To: netfilter-devel@vger.kernel.org,
	JunweiZhang <junwei.zhang@6wind.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35190 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbCXSC0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 14:02:26 -0400
Received: by igcau2 with SMTP id au2so79352364igc.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2015 11:02:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

In my out-of-tree code I used to include include/net/ip_vs.h just to
make use of a trivial helper ip_vs_check_diff4. I wasn't really using
anything from net/netfilter/ipvs/ip_vs*.c.

Starting with kernel 3.11 I'm getting this error when compiling my modu=
le:
include/net/ip_vs.h: In function 'net_ipvs':
include/net/ip_vs.h:35:12: error: 'struct net' has no member named 'ipv=
s'

This is caused by the commit 8b4d14d8eb36874daf159d33dcccd4746a6f3189
netns: exclude ipvs from struct net when IPVS disabled
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8b4d14d8eb36874daf159d33dcccd4746a6f3189

I was thinking that including any Linux header should be safe, no
matter what kernel configuration is used. Am I correct about this?

Should net_ipvs from include/net/ip_vs.h be fixed to e.g. return NULL
if CONFIG_IP_VS isn't enabled?

--=20
Rafa=C5=82
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
