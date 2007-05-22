From: Patrick Schaaf <bof@bof.de>
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 08:46:13 +0200
Message-ID: <20070522064613.GA27619@oknodo.bof.de>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
	<Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Darren.Reed@Sun.COM
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
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

> > As an example, using squid on your Linux firewall/router in
> > transparent proxying mode requires that squid has some code
> > in it that knows how to talk to Linux in order to discover the
> > original destination
> 
> As with most client-side transparent proxies, it uses the Host: header.

And when the Host: header is missing, it uses the SO_GET_ORIGINAL_DESTINATION
getsockopt call, a speciality of netfilter, as described by the $OP above.

Anyway, regarding the original request, I don't think it is sensible to
expect from netfilter developers to invent such a library, especially
when the scope is desired to be abstracting from netfilter. As an analogy,
it was neither Microsoft nor Unix vendors that invented the Apache
Runtime Library, it was the Apache developers. Bringing back that
analogy, it would be a task for the developers of a vastly successful
high level firewall application running on all kinds of basic firewalls.

Personally, I think that it would be bound to fail anyway, because
different basic firewall structures are very different in what and
how they operate. But that's just the fast opinion of somebody who
has neither need nor vision for userlevel firewall applications
and systems other than Linux/netfilter.

best regards
  Patrick
