From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Mon, 08 Jun 2009 15:49:49 +0200
Message-ID: <4A2D16FD.2010305@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2A0DF9.8030108@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZFHNtr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:49:47 -0400
In-Reply-To: <4A2A0DF9.8030108@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>>> +static void death_by_timeout(unsigned long ul_conntrack)
>>> +{
>>> +    struct nf_conn *ct = (void *)ul_conntrack;
>>> +
>>> +    if (!test_bit(IPS_DYING_BIT, &ct->status) && +       
>>> unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
>>> +        /* destroy event was not delivered */
>>> +        nf_ct_setup_event_timer(ct);
>>> +        return;
>>> +    }
>>> +    set_bit(IPS_DYING_BIT, &ct->status);
>>> +    nf_ct_helper_destroy(ct);
>>> +    nf_ct_delete_from_lists(ct);
>> The helpers might keep global data themselves thats cleaned
>> up by ->destroy() (gre keymap for instance). The cleanup step
>> might need to be done immediately to avoid clashes with new data
>> or incorrectly returning data thats supposed to be gone.
> 
> This is a good catch that I have missed :-). I'll move this before the
> event delivery since the internal protocol helper data is not used by
> ctnetlink. I can include a comment here to warn about this if we do it
> in the future.

Sounds good enough for now.

>>> +static void nf_ct_release_dying_list(void)
>>> +{
>>> +    struct nf_conntrack_tuple_hash *h;
>>> +    struct nf_conn *ct;
>>> +    struct hlist_nulls_node *n;
>>> +
>>> +    spin_lock_bh(&nf_conntrack_lock);
>>> +    hlist_nulls_for_each_entry(h, n, &init_net.ct.dying, hnnode) {
>>> +        ct = nf_ct_tuplehash_to_ctrack(h);
>>> +        /* never fails to remove them, no listeners at this point */
>>> +        if (del_timer(&ct->timeout))
>>> +            ct->timeout.function((unsigned long)ct);
>> nf_ct_kill()?
> 
> I'll do. I have a patch here to replace a couple of similar invocation
> by nf_ct_kill(), I'll send it to you once we're done with this patchset.

OK, thanks.
