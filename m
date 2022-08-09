Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45838C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 16:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbiHIQH3 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbiHIQH2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 12:07:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F81132
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 09:07:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oLRlI-000834-Cl; Tue, 09 Aug 2022 18:07:20 +0200
Date:   Tue, 9 Aug 2022 18:07:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
Message-ID: <20220809160720.GA26023@breakpoint.cc>
References: <20220809131635.3376-1-fw@strlen.de>
 <20220809131635.3376-4-fw@strlen.de>
 <SA1PR15MB51371BED076EBB8032CC6F3EBD629@SA1PR15MB5137.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <SA1PR15MB51371BED076EBB8032CC6F3EBD629@SA1PR15MB5137.namprd15.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alexander Duyck <alexanderduyck@fb.com> wrote:
> > -	spin_lock_bh(&nf_ftp_lock);
> > -	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
> > -	if (!fb_ptr) {
> > -		spin_unlock_bh(&nf_ftp_lock);
> > -		return NF_ACCEPT;
> > -	}
> > +	spin_lock_bh(&ct->lock);
> > +	fb_ptr = skb->data + dataoff;
> > 
> >  	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
> >  	seq = ntohl(th->seq) + datalen;
> 
> Rather than using skb_header_pointer/skb_linearize is there any reason why you couldn't use pskb_may_pull? It seems like that would be much closer to what you are looking for here rather than linearizing the entire buffer. With that you would have access to all the same headers you did with the skb_header_pointer approach and in most cases the copy should just be skipped since the headlen is already in the skb->data buffer.

This helper is written with the assumption that everything is searchable
via 'const char *'.

I'm not going to submit a patch to -net that rewrites this,
and I'm not sure its worth it to spend time on it for -next either.
