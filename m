From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: defense against conntrack attacks
Date: Sun, 16 Jun 2002 22:55:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206162255.24397@henrik.marasystems.com>
References: <20020615132638.84C444509@lists.samba.org> <15627.49630.258601.138681@isis.cs3-inc.com> <20020616221633.J2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	don-nf@isis.cs3-inc.com (Don Cohen)
In-Reply-To: <20020616221633.J2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 16 June 2002 22.16, Harald Welte wrote:

> > If you recall my posting in April, you won't be surprised that I
> > want to put the connection creation code well after the current
> > postrouting hook.  After that hook the packet is enqueued for
> > traffic control, and it can be dropped between then and when it
> > is dequeued to be sent.  So I'd like to create a new hook after
> > that dequeue, and this is where I propose to create the
> > connection record.
>
> This sounds odd.  First, this is too revolutionary to the overall
> concept.
>
> Second, you need conntrack information before postrouting:
>
> - for doing DNAT [which _needs_ to happen before the routing
> decision] - for any stateful rules in the FORWARD chain of the
> filter table - for any stateful rules in the INPUT chain of the
> filter table


This proposal reminds me a lot of a similar proposal I made some 
(many) months ago.

Instead of creating the conntrack entry upon entry, create it "just in 
time", i.e. when first code requiring a conntrack entry is executed. 
Simply put any call to ip_conntrack_get().

This would be

  Any NAT target
  Any state/conntrack match
  etc..
  with a counter-measure in the nat table to not cause it to 
automatically initiate tracking (today calls ip_conntrack_get to tell 
if the packet should enter the table or not).

This approach makes the "conntrack exception" quite natural in most 
ruleset by my opinion; if you don't have any state or NAT rules 
touching the connection then it won't be tracked, but adds a bit of 
complexity to the design and collides with the sub-goal of being able 
to later add NAT rules without the risk of disturbing existing 
connections.

After our discussions the last time manual excepmtion is probably 
preferable I think. Less risk of confusion over what is being tracked 
and what not, and considerably less of a design change. But I have 
not yet fully given up the "just in time" idea.

Regards
Henrik
