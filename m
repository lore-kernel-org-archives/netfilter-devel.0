From: Bryan Ford <baford@mit.edu>
Subject: Re: New draft document on nat / traversal / hole punching (with Dan
	Kegel)
Date: Tue, 16 Nov 2004 15:38:48 -0500
Message-ID: <200411161538.48528.baford@mit.edu>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100582922.18132.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>, dank@kegel.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1100582922.18132.34.camel@localhost.localdomain>
Content-Disposition: inline
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

Hi Rusty,

On Tuesday 16 November 2004 00:28, Rusty Russell wrote:
> Most NAT explanations and implementations assume that each connection
> gets exclusive use of the port in the NAT space (exception connections
> with same SRC already).  Unfortunately I decided that being able to
> preserve source ports was generally more important, but this is looking
> more questionable now.  One benefit is that we can put thousands of
> hosts behind a single IP address, but maybe that's worth sacrificing?

I don't know much about the details of iptables or other NAT implementations, 
but from a high-level viewpoint it seems to me that implementing hairpin 
translation should only require facilities that must already be implemented 
somehow in any port-restricted cone NAT.  (Symmetric NAT is completely 
P2P-unfriendly by definition and thus moot for our purposes, and other types 
of cone NAT just have more permissive firewall policies.)  In particular, a 
port-restricted cone must somehow implement two different kinds of "tables", 
and be able to perform two correspondingly different kinds of "lookups":

1. First, the NAT has to have some kind of "session table" or "connection 
table" keyed on the IP addresses and port numbers of _both_ ends of the 
connection, whether the endpoint is internal or external, which endpoint(s) 
need to be translated, and how.  Packets are filtered on a 
connection-by-connection basis using this table (which is what makes the NAT 
port-restricted rather than full cone or something else), and the common-case 
translation path only uses this table.  In the common case, one endpoint of a 
connection is on each side of the NAT, and only one endpoint gets translated 
- but for hairpin translation, the NAT must have enough flexibility to allow 
_both_ endpoints of a connection to be on the same side of the NAT, and hence 
for both endpoints to be translated.  

2. Second, the NAT has to have a "port table" or "mapping table" of some kind, 
which records the association between the NAT's own public ports and the 
private endpoints (private IP, private port pairs) they currently represent.  
The important thing is that the port table is mapped by only _one_ of the 
communication endpoints - the internal endpoint - and thus there can be many 
active sessions corresponding to a single port table entry.  When an internal 
node initiates a new outgoing session, causing a "miss" in the NAT's session 
table, the NAT must look up the internal (source) endpoint in its port table 
to see if it's already allocated a public (translated) port at the NAT's IP 
address, and if so, reuse that existing public port as it sets up the new 
session.  Again, this "port table" functionality must somehow already be 
implemented by any cone NAT, independent of the hairpin translation issue; a 
NAT that doesn't do this is a symmetric NAT (or worse), and thus is 
completely broken from a P2P perspective.  Hairpin translation just relates 
to the special case where a new "outgoing" session is directed at one of the 
NAT's own public (translated) ports, in which case the NAT must set up a 
session in which both endpoints are translated.

Again, I don't know the details of iptables, and I know this high-level 
viewpoint probably doesn't line up very closely with how iptables currently 
does translation.  The important point, however, is that hairpin translation 
"in theory" should require just a slight generalization of the hash tables or 
other lookup facilities that need to be implemented anyway in any 
port-restricted cone NAT.  Does this make sense?

> PS.  Even before our "lookup previous connections from same source" fix,
> we usually got the desired "cone" behaviour because we try to preserve
> source ports.  So in practice that bug doesn't bite very hard.

By trying to preserve source ports, I assume you mean that if a client on the 
internal network uses source port number 1234 for a connection, the NAT first 
tries to allocate port number 1234 at its IP address as the public port for 
that connection?  That's a sensible feature, but it of course has very 
limited benefit as soon as multiple hosts behind the same NAT make outgoing 
connections from the same source port number.  For P2P-friendliness the 
important requirement is that the NAT preserves the _identity_ of an 
internal-to-external translation across multiple sessions originating from 
the same internal port, regardless of whether it can preserve the actual 
_port number_ (which is often impossible).  I assume that by your "lookup 
previous connections from same source" fix you meant the latter, 
identity-preserving functionality.  In which case you should in theory be 
able to use approximately the same lookup functionality needed for this fix 
to implement hairpin translation.  Unless I'm missing something important, 
which of course is quite possible. :)

Anyway, I hope this helps.

Cheers,
Bryan
