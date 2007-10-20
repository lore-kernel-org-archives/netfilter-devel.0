From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Unique symbol names
Date: Sat, 20 Oct 2007 17:17:39 +0200
Message-ID: <471A1C13.7080807@trash.net>
References: <Pine.LNX.4.64.0710201216251.1997@fbirervta.pbzchgretzou.qr> <471A1A16.4000005@trash.net> <Pine.LNX.4.64.0710201711320.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33619 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbXJTPSn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:18:43 -0400
In-Reply-To: <Pine.LNX.4.64.0710201711320.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 20 2007 17:09, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Give the target, match, check, etc. functions unique names.
>>>
>>> static unsigned int
>>> -target(struct sk_buff *skb,
>>> -       const struct net_device *in,
>>> -       const struct net_device *out,
>>> -       unsigned int hooknum,
>>> -       const struct xt_target *target,
>>> -       const void *targinfo)
>>> +CLUSTERIP_target(struct sk_buff *skb, const struct net_device *in,
>>> +                 const struct net_device *out, unsigned int hooknum,
>>> +                 const struct xt_target *target, const void *targinfo)
>>>  {
>> I don't really like this naming scheme since it uses capital letters
>> in the function name. The _target prefix should be enough to distinguish
>> matches and targets, no?
>
> Had not thought about that yet, but yes.
>
> What about MARK_parse_v0 vs. mark_parse_v0? I did not feel like
> elongating that to xt_mark_target_parse_v0 and xt_mark_match_parse_v0.

Yeah, thats not so great either. Can't think of a better scheme
right now, anyone else got some suggestions?
