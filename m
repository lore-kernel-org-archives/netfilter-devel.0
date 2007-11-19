From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/3] xt_owner match
Date: Mon, 19 Nov 2007 17:56:21 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711191751580.32378@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711161400360.3340@fbirervta.pbzchgretzou.qr>
 <4741AF25.5080604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58473 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbXKSQ4X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:56:23 -0500
In-Reply-To: <4741AF25.5080604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 19 2007 16:43, Patrick McHardy wrote:
>
> Please keep both.
>
Right.

>> +config NETFILTER_XT_MATCH_OWNER
>> +	tristate '"owner" match support'
>> +	depends on NETFILTER_XTABLES
>> +	---help---
>> +	Socket owner matching allows you to match locally-generated packets
>> +	based on who created the socket: the user, group, process or session.
>
> Only user and group are supported.
>
>> +	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
>> +		return false;
>> +
>> +	filp = skb->sk->sk_socket->file;
>> +	if (filp == NULL)
>> +		return false;
>
> What would be nice is to allow matching whether a socket exists,
> without UID/GID. I had a patch for this for a long time, but
> lost it somewhere.

Do you mean xt_socket from TPROXY?

>> +static struct xt_match owner_mt_reg[] __read_mostly = {
>> +	{
>> +		.name       = "owner",
>> +		.revision   = 0,
>> +		.family     = AF_INET,
>> +		.match      = owner_mt_v0,
>> +		.matchsize  = sizeof(struct ipt_owner_info),
>> +		.checkentry = owner_mt_check_v0,
>> +		.hooks      = (1 << NF_IP_LOCAL_OUT) |
>> +		              (1 << NF_IP_POST_ROUTING),
>
> This needs to use NF_INET_...
>
> Please resend all your patches when you want me to apply them.
> Thanks.
>

Will do.
