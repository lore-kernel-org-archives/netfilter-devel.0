From: jamal <hadi@cyberus.ca>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: 25 Aug 2004 07:41:41 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093434101.1041.163.camel@jzny.localdomain>
References: <1092407190.2402.120.camel@nienna.balabit>
	<20040819110646.GJ3921@sunbeam.de.gnumonks.org>
	<20040822204326.GA25567@sch.bme.hu>
	<20040824183752.GM26877@sunbeam.de.gnumonks.org>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040824183752.GM26877@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


As Harald says its a little heavyweight for what you guys need to do.
And it doesnt run on IP proper.
We are going to explore and probably use TIPC for ForCES as one of the
options for transport in the case of non-IP.
For IP we are thinking a dual transport approach. Two sockets, one
UDP/multicast while other is TCP|SCTP/unicast reliable. 
Send always on UDP multicast; respond always on multicast. Reap the
benefits of multicast. Do NOT retransmit on multicast, retransmits of
either queries/updates etc are done over unicast.
This simple technique is borrowed from OSPF.

If you are interested we can discuss this more.

cheers,
jamal

On Tue, 2004-08-24 at 14:37, Harald Welte wrote:
> On Sun, Aug 22, 2004 at 10:43:26PM +0200, KOVACS Krisztian wrote:
> > 
> >   Hi,
> > 
> > On Thu, Aug 19, 2004 at 01:06:46PM +0200, Harald Welte wrote:
> > > >         So, do anyone know of anything which could be used by ct_sync?
> > > >         (It has to be a semi-reliable, connectionless multicast protocol
> > > >         with a _very_ low overhead.)
> > > 
> > > everything I've seen so far about reliable multicast is inherently
> > > complex.
> > 
> >   Oops, I've just found TIPC. Does anyone know enough details of TIPC to
> > judge if its reliable multicast service would be useful for us? I've just
> > downloaded the IETF draft, and it seems to me that the reliable multicast
> > service provided by TIPC may be useful (section 2.9 of the draft). Any
> > ideas?
> 
> Unfortunately I did only learn about TIPC recently.  But looking at the
> IETF draft and the current implementation, I think it is probably too
> expensive.  Another argument is to not base ct_sync on something big
> outside of the official kernel tree that is not under our control..
