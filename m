From: Oskar Andreasson <blueflux@koffein.net>
Subject: RE: Connecttrack Access
Date: Mon, 16 Dec 2002 12:57:10 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212161254040.2536-100000@laptop1.agatha>
References: <MFEGKJBMPCLPMMMBAACNGEOJODAA.jfowler@westrope.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeremy Fowler <jfowler@westrope.com>
In-Reply-To: <MFEGKJBMPCLPMMMBAACNGEOJODAA.jfowler@westrope.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jeremy,

I haven't seen any reply to this so far so... There is one such reference 
put together that you will find at 
http://iptables-tutorial.frozentux.net/chunkyhtml/statemachine.html. It is 
unfortunately not perfect, but I have not received any huge complaints 
about the text so far.


On Fri, 6 Dec 2002, Jeremy Fowler wrote:

> Thanks, I found that out. Do you know of a reference somewhere that tells me
> what each column represents for each protocol. Do you know of any libraries that
> parses that file into a linked list of C structures?
> 
> > -----Original Message-----
> > From: Harald Welte [mailto:laforge@gnumonks.org]
> > Sent: Thursday, December 05, 2002 2:40 PM
> > To: Jeremy Fowler
> > Cc: netfilter-devel@lists.netfilter.org
> > Subject: Re: Connecttrack Access
> >
> >
> > On Fri, Nov 22, 2002 at 12:41:03PM -0600, Jeremy Fowler wrote:
> > > New to the list, so sorry if this has been asked before. I was wondering if
> > > there is a library interface to access the connecttrack module's MASQUERADE
> > > feature to get a list of what port/ipaddr assignments. Basically
> > looking for a
> > > way to let a user-space program track SNAT connections and port usage.
> >
> > read and parse /proc/net/ip_conntrack.
> >
> > --
> > Live long and prosper
> > - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> > ============================================================================
> > GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-
> > V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
> >
> 
> 
> 

-- 
----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
