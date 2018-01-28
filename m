From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] netfilter: xt_hashlimit: do not allow empty names
Date: Sun, 28 Jan 2018 22:54:29 +0100
Message-ID: <20180128215429.GB5906@breakpoint.cc>
References: <1517154099.3715.77.camel@gmail.com>
 <1517162045.3715.78.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35298 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752419AbeA1V5U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Jan 2018 16:57:20 -0500
Content-Disposition: inline
In-Reply-To: <1517162045.3715.78.camel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Sun, 2018-01-28 at 07:41 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Syzbot reported a WARN() in proc_create_data() [1]
> > 
> > Issue here is that xt_hashlimit does not check that user space provided
> > an empty table name.
> 
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
> >  net/netfilter/xt_hashlimit.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> > index 5da8746f7b88ff4c9446f256e542e823a6a561b0..eae732e013df92a364b500645360d4606c283a75 100644
> > --- a/net/netfilter/xt_hashlimit.c
> > +++ b/net/netfilter/xt_hashlimit.c
> > @@ -894,6 +894,8 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
> >  			return -ERANGE;
> >  	}
> >  
> > +	if (!name[0])
> > +		return -EINVAL;
> >  	mutex_lock(&hashlimit_mutex);
> >  	*hinfo = htable_find_get(net, name, par->family);
> >  	if (*hinfo == NULL) {
> 
> I wonder if we should also check if name includes a '/' ?
> 
> if (!name[0] || strchr(name, '/'))
>     return -EINVAL;

I think there should be a helper for this to reject

- 0 length
- /
- .
- ..

in hashlimit case name is IFNMASIZ so we could even use
dev_valid_name() here.
