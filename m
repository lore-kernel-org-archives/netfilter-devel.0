From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack performance issues - also semantic issues
Date: Sun, 19 Jan 2003 08:51:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030119075102.GF12401@oknodo.bof.de>
References: <20030118232752.26497.32589.Mailman@kashyyyk> <15914.20503.476455.344137@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15914.20503.476455.344137@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Don & all,

On Sat, Jan 18, 2003 at 11:13:27PM -0800, Don Cohen wrote:
> 
> [This is not to the list, but feel free to put it or replies to 
> parts of it there if you think they're of general interest.]

I'll do so. Your point about the post-dequeueing hook warrants
thinking about by the masses :)

> I have one big complaint with conntrack, which is related to
> performance but also semantics.

I don't think it's semantics per se, to me you are talking about an
(important) implementation detail. Fixing it will _hopefully_ not
require new semantics (as understood by the end user).

> The semantic problem is that not all packets are forwarded.
> What we really want is two different conntrack hooks.
> The first as soon as the packet arrives classifies it in terms of
> what has been seen before.  This is used by filters, schedulers, etc.
> However that one does NOT update the conntrack data structure.

It is already the case that a NEW contrack structure is put into the
_hashtable_ only after running through all the filters - as the last
thing in POSTROUTING. It happens right at the point where the packet
will then be ENqueued to the outgoing network device.

If I understand your complaint correctly, it is really two complaints in one:

1) that a NEW conntrack need not be allocated in full.
2) that the putting into hashes (which presupposes allocation in full),
   happens before ENqueueing the packet, and not after DEqueueing,
   so potential drops by egress shaping are not seen and handled.

Addressing point 1) would help overhead in the case of the filter
rules themselves handling a DoS attack (by dropping suitable packets).
Addressing point 2) would _additionally_ cover the CLS/SCHED policing.
2) does not make much sense if the overhead reduction of 1) has not
been already accomplished. 1) makes sense by itself, and can be
implemented without touching the base network stack.

Would you agree that the two points are related, but independant?

Fixing point 1), would need no change in semantics (but changes in
the internal APIs): for each packet which now gets a NEW conntrack,
instead, let the skbuff reference a shared, unspecific "THE NEW CONNTRACK".
Only when an individual conntrack is required (by NAT module calls on a
packet which has the shared, unspecific "THE NEW CONNTRACK"), will a
real conntrack structure be allocated, on demand. The same must happen
on the POSTROUTING conntrack hook, before the individual NEW connection's
conntrack is put into the hashes. "ALLOCATE ON DEMAND" is the general theme.
Of course, almost every place in iptables where now we assume we have an
individual conntrack, must learn to individualize "THE NEW CONNTRACK"
when encountered. Big code audit time. Always a good thing - Don, is
that a job for you, if people commit to taking the changes? :-)

Regarding point 2), there is a (temporal) semantic change involved.
With that approach, it takes potentially much longer until the
conntrack is created. The packet can sit in the output queue for
quite a long time, if the output interface is a slow one, and filled
to the brim. So, the question is, are there real world protocols
where several packets back to back go from A to B, before packets
flow back? Such protocols already have a window of opportunity
for SNAFU in the current scheme, but updating the hashes after
the output queue may aggravate the symptoms. (I have no protocol
in mind, just being paranoid...)

best regards
  Patrick
