From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 04/24] [NETFILTER]: remove unused ARPT_ALIGN indirection
 macros
Date: Thu, 3 Apr 2008 14:32:48 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804031431070.1301@fbirervta.pbzchgretzou.qr>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <d601451ead14e9a09f25f7dc691609a1aed8ae84.1207134547.git.jengelh@computergmbh.de> <47F4C439.9080204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55606 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbYDCMct (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:32:49 -0400
In-Reply-To: <47F4C439.9080204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-03 13:49, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>  Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>>  ---
>>   include/linux/netfilter_arp/arp_tables.h |    4 ----
>>   1 files changed, 0 insertions(+), 4 deletions(-)
>>
>>  diff --git a/include/linux/netfilter_arp/arp_tables.h
>>  b/include/linux/netfilter_arp/arp_tables.h
>>  index 0e6b5e1..1cb698b 100644
>>  --- a/include/linux/netfilter_arp/arp_tables.h
>>  +++ b/include/linux/netfilter_arp/arp_tables.h
>>  @@ -274,8 +274,6 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
>>         const struct net_device *out,
>>         struct xt_table *table);
>>
>>  -#define ARPT_ALIGN(s) XT_ALIGN(s)
>
> This is exported to userspace, so I can't apply this. I'm
> also reverting 03/24 since that also breaks userspace.

I would not expect anything but arptables to use these macros;
and actually arptables has its own copies of the .h files much
like iptables does. Just my 13 cents.
