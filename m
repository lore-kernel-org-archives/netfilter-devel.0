From: Patrick Schaaf <bof@bof.de>
Subject: Re: More on ip_conntrack problems
Date: Wed, 10 Jul 2002 10:06:12 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020710100612.B17608@oknodo.bof.de>
References: <1026285021.14566.80.camel@trent.nin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing List <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: alex <alex@bennee.com>
Content-Disposition: inline
In-Reply-To: <1026285021.14566.80.camel@trent.nin>; from alex@bennee.com on Wed, Jul 10, 2002 at 08:10:20AM +0100
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Alex,

[snip good description of general situation]

> A few questions:
> 
> a) Am I measuring things correctly?

You are, but one thing is missing, if I'm correct in the explanation below.
We need to know the distribution of conntrack states from your gateway:

grep ^tcp /proc/net/ip_conntrack | awk '{print $4}' | sort | uniq -c

Read on:

> b) Should the number of connections on ip_conntrack be broadly the same
> as the internal machines understanding of connections (netstat output)?

No. I'll explain why:

How many new TCP connections per seconds is that freenet thing doing?
Let's call this CPS.

How long living are the individual connections, in seconds, as seen
by the server? Let's call this CT (connection time.)

These two numbers are essential for analysis. You want to know them
for any connection tracking system you are responsible for.

Now, assume that I know how long conntrack is supposed to keep record
of a connection, after the server and client are finished with it.
Let's call that ET (extra time.)

This means that the conntracking box sees each CT connection as
a CT+ET connection. On the server, you can expect, in netstat,
to see CPS*CT connections.  And on the conntracking box, you
expect CPS*(CT+ET).

Let nS := CPS * CT, be the number of connections on the server.
Let nC := nS + CPS * ET, be the number of connections on the conntracker.

What can we do, given only nS and nC? Well, (nC - nS) appears to
be equal to CPS * ET. Thus, knowing ET to be X seconds, and given
your values of nS := 41, nC := 1688, we can estimate CPS to be 1647/X.

Let's assume I know X to be 10 seconds. Then, you should have about 170
connections per second. A good load - what are these doing? On the other
extreme, still assuming normal operation, you could have X as 120 seconds,
i.e. 13 connections per second. Still a good load - what is that freenet
thing doing to your home network???

To know the real answer, i.e. get a handle on X, you need to learn
the conntrack state distribution on your gateway, as per the commands
given above. The normal closing states have these (inactivity) timeouts:

	2 MINS,     FIN_WAIT
	2 MINS,     TIME_WAIT
	10 SECS,    CLOSE
	60 SECS,    CLOSE_WAIT
	30 SECS,    LAST_ACK

For example, on one of my transproxy machines, I currently see this
when I run the given commands:

208	CLOSE
156	CLOSE_WAIT
14905	ESTABLISHED
3	FIN_WAIT
55	SYN_RECV
39	SYN_SENT
11953	TIME_WAIT

The dominant terminating state is the TIME_WAIT state, so I'm at 120
seconds ET, and estimate CPS to be 99 connections per second. That's
even true...

If other closing states dominate for your freenet thing, you can do
a weighted calculation based on the frequency data and timeouts,
and arrive at an "average X".

Alternatively, you can measure CPS by other means, and calculate X
from that side.

You can see that the extra knowledge of the distribution of closing
states, if statistically significant (*), gives you all the knowledge
to understand the situation fully.

I hope this text could help you.

best regards
  Patrick

(*) this comment is significant. I have the luxury of large numbers.
You could need to sample several times, and create aggregate averages.
