From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_ct_ext: fix possible panic after
 nf_ct_extend_unregister
Date: Sat, 25 Mar 2017 10:38:52 +0100
Message-ID: <20170325093852.GA16691@breakpoint.cc>
References: <1490430929-31385-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43250 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750820AbdCYJjm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2017 05:39:42 -0400
Content-Disposition: inline
In-Reply-To: <1490430929-31385-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> Step 1. Enable SYNPROXY for tcp dport 1234 at FORWARD hook:
>   # iptables -I FORWARD -p tcp --dport 1234 -j SYNPROXY
> Step 2. Queue the syn packet to the userspace at raw table OUTPUT hook.
>         Also note, in the userspace we only add a 20s' delay, then
>         reinject the syn packet to the kernel:
>   # iptables -t raw -I OUTPUT -p tcp --syn -j NFQUEUE --queue-num 1
> Step 3. Using "nc 2.2.2.2 1234" to connect the server.
> Step 4. Now remove the nf_synproxy_core.ko quickly:
>   # iptables -F FORWARD
>   # rmmod ipt_SYNPROXY
>   # rmmod nf_synproxy_core
> Step 5. After 20s' delay, the syn packet is reinjected to the kernel.

Lovely.

> But having such a obscure restriction of nf_ct_extend_unregister is not a
> good idea, so we should invoke synchronize_rcu after set nf_ct_ext_types
> to NULL, and check the NULL pointer when do __nf_ct_ext_add_length. Then
> it will be easier if we add new ct extend in the future.

Agree.

Acked-by: Florian Westphal <fw@strlen.de>

> Last, we use kfree_rcu to free nf_ct_ext, so rcu_barrier() is unnecessary
> anymore, remove it too.

I think with some extra work we could switch to kfree since almost
all spots that access the extension area do it after obtaining
a reference on the conntrack.

Someone would need to audit the code first, I suspect the ecache work
queue isn't safe without the kfree_rcu, perhaps there are other places
as well.
