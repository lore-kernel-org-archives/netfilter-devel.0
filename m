From: Philip Craig <philipc@snapgear.com>
Subject: Re: another PPTP conntrack problem (no fix this time)
Date: Thu, 30 Jan 2003 17:34:40 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E38D590.9070608@snapgear.com>
References: <4.2.0.58.20030129161653.01aab6e8@avocetgw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, paulm@broadon.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Mielke <paulm@routefree.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Paul Mielke wrote:
> The support for generating an ICMP response to an error on a GRE packet is hopelessly
> broken.  We ran into this in the course of testing two layers of nested PPTP
> connections.  In our particular error case, the second layer of PPTP (only from
> Windows XP for some reason) generates a packet with DF set that is too large
> by the time the two layers of encapsulation get added.  When the ICMP response
> is generated, the rejected packet has already been through NAT.  When the logic
> in icmp_error_track attempts to look up the connection in order to NAT the header
> of the dropped packet that is buried inside the ICMP response, it is unable to find
> the GRE connection tuple.  As a result, it sends the encapsulated header of
> the dropped packet back in its un-NATted form.  The original sender who needs to
> adjust his MTU can't map the packet to a connection, because the dropped header
> is untranslated.  As a result, the connection just hangs and no further traffic gets
> through.
 >
> Suggestions?  We are working on a fix, but the only idea I have had so far is
> pretty distasteful (put a special purpose check for GRE and call a routine that
> does a brute force search through the GRE keymap hash looking for a match to the
> callid).  It's not even clear this will work.  Failing that, we'd need another hash that
> indexes the keymaps in the "inverse" direction, if you see what I mean.

I'm not entirely clear on your setup.  How many machines are
involved, where are the tunnels, and where is NAT happening?

This sounds like a problem with NAT of ICMP errors, rather than
a PPTP conntrack problem.  There have been at least 2 patches
on the list regarding NAT of the inner ICMP header.  I don't
think either have made it into standard kernels yet.  Have you
tried them?

-- 
Philip Craig     Software Engineer     http://www.SnapGear.com
philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
SnapGear  -  Custom Embedded Solutions and Security Appliances
