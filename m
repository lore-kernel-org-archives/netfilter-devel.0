From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: nf_nat_core just using l3proto_find_get
Date: Mon, 10 Mar 2008 23:01:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803102259100.21961@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr>
 <47BACA14.8000006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55769 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYCJWBX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:01:23 -0400
In-Reply-To: <47BACA14.8000006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 19 2008 13:22, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Hi,
>> 
>> 
>> I just noticed that nf_nat_core.c uses
>> 
>>         l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
>> 
>> in its nf_nat_init() function. Why is not it using
>> nf_ct_l3proto_module_try_get here?
>
> There is no such function, nf_ct_l3proto_find_get() takes a
> module reference.
>
Hm?

=== nf_nat_core.c ===
        spin_unlock_bh(&nf_nat_lock);

        /* Initialize fake conntrack so that NAT will skip it */
        nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;

        l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
        return 0;

 cleanup_extend:
        nf_ct_extend_unregister(&nat_extend);
        return ret;
}
===

Since nf_ct_l3proto_find_get is listed in System.map, it
cannot be a macro, but it is a function indeed.
And nf_ct_l3proto_try_module_get does take a numerical value:

=== xt_conntrack.c
conntrack_mt_check(const char *tablename, const void *ip,
                   const struct xt_match *match, void *matchinfo,
                   unsigned int hook_mask)
{
        if (nf_ct_l3proto_try_module_get(match->family) < 0) {
                printk(KERN_WARNING "can't load conntrack support for "
                                    "proto=%u\n", match->family);
===

leading to the original question why nf_nat_core does not use
nf_ct_l3proto_try_module_get.
