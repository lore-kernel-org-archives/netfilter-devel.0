From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Tue, 14 Nov 2017 07:41:05 +0100
Message-ID: <20171114064105.GP5512@breakpoint.cc>
References: <1510394920-25302-1-git-send-email-jelliott@arista.com>
 <20171111182751.GI5512@breakpoint.cc>
 <CA+c2rSiciLQiJqzfdwo9p4_POQSZW1mmaQCfsMwPvm4td2wLAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Jay Elliott <jelliott@arista.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50982 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751079AbdKNGlx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2017 01:41:53 -0500
Content-Disposition: inline
In-Reply-To: <CA+c2rSiciLQiJqzfdwo9p4_POQSZW1mmaQCfsMwPvm4td2wLAw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jay Elliott <jelliott@arista.com> wrote:
> On Sat, Nov 11, 2017 at 10:27 AM, Florian Westphal <fw@strlen.de> wrote:
> > It also looks wrong.
> > let ct->timeout be 1000.
> > let nfct_time_stamp be 0x80000000
> >
> > Then ct->timout is capped to 0x7fffffff.
> > Next check considers the timeout to be expired, as 0x7fff... - 0x800 < 0.
> 
> Thanks for pointing that out; it does look like something that could
> cause troubles.
> 
> Is it alright if I submit a fix to this as a separate patch?  I
> *think* I have a solution (pending some testing), but I also think
> it's outside of the scope of this commit since it's a pre-existing
> problem so I'd like to fix it separately.

Sorry, I am not following.  This problem is added with this patch.

> > So I guess best bet is to actually do a 64bit multiplication, as you
> > did, then truncate.
> >
> > Please use u64 for this (the u_intXX_t types are prehistoric leftovers).
> 
> So to clarify, are changing the u_int64_t variables to u64 and fixing
> the case where nfct_time_stamp >= 0x8000... the only changes that need
> to be made based on the v2 patch I sent out?

Yes, I think so, only changes in nfnetlink.c are needed, i.e. (totally untested):

-       u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+       u64 timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+
+	if (timeout > INT_MAX)
		timeout = INT_MAX;

-	ct->timeout = nfct_time_stamp + timeout * HZ;
+	ct->timeout = nfct_time_stamp + (u32)timeout;

        if (test_bit(IPS_DYING_BIT, &ct->status))
                return -ETIME;
@@ -1762,6 +1765,8 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
        int err = -EINVAL;
        struct nf_conntrack_helper *helper;
        struct nf_conn_tstamp *tstamp;
+       u64 timeout_nla;

        ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
        if (IS_ERR(ct))
@@ -1770,7 +1775,11 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
        if (!cda[CTA_TIMEOUT])
                goto err1;

-       ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+       timeout_nla = ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+       if (timeout_nla > INT_MAX)
+               timeout_nla = INT_MAX;
+       ct->timeout = nfct_time_stamp + timeout_nla;

