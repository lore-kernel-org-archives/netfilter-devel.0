From: Adrian Thurston <adriant@ragel.ca>
Subject: Re: use of a state machine compiler in netfilter?
Date: Wed, 30 Oct 2002 15:05:25 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210301442130.32168-100000@ice.ragel.ca>
References: <20021030095336.T8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021030095336.T8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

What I am interested in doing is writing a sort of scanner generator for
network traffic. I wouldn't want to try replace anything you have already
-- it obviously works well. I want create a simple language that allows
the description of packets of various protocols using atomic elements
such integers, ip addresses, byte structures, etc. You basically have one
rule for each type of packet to be matched and the tool goes and builds a
state machine that can determine what action to apply to incoming packets
in one shot. The rules would be in some regular expression form and would
allow the description of the whole packet. So firewall admins could make
requirements on content and protocol specific stuff. I don't think it
would work for content in stateful protocols though ... for that you'd
have to buffer multiple packets before you could decide anything. That
is probably more of a userspace stream 'filter' program.

-Adrian

On Wed, 30 Oct 2002, Harald Welte wrote:

> On Sat, Oct 26, 2002 at 03:11:19PM -0400, Adrian Thurston wrote:
> >   I am the author of the Ragel State Machine Compiler
> >   (http://www.essemage.com/ragel/). State machines are very useful for
> >   matching a large number of diverse patterns very efficiently.
> > 
> > This leads me to my question. Would the netfilter project benefit from
> > code that built state machines from high-level descriptions of packets
> > that would recognise and ultimately route many different types of packets
> > on one pass?
> 
> Well it is definitely interesting to have something like this.  We currently
> have already multiple classification mechanisms:  There is the tc/u32 style 
> classifier, there is iptables, the upcoming pkttables, the nf-hipac stuff,...
> 
> So (from an academic/educational point of view) it would be great to have
> yet another classification mechanism.
> 
> However, I cannot promise that any of those will go mainline anytime soon.
> 
> > Perhaps you have something like this implemented already?
> 
> no, not that I am aware of.
> 
> > -Adrian
> 
> 
