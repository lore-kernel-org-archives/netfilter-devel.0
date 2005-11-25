From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack & NAT
Date: Fri, 25 Nov 2005 13:54:19 +0900 (JST)
Message-ID: <200511250454.jAP4sJeD003744@toshiba.co.jp>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmnh018866@toshiba.co.jp>
	<Pine.LNX.4.64.0511231342490.16555@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: olenf@ans.pl
In-Reply-To: <Pine.LNX.4.64.0511231342490.16555@bizon.gios.gov.pl>
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

From: Krzysztof Oledzki <olenf@ans.pl>
Date: Wed, 23 Nov 2005 14:44:01 +0100 (CET)

> On Wed, 23 Nov 2005, Yasuyuki KOZAKAI wrote:
> 
> >
> > Hi,
> >
> > From: Krzysztof Oledzki <olenf@ans.pl>
> > Date: Wed, 23 Nov 2005 12:30:07 +0100 (CET)
> >
> >> Hello,
> >>
> >> As we have now working nfnetlink in nf_conntrack (thanks!) I'm wonder if
> >> there any plans for porting IPv4 NAT to nf_conntrack
> >
> > Of cause we have. But
> 
> Where can I find it?

We have 'plan', but no code yet AFAIK, sorry :)

> >>                                                      and adding NAT
> >> support for IPv6?
> >
> > Never ever. You can learn why people don't want to do it from many sources.
> > For example, You can use many addresses in IPv6 world. And I don't want people
> > get troubles due to NAT traversal issues in IPv6 world.
> 
> Oh. So how we are going to make transparent proxy, port redirects, etc 
> possible?

At first, I will not implement IPv6 NAT at least, but I don't know
what other people think.

And about transparent proxy, port redirects, load balancer, and so on,
indeed currently we seems that we don't have smarter and de facto standard
solutions.

I wonder why they haven't come up yet, but anyway, I believe people can
develop smarter solutions than copied and pasted IPv4 NAT (It's possible that
just I don't know them and someone might have already developed them).
I think it's still early to give up on.

-- Yasuyuki Kozakai
