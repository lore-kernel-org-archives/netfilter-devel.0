From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Tue, 03 Jun 2008 18:28:31 +0200
Message-ID: <4845712F.7080003@trash.net>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl> <4845477B.8050400@trash.net> <Pine.LNX.4.64.0806031715240.3438@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45236 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYFCQ2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:28:35 -0400
In-Reply-To: <Pine.LNX.4.64.0806031715240.3438@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> On Tue, 3 Jun 2008, Patrick McHardy wrote:
> 
>>>  +    nf_conntrack.acct=
>>> +            [NETFILTER] Enable connection tracking flow accounting
>>> +            0 to disable accounting (default)
>>> +            1 to enable accounting
>>
>> Changing the default will probably result in surprises.
>> How about we make a config option (CONFIG_NF_ACCT_COMPAT)
>> that makes it default to 1 and print a warning that this
>> option is going to be removed/the default changed. Then
>> we add a target to manually enable accounting on a per-connection
>> base and kill off the compat option after a couple of
>> month.
> 
> As far as I know there is now way to enable accounting on a 
> per-connection base with a target as it is not possible to ad ct_extend 
> to confirmed conntracks.

You can add it to unconfirmed conntracks though.

> However, I think we may still use 
> CONFIG_NF_CT_ACCT but only to set a default value of this (nf_ct_acct) 
> variable, is that acceptable?

We should move towards getting rid of the default value,
having this depend on a config option must only be a temporary
solution. So we'd still need a target to enable it manually
and some kind of warning.

>>> +unsigned int
>>> +seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
>>> +{
>>> +    struct nf_conn_acct *acct;
>>> +
>>> +    acct = nf_conn_acct_find(ct);
>>> +    if (!acct)
>>> +        return 0;
>>> +
>>> +    return seq_printf(s, "packets=%llu bytes=%llu ",
>>> +              acct->packets[dir],
>>> +              acct->bytes[dir]);
>>
>> Will probably cause warnings on 64bit.
> 
> OK, so we need here something like "(unsigned long long)", right?

Yes.
