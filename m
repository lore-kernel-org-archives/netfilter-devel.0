From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf] netfilter: nf_conntrack: fix endless loop on netns
 deletion
Date: Wed, 01 Jul 2015 23:29:17 +0200
Message-ID: <55945BAD.3010809@iogearbox.net>
References: <b41741db7ecfaabe74fbcacac9a628375217ee35.1435765328.git.daniel@iogearbox.net> <20150701165755.GB30866@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:45684 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbGAV3Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jul 2015 17:29:25 -0400
In-Reply-To: <20150701165755.GB30866@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/01/2015 06:57 PM, Florian Westphal wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> When adding connection tracking template rules to a netns, f.e. to
>> configure netfilter zones, the kernel will endlessly busy-loop as soon
>> as we try to delete the given netns in case there's at least one
>> template present. Minimal example:
>>
>>    ip netns add foo
>>    ip netns exec foo iptables -t raw -A PREROUTING -d 1.2.3.4 -j CT --zone 1
>>    ip netns del foo
>
> [..]
...
> I was worried next call to nf_ct_tmpls_cleanup() might see same ct
> again, thus putting it more than once.
>
> But it seems safe as it runs after a synchronize_net, i.e.  ct refcnt
> should always be 1, and thus the nf_ct_put should result in invocation of
> destructor & removal from tmplate list.

Please drop this patch, it needs changes.

While debugging this further, I noticed the issue seems actually a
different one that I thought it was originally: I.e. when the netns
is removed, the ct template is in fact being freed/ref-dropped via
xt_ct_tg_destroy(), but that happens at a later stage after the
nf_conntrack_cleanup_net_list(), where we test for net->ct.count.

Given that in nf_conntrack_cleanup_net_list() we tear down all the
per net ct infrastructure, they cannot be deferred until xt_ct_tg_destroy().

Will try to find a different solution.

Cheers,
Daniel
