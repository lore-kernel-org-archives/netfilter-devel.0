From: Patrick McHardy <kaber@trash.net>
Subject: Re: 11/11 [NETFILTER]: Remove redundant casts from Ebtables extensions
Date: Thu, 02 Oct 2008 12:37:39 +0200
Message-ID: <48E4A473.9080307@trash.net>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0809102246080.8838@fbirervta.pbzchgretzou.qr> <48E4A2C4.5050503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54327 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYJBKij (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:38:39 -0400
In-Reply-To: <48E4A2C4.5050503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 07f89c4687ada3347c454fc8ff2d078256019eb6
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Wed Sep 10 22:39:32 2008 -0400
>>
>> [NETFILTER]: Remove redundant casts from Ebtables extensions
>>   
>
> Also applied, thanks Jan.

This patch introduces new warnings because data is const:

@@ -20,7 +20,7 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
 		const struct net_device *out, unsigned int hook_nr,
 		const struct xt_target *target, const void *data)
 {
-	struct ebt_arpreply_info *info = (void *)data;
+	struct ebt_arpreply_info *info = data;


I'm backing it out for now, please resend with the private structs changed
to const (if possible).

