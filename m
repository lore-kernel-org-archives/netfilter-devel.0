From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf,v2] netfilter: fix netns dependencies with conntrack
 templates
Date: Wed, 15 Jul 2015 22:15:08 +0200
Message-ID: <55A6BF4C.7050202@iogearbox.net>
References: <1436978355-3367-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:54721 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbbGOUPK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 16:15:10 -0400
In-Reply-To: <1436978355-3367-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/15/2015 06:39 PM, Pablo Neira Ayuso wrote:
> From: Pablo Neira <pablo@netfilter.org>
>
> Quoting Daniel Borkmann:
>
> "When adding connection tracking template rules to a netns, f.e. to
> configure netfilter zones, the kernel will endlessly busy-loop as soon
> as we try to delete the given netns in case there's at least one
> template present, which is problematic i.e. if there is such bravery that
> the priviledged user inside the netns is assumed untrusted.
>
> Minimal example:
>
>    ip netns add foo
>    ip netns exec foo iptables -t raw -A PREROUTING -d 1.2.3.4 -j CT --zone 1
>    ip netns del foo
>
> What happens is that when nf_ct_iterate_cleanup() is being called from
> nf_conntrack_cleanup_net_list() for a provided netns, we always end up
> with a net->ct.count > 0 and thus jump back to i_see_dead_people. We
> don't get a soft-lockup as we still have a schedule() point, but the
> serving CPU spins on 100% from that point onwards.
>
> Since templates are normally allocated with nf_conntrack_alloc(), we
> also bump net->ct.count. The issue why they are not yet nf_ct_put() is
> because the per netns .exit() handler from x_tables (which would eventually
> invoke xt_CT's xt_ct_tg_destroy() that drops reference on info->ct) is
> called in the dependency chain at a *later* point in time than the per
> netns .exit() handler for the connection tracker.
>
> This is clearly a chicken'n'egg problem: after the connection tracker
> .exit() handler, we've teared down all the connection tracking
> infrastructure already, so rightfully, xt_ct_tg_destroy() cannot be
> invoked at a later point in time during the netns cleanup, as that would
> lead to a use-after-free. At the same time, we cannot make x_tables depend
> on the connection tracker module, so that the xt_ct_tg_destroy() would
> be invoked earlier in the cleanup chain."
>
> Daniel confirms this has to do with the order in which modules are loaded or
> having compiled nf_conntrack as modules while x_tables built-in. So we have no
> guarantees regarding the order in which netns callbacks are executed.
>
> Fix this by allocating the templates through kmalloc() from the respective
> SYNPROXY and CT targets, so they don't depend on the conntrack kmem cache.
> Then, release then via kfree() from destroy_conntrack(). This branch is marked
> as unlikely since conntrack templates are rarely allocated and only from the
> configuration plane path.
>
> Note that templates are not kept in any list to avoid further dependencies with
> nf_conntrack anymore, thus, the tmpl larval list is removed.

Looks good to me, and fixes the issue I'm seeing, thanks Pablo!

> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Daniel Borkmann <daniel@iogearbox.net>
