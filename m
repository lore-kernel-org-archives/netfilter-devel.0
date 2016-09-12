From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Mon, 12 Sep 2016 15:18:18 +0200
Message-ID: <20160912131818.GE27566@breakpoint.cc>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
 <20160911211226.GB6572@breakpoint.cc>
 <20160912120902.GA3654@salvia>
 <20160912122257.GC27566@breakpoint.cc>
 <20160912123253.GA9791@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>, nevola@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56348 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932172AbcILNSZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 09:18:25 -0400
Content-Disposition: inline
In-Reply-To: <20160912123253.GA9791@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Sep 12, 2016 at 02:22:57PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sun, Sep 11, 2016 at 11:12:26PM +0200, Florian Westphal wrote:
> > > > My first thought was that it would be better to just support one single
> > > > sreg (the queue number) and eventually externalize the hashing/queue
> > > > selection:
> > > > 
> > > > queue num jhash ip saddr . ip daddr mod ...
> > > > 
> > > > Problem is that with plain jhash we won't get a symmetric hash
> > > > for origin and reply, so for this we would need a new expression/hash
> > > > mode.
> > > 
> > > Are you think of xor hashing to provide the symmetry? Downside is that
> > > bad tuple selection may result in poor distribution, but this is
> > > something we can document.
> > 
> > No, I was thinking of a new hash mode to do this, e.g. just do same
> > what current nfqueue selection does: hash lower address first.
> 
> Currently we have one single register pointing to the entire tuple
> concatenation that we hash, we would need to support multiple
> registers as input, check that they are consecutive. Then, the logic
> to compare the data. And a way to express this in syntax.

Ugh.  Ok, lets ignore this for now.
