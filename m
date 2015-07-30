From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: IPv4 IPv6 parallel dns lookup in combination with nfqueue is
 problematic
Date: Thu, 30 Jul 2015 14:21:28 +0200
Message-ID: <20150730122116.GA10435@salvia>
References: <CAMxdDZBwqRxZjywAfHUm-bbe-0veLPqPwAfFpw90cb0As80Dmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Ulrich Weber <uw@ocedo.com>
To: Tarik Demirci <tarik@tarikdemirci.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59835 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbG3MPj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 08:15:39 -0400
Content-Disposition: inline
In-Reply-To: <CAMxdDZBwqRxZjywAfHUm-bbe-0veLPqPwAfFpw90cb0As80Dmg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 24, 2015 at 01:34:19PM +0300, Tarik Demirci wrote:
> Hi Everyone,
> 
> Problem:
> I have a simple daemon listening for packets coming from nfqueue. When
> a client issues  parallel dns requests for IPv4 and IPv6 addresses
> (since glibc 2.9 this is default behaviour), IPv6 request is dropped
> on its way in gateway. Client, after 5 seconds timeout, sends these
> requests sequentially and there is no problem in this case.
> 
> Workaround:
> I applied a kernel patch from an earlier mail (
> http://www.spinics.net/lists/netfilter-devel/msg15860.html ) to kernel
> version 3.16. This patch solves the problem but I'm unaware of the
> performance and security implications of this solution. I hope to find
> a better solution that doesn't require patching kernel.

I think we can resolve this from nf_reinject() which is slow path,
with something that looks like this:

{
        struct nf_conntrack_tuple_hash *h;
        enum ip_conntrack_info ctinfo;
        struct nf_conn *ct;

        ct = nf_ct_get(skb, &ctinfo);
        if (ct == NULL || nf_ct_is_untracked(ct) || nf_ct_is_confirmed(ct))
                return;

        h = nf_conntrack_find_get(nf_ct_net(ct), nf_ct_zone(ct),
                                  &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
        if (h) {
                nf_conntrack_put(ct);
                ct = nf_ct_tuplehash_to_ctrack(h);
                skb->nfct = &ct->ct_general;
                skb->nfctinfo = ctinfo;
        }
}

But to avoid dependencies with ct we have to add a RCU hook pointer to
function, so this code it only invoked if conntrack is loaded.

I'll try to find some spare time to send a patch, otherwise if there
is anyone else willing to work on this, just drop me a line privately.

Thanks.
