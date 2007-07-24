From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH] Netfilter Kconfig: Expose IPv4/6 connection tracking
	options by selecting NF_CONNTRACK
Date: Tue, 24 Jul 2007 10:21:12 +0300
Message-ID: <200707241021.12890.a1426z@gawab.com>
References: <200707240836.33494.a1426z@gawab.com>
	<20070724055208.GB12946@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>
To: Sam Ravnborg <sam@ravnborg.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070724055208.GB12946@uranus.ravnborg.org>
Content-Disposition: inline
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

Sam Ravnborg wrote:
> On Tue, Jul 24, 2007 at 08:36:33AM +0300, Al Boldi wrote:
> > Replaces NF_CONNTRACK_ENABLED with NF_CONNTRACK and selects it for
> > NF_CONNTRACK_IPV4 and NF_CONNTRACK_IPV6
> >
> > This exposes IPv4/6 connection tracking options for easier Kconfig
> > setup.
> >
> > Signed-off-by: Al Boldi <a1426z@gawab.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > --- a/net/netfilter/Kconfig	2007-07-09 06:38:52.000000000 +0300
> > +++ b/net/netfilter/Kconfig	2007-07-24 08:28:06.000000000 +0300
> > @@ -25,8 +25,7 @@ config NETFILTER_NETLINK_LOG
> >  	  and is also scheduled to replace the old syslog-based ipt_LOG
> >  	  and ip6t_LOG modules.
> >
> > -# Rename this to NF_CONNTRACK in a 2.6.25
> > -config NF_CONNTRACK_ENABLED
> > +config NF_CONNTRACK
> >  	tristate "Netfilter connection tracking support"
> >  	help
> >  	  Connection tracking keeps a record of what packets have passed
> > @@ -40,10 +39,6 @@ config NF_CONNTRACK_ENABLED
> >
> >  	  To compile it as a module, choose M here.  If unsure, say N.
> >
> > -config NF_CONNTRACK
> > -	tristate
> > -	default NF_CONNTRACK_ENABLED
> > -
> >  config NF_CT_ACCT
> >  	bool "Connection tracking flow accounting"
> >  	depends on NF_CONNTRACK
> > --- a/net/ipv4/netfilter/Kconfig	2007-07-09 06:38:50.000000000 +0300
> > +++ b/net/ipv4/netfilter/Kconfig	2007-07-24 08:27:39.000000000 +0300
> > @@ -7,7 +7,7 @@ menu "IP: Netfilter Configuration"
> >
> >  config NF_CONNTRACK_IPV4
> >  	tristate "IPv4 connection tracking support (required for NAT)"
> > -	depends on NF_CONNTRACK
> > +	select NF_CONNTRACK
> >  	---help---
> >  	  Connection tracking keeps a record of what packets have passed
> >  	  through your machine, in order to figure out how they are related
> > --- a/net/ipv6/netfilter/Kconfig	2007-07-09 06:38:51.000000000 +0300
> > +++ b/net/ipv6/netfilter/Kconfig	2007-07-24 08:27:54.000000000 +0300
> > @@ -7,7 +7,8 @@ menu "IPv6: Netfilter Configuration (EXP
> >
> >  config NF_CONNTRACK_IPV6
> >  	tristate "IPv6 connection tracking support (EXPERIMENTAL)"
> > -	depends on INET && IPV6 && EXPERIMENTAL && NF_CONNTRACK
> > +	depends on INET && IPV6 && EXPERIMENTAL
> > +	select NF_CONNTRACK
> >  	---help---
> >  	  Connection tracking keeps a record of what packets have passed
> >  	  through your machine, in order to figure out how they are related
>
> This change looks wrong.
> Due to the reverse nature of "select" kconfig cannot fulfill the
> dependencies of selected symbols. So as a rule of thumb select should only
> select symbols with no menu and no dependencies to avoid some of the
> problems that have popped up during the last months.

Granted select is touchy, but this is handled exactly the same as 
NETFILTER_XTABLES, which doesn't show any problems.


Thanks!

--
Al
