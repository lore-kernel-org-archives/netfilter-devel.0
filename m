From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_ct_helper: use
 nf_ct_iterate_cleanup to unlink helper objs
Date: Sun, 21 May 2017 13:10:47 +0200
Message-ID: <20170521111047.GF1004@breakpoint.cc>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
 <1495345149-57674-3-git-send-email-zlpnobody@163.com>
 <20170521081521.GD1004@breakpoint.cc>
 <CAML_gOc1OHEc_evYoXj2f0O1CMGLVc0MMNYgVE0xNtzXPXNJtQ@mail.gmail.com>
 <20170521103153.GE1004@breakpoint.cc>
 <CAML_gOd3gqwTisxo64nxRbUoq_1QovyLTf=hxG=ks-Tv0h_tMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37148 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751474AbdEULLh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 07:11:37 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOd3gqwTisxo64nxRbUoq_1QovyLTf=hxG=ks-Tv0h_tMw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@gmail.com> wrote:
> Yes, here we should use clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
> (For IPS_DST_NAT_DONE, we don't care about it, so we can
> leave it unchanged.)

Oh, right.

> > Thats also broken(racy).  We have to audit all the non-atomic writes of
> > ct->status and change them to set/clear_bit()...
> 
> I audited the related codes just now, this seems to be the last
> ct->status writer which use non-atomic bit operation(of course,
> except these unconfirmed ct->status writer).
> 
> I will have a further and closer check. If you are not opposed to,
> I can send a related patch to fix this. :)

That would be great, thanks Liping!
