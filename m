From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack tree
Date: Thu, 17 Mar 2005 04:54:18 +0900 (JST)
Message-ID: <200503161954.j2GJsIhi017839@toshiba.co.jp>
References: <200503160648.j2G6mXVV014699@toshiba.co.jp>
	<200503161922.j2GJMGZE006465@toshiba.co.jp>
	<423889E6.1000703@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
In-Reply-To: <423889E6.1000703@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


From: Patrick McHardy <kaber@trash.net>
Date: Wed, 16 Mar 2005 20:32:54 +0100

> Yasuyuki KOZAKAI wrote:
> 
> > Oh, this is bad code. What I really want to do is following.
> > Anyway, this issue would be resolved.
> > 
> >  static struct ipt_match helper_match = {
> >  	.name		= "helper",
> > -	.match		= &match,
> >  	.checkentry	= &check,
> >  	.me		= THIS_MODULE,
> >  };
> >  
> >  static int __init init(void)
> >  {
> > -	need_ip_conntrack();
> > +	if (!request_module("ip_conntrack"))
> > +		helper_match.match = &ip_match;
> > +	} else if (!request_module("nf_conntrack"))
> > +		helper_match.match = &nf_match;
> > +	} else
> > +		return -1;
> > +
> >  	return ipt_register_match(&helper_match);
> >  }
> 
> That won't work when nf_conntrack is already loaded. Do you think
> it is necessary to allow people to build both as modules?

You're right. #ifdef or other staff is needed.

>                                                           It would
> be easier to just force them to choose, and would probably result
> in more people actually using it since ip_conntrack wouldn't be used
> by default anymore.

But I want this flexibility if possible so that we can test matches/targets
with ip_conntrack/nf_conntrack without recompiling.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
