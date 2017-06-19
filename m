From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_ct_dccp/sctp: fix memory leak after
 netns cleanup
Date: Mon, 19 Jun 2017 17:52:38 +0200
Message-ID: <20170619155238.GC28291@breakpoint.cc>
References: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47406 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752577AbdFSPxe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 11:53:34 -0400
Content-Disposition: inline
In-Reply-To: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After running the following commands for a while, kmemleak reported that
> "1879 new suspected memory leaks" happened:
>   # while : ; do
>   ip netns add test
>   ip netns delete test
>   done

Acked-by: Florian Westphal <fw@strlen.de>

I think we might want to add this to nf-next:

@@ -408,8 +410,10 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
	pn = nf_ct_l4proto_net(net, l4proto);
-       if (pn == NULL)
+       if (pn == NULL) {
+               ret = -EINVAL;
		goto out;
+	}

so that nf_ct_l4proto_pernet_register_one() will return failure.

Maybe even add a WARN_ON in nf_ct_l4proto_net() to catch this.
