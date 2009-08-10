From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 021/103] netfilter: xtables: consolidate table hook functions
Date: Mon, 10 Aug 2009 11:51:00 +0200
Message-ID: <4A7FED84.4010900@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-22-git-send-email-jengelh@medozas.de> <4A7FE131.5040901@trash.net> <alpine.LSU.2.00.0908101128160.23752@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZHJJvD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:51:03 -0400
In-Reply-To: <alpine.LSU.2.00.0908101128160.23752@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-08-10 10:58, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> For a following patch in this series, we will be requiring that a
>>> single hook function per table does the processing.
>> Which one?
> 
> "generate nf_hook_ops on-demand"
> 
>>>  {
>>> -	return arpt_do_table(skb, hook, in, out,
>>> -			     dev_net(in)->ipv4.arptable_filter);
>>> -}
>>> +	if (hook == NF_ARP_OUT)
>>> +		return arpt_do_table(skb, hook, in, out,
>>> +		       dev_net(out)->ipv4.arptable_filter);
>> I have to say, I really dislike this strange formatting style (I
>> think its an emacs thing, you're not the only one doing this).
>> The arguments are all neatly aligned so far, please keep it that
>> way.
> 
> Well only good I am not into Emacs ;)

That was only a guess :)

> The reasoning for such unconscious action may simply be that some
> function names are a bit long and cause an unnecessary indentation to
> the right in such cases. Or you could argue all "arguments" to 'return'
> are actually aligned - with respect to the return keyword that is.

One could .. but that argument doesn't make much sense to me :)

I've been letting this slip for too long, but these style
inconsistencies do bother me, so please keep it aligned to
the left parenthesis (or change it so it will be that way when
touching code).
