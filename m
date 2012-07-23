From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv,
 cleanup (fix gcc-4.7)
Date: Mon, 23 Jul 2012 15:08:15 +0200
Message-ID: <20120723130815.GC15807@1984>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
 <1343042946.2626.10727.camel@edumazet-glaptop>
 <1343043528.2626.10755.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1343043528.2626.10755.camel@edumazet-glaptop>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 23, 2012 at 01:38:48PM +0200, Eric Dumazet wrote:
> On Mon, 2012-07-23 at 13:29 +0200, Eric Dumazet wrote:
> > On Mon, 2012-07-23 at 12:38 +0200, pablo@netfilter.org wrote:
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > This patch seems to be a mere cleanup that moves the parameter parsing
> > > code to add_param_to_argv.
> > > 
> > > But, in reality, it also fixes iptables whe compiled with gcc-4.7.
> > > 
> > > Moving param_buffer declaration out of the loop seems to resolve the
> > > issue. gcc-4.7 seems to be generating bad code regarding param_buffer.
> > > 
> > > @@ -380,9 +380,9 @@
> > >                         quote_open = 0;
> > >                         escaped = 0;
> > >                         param_len = 0;
> > > +                       char param_buffer[1024];
> > > 
> > >                         for (curchar = parsestart; *curchar; curchar++) {
> > > -                               char param_buffer[1024];
> > > 
> > >                                 if (quote_open) {
> > >                                         if (escaped) {
> > > 
> > > But I have hard time to apply this patch in such a way. Instead, I came
> > > up with the idea of this cleanup, which does not harm after all (and fixes
> > > the issue for us).
> > > 
> > > Sorry, I didn't have the time to further debug this issue, but it would be
> > > worth to investigate what's going wrong and ping gcc people.
> > 
> > Bug seems that iptables forgot that "char param_buffer[1024];" can
> > disappear at the end of the block :
> > 
> > for (curchar = parsestart; *curchar; curchar++) {
> > 	char param_buffer[1024];
> > 	...
> > }
> > 
> > // here param_buffer[1024] is lost, so any var pointing 
> > // to it can mess stack
> > 
> > previous gcc were probably not so aggressive.
> 
> Oh well, add_argv() does a strdup(), so iptables code seems fine.

I think so, I don't find any possible dereference to param_buffer out
of that loop and it does strdup accordingly.
