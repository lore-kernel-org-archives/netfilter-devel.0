From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Wed, 17 Nov 2004 14:58:52 +1100
Message-ID: <1100663932.5176.48.camel@localhost.localdomain>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100582922.18132.34.camel@localhost.localdomain>
	<200411161538.48528.baford@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>, dank@kegel.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Ford <baford@mit.edu>
In-Reply-To: <200411161538.48528.baford@mit.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-11-16 at 15:38 -0500, Bryan Ford wrote:
> Hi Rusty,
> 
> On Tuesday 16 November 2004 00:28, Rusty Russell wrote:
> > Most NAT explanations and implementations assume that each connection
> > gets exclusive use of the port in the NAT space (exception connections
> > with same SRC already).  Unfortunately I decided that being able to
> > preserve source ports was generally more important, but this is looking
> > more questionable now.  One benefit is that we can put thousands of
> > hosts behind a single IP address, but maybe that's worth sacrificing?
> 
> I don't know much about the details of iptables or other NAT implementations, 
> but from a high-level viewpoint it seems to me that implementing hairpin 
> translation should only require facilities that must already be implemented 
> somehow in any port-restricted cone NAT.  (Symmetric NAT is completely 
> P2P-unfriendly by definition and thus moot for our purposes, and other types 
> of cone NAT just have more permissive firewall policies.)  In particular, a 
> port-restricted cone must somehow implement two different kinds of "tables", 
> and be able to perform two correspondingly different kinds of "lookups":
> 
> 1. First, the NAT has to have some kind of "session table" or "connection 
> table" keyed on the IP addresses and port numbers of _both_ ends of the 
> connection, whether the endpoint is internal or external, which endpoint(s) 
> need to be translated, and how.  Packets are filtered on a 
> connection-by-connection basis using this table (which is what makes the NAT 
> port-restricted rather than full cone or something else), and the common-case 
> translation path only uses this table.  In the common case, one endpoint of a 
> connection is on each side of the NAT, and only one endpoint gets translated 
> - but for hairpin translation, the NAT must have enough flexibility to allow 
> _both_ endpoints of a connection to be on the same side of the NAT, and hence 
> for both endpoints to be translated.  

Indeed, we don't really have the concept of sides inherent in our NAT
implementation, but re-routing a packet out the same interface after
modification is indeed possible (note that we also suppress ICMP
redirect which normally gets sent when this happens).

We use a "conntrack" hash table of 5-tuples
(PROTO-SRCIP:SPT=>DSTIP:DPT); each connection has two of them
(symmetrical in the case of no NAT).

> 2. Second, the NAT has to have a "port table" or "mapping table" of some kind, 
> which records the association between the NAT's own public ports and the 
> private endpoints (private IP, private port pairs) they currently represent.  
> The important thing is that the port table is mapped by only _one_ of the 
> communication endpoints - the internal endpoint - and thus there can be many 
> active sessions corresponding to a single port table entry.  When an internal 
> node initiates a new outgoing session, causing a "miss" in the NAT's session 
> table, the NAT must look up the internal (source) endpoint in its port table 
> to see if it's already allocated a public (translated) port at the NAT's IP 
> address, and if so, reuse that existing public port as it sets up the new 
> session.  Again, this "port table" functionality must somehow already be 
> implemented by any cone NAT, independent of the hairpin translation issue; a 
> NAT that doesn't do this is a symmetric NAT (or worse), and thus is 
> completely broken from a P2P perspective.  Hairpin translation just relates 
> to the special case where a new "outgoing" session is directed at one of the 
> NAT's own public (translated) ports, in which case the NAT must set up a 
> session in which both endpoints are translated.

This is where we have problems.  We do not have the concept of "public
ports".  Our NAT algorithm for new connections is as follows.  It runs
twice, once for source NAT and once for destination, but we can ignore
that and concentrate on source mapping here:

For connection/packet PROTO-SRCIP:SPT=>DSTIP:DPT:

1) Look up user-defined rules to decide what range to NAT this to
(default is <SRCIP:anyport> if no rule).  We support ranges.

2) Look up a a "bysource" hash table of (PROTO, SRCIP, SPT).  If another
connection from the same endpoint is found, and the same mapping gives a
connection within the range, try that.  If that mapping creates a unique
reply (ie. there's no PROTO-DSTIP:DPT=>mapped SRCIP:mapped SPT in our
"conntrack" hash table), we're done.

3) Try a mapping which doesn't change SPT, ie. just changing the SRCIP
to each IP address in the range.  If that mapping creates a unique
reply, we're done.

4) Try altering the SPT as well (we attempt to keep high ports high,
etc).  If this fails, we drop the connection.

Consider two machines A and B being NATed through N to servers Sa, Sb
and Sc respectively (rule says NAT source to N):

	A:45000 -> Sa:80  <=>  N:45000 -> Sa:80 (rule 3)
	B:45000 -> Sb:80  <=>  N:45000 -> Sb:80 (rule 3)
	A:45000 -> Sc:80  <=>  N:45000 -> Sc:80 (rule 2)
	B:45000 -> Sc:80  <=>  N:45001 -> Sc:80 (rule 2 clash, rule 4)

The reason I implemented NAT this way (back in 1998/99) was that not
disturbing port numbers avoided breaking a number of protocols.  It also
turns out that overloading the ports also allows more connections than
65535 * number of IP addresses.

I hope that explains?  We're going to have to think hard about changing
to a port reservation architecture if we really want the hairpin
feature.

Cheers,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
