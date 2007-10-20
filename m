From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Unique symbol names
Date: Sat, 20 Oct 2007 17:12:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201711320.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710201216251.1997@fbirervta.pbzchgretzou.qr>
 <471A1A16.4000005@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60562 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXJTPM5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:12:57 -0400
In-Reply-To: <471A1A16.4000005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 20 2007 17:09, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Give the target, match, check, etc. functions unique names.
>>
>> static unsigned int
>> -target(struct sk_buff *skb,
>> -       const struct net_device *in,
>> -       const struct net_device *out,
>> -       unsigned int hooknum,
>> -       const struct xt_target *target,
>> -       const void *targinfo)
>> +CLUSTERIP_target(struct sk_buff *skb, const struct net_device *in,
>> +                 const struct net_device *out, unsigned int hooknum,
>> +                 const struct xt_target *target, const void *targinfo)
>>  {
>
> I don't really like this naming scheme since it uses capital letters
> in the function name. The _target prefix should be enough to distinguish
> matches and targets, no?

Had not thought about that yet, but yes.

What about MARK_parse_v0 vs. mark_parse_v0? I did not feel like
elongating that to xt_mark_target_parse_v0 and xt_mark_match_parse_v0.
