From: Brian Deep <brian_deep@yahoo.com>
Subject: Re: Netfilter Inconsistency?
Date: Tue, 27 May 2003 10:37:25 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030527173725.86069.qmail@web20006.mail.yahoo.com>
References: <20030523200112.GR3077@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030523200112.GR3077@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--- Harald Welte <laforge@netfilter.org> wrote:
> On Thu, May 15, 2003 at 10:49:51AM -0700, Brian Deep
> wrote:
> 
> >  I can add and delete rules fine and open up
> > connections correctly using the SNAT rules, but if
> I
> > change the source IP address on the SNAT rule I
> run
> > into problems.  The SNAT rule is added correctly
> and
> > verified using iptables userspace, but when the
> > connection actually gets NAT'd, it gets the source
> IP
> > address of the SNAT rule I had in previous.  I
> have
> > tried manually inserting and appending  SNAT
> rules,
> > but the connection is still NAT'd with the
> previous
> > rule source IP.  At some point, this rule "time's
> out"
> > and I am able to correctly add my SNAT rule in.
> 
> the NAT tables are only traversed for every first
> packet of a
> connection. if you alter the ruleset, it will only
> work for new
> connections.  All further packets within this
> connection will be
> transformed according to what was determined by the
> first packet.
> 

Oops, I meant to say that I open up a new connection
based on the new NAT rule and it uses(is NAT'd
according to) the previously removed NAT rule instead
of newly created one.   Iptables shows only one rule
in place, the new one, but tcpdump shows the packets
NAT'd according to the old rule.  I have to wait for
connection tracking to time-out the connection based
on the old rule before the new connection is NAT'd
correctly.
My filter rules specify a source port address, as my
client binds to a port before connecting so that it
hits the correct NAT rule.  If I close the connection
and open a new connection on the same source port
(seconds later) I run into this NAT/connetion-tracking
problem.

Thanks,
-- Brian

__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
