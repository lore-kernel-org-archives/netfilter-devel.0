From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Fri, 28 May 2004 13:49:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085744973.1801.62.camel@nienna.balabit>
References: <1085125075.1782.36.camel@nienna.balabit>
	 <Pine.LNX.4.58.0405241212230.27895@chris.camcom.co.uk>
	 <1085398351.1848.30.camel@nienna.balabit>
	 <Pine.LNX.4.58.0405281141020.27895@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0405281141020.27895@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-05-28, p keltezéssel 12:43-kor Chris Wilson ezt írta:
> >   Thanks for the fix. Your patch is obviously correct, somehow I
> > succeeded in messing up the patch :)
> > 
> >   I hope it's otherwise correct.
> 
> I'm afraid I think I found another problem, although it may not be the 
> fault of your patch. After applying it, I cannot load the ip_conntrack 
> module anymore (and therefore not iptable_nat, which depends on it). 
> 
> ip_conntrack generates the following error on startup:
> 
> 	Unable to register netfilter socket option
> 
> Perhaps someone else is using socket option 81? How would I find out?

  Strange, it works for me... :) BTW, SOL_IP setsockopts are handled by
ip_setsockopt(), which calls nf_setsockopt() for from the default branch
of the switch. nf_register_sockopt fails only if you try to register
some option more than once through that funcion...

http://lxr.linux.no/source/net/core/netfilter.c?v=2.4.26#L90

-- 
 Regards,
   Krisztian KOVACS
