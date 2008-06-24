From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Tue, 24 Jun 2008 18:45:52 +0200
Message-ID: <486124C0.5070104@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58203 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYFXQp7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:45:59 -0400
In-Reply-To: <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> 
> 
> On Tue, 24 Jun 2008, Patrick McHardy wrote:
> 
>> A few minor nits - a patch on top to fix them is fine, I'll
>> just fold them together.
> 
> I prefer to send a new patch if that is OK for you.

Sure.

>>> +static inline
>>> +struct ip_conntrack_counter *nf_conn_acct_find(const struct nf_conn 
>>> *ct)
>>> +{
>>> +    return nf_ct_ext_find(ct, NF_CT_EXT_ACCT);
>>> +}
>>> +
>>> +struct ip_conntrack_counter *nf_ct_acct_ext_add(struct nf_conn *ct, 
>>> gfp_t gfp);
>>> +
>> Also using ip_conntrack in the
>> struct name doesn't make much sense, please use nf_conntrack as prefix.
>> Or maybe for consistency with the other extensions, nf_conn.
> 
> Fine, I'll rename it to nf_conn_counter. Please note that the 
> ip_conntrack_counter comes from nf_conntrack_common.h and is already 
> used in several places. Isn't it a pointless rename?

I wasn't aware of that. Its a rename, but not pointless IMO :)
We can also do the rename later, but I only count three occurences
so far, so it seems easier to do it now.

>>> +#ifdef CONFIG_NF_CT_ACCT
>>> +    printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be 
>>> removed soon. Plase use\n");
>>> +    printk(KERN_WARNING "nf_conntrack.acct=1 kernel paramater, 
>>> acct=1 nf_conntrack module option or\n");
>>> +    printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to 
>>> enable it.\n");
>>
>> Since sysctls are deprecated (or are they still?), better to just
>> mention the kernel and module options.
> 
> No, sysctls are not deprecated and allow to enable/disable accouting at 
> runtime - kernel/module options allow to enable/disable accouting at 
> boot time. We only deprecate CONFIG_NF_CT_ACCT.

sysctls using the sysctl() syscall are deprecated if I'm
not mistaken. sysfs also allows to change module parameters
at runtime, but sure, keep it, it will be gone soon enough.

Thanks.
