From: Paul Mielke <paulm@routefree.com>
Subject: another PPTP conntrack problem (no fix this time)
Date: Wed, 29 Jan 2003 16:31:11 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4.2.0.58.20030129161653.01aab6e8@avocetgw>
References: <200301180029.h0I0T3d29430@stilton.routefree.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,paulm@broadon.com,
 philipc@snapgear.com
In-Reply-To: <200301180029.h0I0T3d29430@stilton.routefree.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, Philip.

Thanks for following up on the issues I mentioned in my recent message (BTW there
seems to be something funny happening to my messages to netfilter-devel, as they
seem to appear there either late or never).

I have noticed one more serious problem with the PPTP connection tracking
implementation, but I do not yet have a fix to propose:

The support for generating an ICMP response to an error on a GRE packet is hopelessly
broken.  We ran into this in the course of testing two layers of nested PPTP
connections.  In our particular error case, the second layer of PPTP (only from
Windows XP for some reason) generates a packet with DF set that is too large
by the time the two layers of encapsulation get added.  When the ICMP response
is generated, the rejected packet has already been through NAT.  When the logic
in icmp_error_track attempts to look up the connection in order to NAT the header
of the dropped packet that is buried inside the ICMP response, it is unable to find
the GRE connection tuple.  As a result, it sends the encapsulated header of
the dropped packet back in its un-NATted form.  The original sender who needs to
adjust his MTU can't map the packet to a connection, because the dropped header
is untranslated.  As a result, the connection just hangs and no further traffic gets
through.

Suggestions?  We are working on a fix, but the only idea I have had so far is
pretty distasteful (put a special purpose check for GRE and call a routine that
does a brute force search through the GRE keymap hash looking for a match to the
callid).  It's not even clear this will work.  Failing that, we'd need another hash that
indexes the keymaps in the "inverse" direction, if you see what I mean.

Regards,
Paul

Paul Mielke                        paulm@routefree.com
RouteFree, Inc.                   (650) 739-5377
