From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/8] netfilter: Convert print_tuple functions to return
 void
Date: Wed, 05 Nov 2014 15:26:34 -0800
Message-ID: <1415229994.6634.35.camel@perches.com>
References: <20141105192426.348510548@goodmis.org>
	 <20141105192544.214361386@goodmis.org> <20141105232314.GA3195@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:52223 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796AbaKEX0i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:26:38 -0500
In-Reply-To: <20141105232314.GA3195@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2014-11-06 at 00:23 +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 05, 2014 at 02:24:29PM -0500, Steven Rostedt wrote:
> > From: Joe Perches <joe@perches.com>
> > 
> > Since adding a new function to seq_file (seq_has_overflowed())
> > there isn't any value for functions called from seq_show to
> > return anything.   Remove the int returns of the various
> > print_tuple/<foo>_print_tuple functions.
[]
> I replied to this yesterday, but it seems some spam filter also
> munched it. One comment below.
> 
> > @@ -202,9 +203,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
> >  	if (l4proto->print_conntrack)
> >  		l4proto->print_conntrack(s, ct);
> >  
> > -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> > -			l3proto, l4proto))
> > -		goto release;
> > +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> > +		    l3proto, l4proto);
> >  
> >  	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
> >  		goto release;
> 
> seq_print_acct returns seq_printf which is now void. I guess you have
> to remove this check too.

seq_printf shouldn't be void yet.
There are still other places that need conversion.

> >  	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
> >  		goto release;
> 
> And here.

Eventually I trust it will be fixed, but these
patches are an intermediate step on the way there.


