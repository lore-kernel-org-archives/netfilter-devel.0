From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Thu, 23 Oct 2003 16:29:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F97E5CA.E561289D@fy.chalmers.se>
References: <3F964F9D.D5C69498@fy.chalmers.se> <20031023090238.GE1418@sunbeam.de.gnumonks.org> <3F97A4C5.982725B0@fy.chalmers.se> <20031023105739.GL1418@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > > What about using iptables?  Does it produce a similar behaviour?
> >
> > I don't know. I'll check at some point, but not right away...
> 
> That would be helpful, since it would become a way more important bug if
> it was in iptables.

The bug appears to be ipchains specific. Meaning that I can confirm that
my kernel does *not* crash [after VMware guest OS reboot] if I use
iptables to implement equivalent setup. A.
