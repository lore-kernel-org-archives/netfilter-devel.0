From: don-netfil@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack and ICMP errors
Date: Tue, 15 Apr 2003 10:03:16 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <16028.15188.332538.355740@isis.cs3-inc.com>
References: <20030411101702.14701.14873.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Balazs Scheidler <bazsi@balabit.hu>, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030411101702.14701.14873.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


[continuing a topic from 4/11]

The real job of conntrack is to track the states of the two machines
communicating through the firewall.  This is, in general, not really
possible for several reasons.

The one pointed out in this exchange is that we don't really know how
the endpoints will react to the packets they receive.  I think the
biggest problem is that we don't know when an endpoint discards a
connection, and we don't want to fill up the conntrack table with
connections that the endpoints have discarded.

As far as I can tell UDP is essentially hopeless since it doesn't even
support the concept of connection.  I can't see anything better than
relatively short timeouts.  Perhaps it depends on what you hope to do
with the connection data.  (Any answers other than NAT?)

For the case of TCP, however, I do have a proposal.
If you keep the last ack# that you've sent in each direction you can
do a weak sort of check of whether a participant still thinks the
connection is alive by (re)sending that last ack (with no other
payload) and hoping to get back a reset if the participant thinks the
connection was closed.  I suggest that this technique be used either
when you have some reason to suspect the connection is closed (such 
as the ICMP messages in the discussion), or when you've not heard any
packets for a long time (it's reasonably likely that one side or the
other has rebooted in the mean while), or for that matter, when you
find the conntrack table filling up and want to reclaim some space. 

It might be better to send some packet that ought to generate a
response in the still-open case, but it would still be dangerous to
interpret no response as an indication that the connection should be
closed.  On the other hand, if this connection is preventing other
possibly useful connections from being created, it might make sense
to interpret several non-responses as reason to reset the connection.
This sort of thing should clearly be controlled by policy set by the
firewall administrator.

I've been hoping to try this but have not managed to get there yet.
I'm hoping that by mentioning it here either
- someone will point out why it's a bad idea or
- someone else will implement it and try it

One more point: if you do get back a reset, you should not only use
it locally but also forward it to the other participant.
