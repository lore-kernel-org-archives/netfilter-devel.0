From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: xt_TCPOPTSTRIP: fix possible mangling
 beyond packet boundary
Date: Wed, 15 May 2013 16:48:24 +0200
Message-ID: <20130515144824.GG18095@breakpoint.cc>
References: <1368619552-30635-1-git-send-email-pablo@netfilter.org>
 <20130515123336.GE18095@breakpoint.cc>
 <20130515135935.GA1605@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48563 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331Ab3EOOsZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 10:48:25 -0400
Content-Disposition: inline
In-Reply-To: <20130515135935.GA1605@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 15, 2013 at 02:33:36PM +0200, Florian Westphal wrote:
> > > +	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
> > >  	unsigned int optl, i, j;
> > >  	struct tcphdr *tcph;
> > >  	u_int16_t n, o;
> > >  	u_int8_t *opt;
> > > +	int len;
> > > +
> > [..]
> > > +	len = skb->len - tcphoff;
> > > +	if (len < sizeof(struct tcphdr))
> > 
> > I think this needs a cast 'if (len < (int) sizeof( ...?
> 
> I'm not hitting any compilation warning.

len is signed, thats why i asked, and, afair recall sizeof
is unsigned and thus len is treated as unsigned.

Test program yields:

#include <stdio.h>
#include <stdlib.h>
int main (int argc, char *argv[])
{
        char foo[20];
        int len = atoi(argc > 1 ? argv[1] : "0");
        if (len < sizeof(foo))
                printf("%d lt %lu\n", len, sizeof(foo));
        else
                printf("%d ge %lu\n", len, sizeof(foo));
        return 0;
}
t.c: In function 'main':
t.c:7:10: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
./t -42
-42 ge 20

gcc version 4.6.3.
