From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: TTL patch buggy?
Date: Wed, 07 Jan 2004 15:07:22 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1073506041.16972.25.camel@jasiiitosh.nexusmgmt.com>
References: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com>
	 <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com>
	 <20040107193547.GF6629@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>, netfilter@lists.netfilter.org,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040107193547.GF6629@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-01-07 at 14:35, Harald Welte wrote:
> On Wed, Jan 07, 2004 at 02:04:36PM -0500, John A. Sullivan III wrote:
> > Thank you very much but could you please explain this a bit more.  Oskar
> > Andreasson's tutorial explicitly mentions doing this, i.e., incrementing
> > TTL and we thought it was a good idea.  We certainly want to change our
> > ways if this is dangerous.  Here is the excerpt from the tutorial:
> 
> Well, as indicated in my last emai:
> 
> 1) it is dangerous to increment the TTL
> 2) still, there are vallid uses.
> 
> In gerneral, incrementing packets heading towards your internal network
> shouldn't be a problem.  If people want to hide their internal network
> structure from traceroute, they have two options:
> 
> a) drop all packets that have a ttl < number_of_hops_in_internal_net
> b) increment the TTL by number_of_hops_in_internal_net
> 
> Both ways make sure that the TTL never expires on a router in the
> internal network.
> 
> Where 'a' would interrupt traffic, and 'b' would make sure traffic
> passes.
<snip>
Thanks to all of you for such insightful replies.  As I synthesize them,
I see some problems and a possible solution.
1) Incrementing does create the possibility of routing loops although
this is minimal for end points.
2) Dropping packets with ttl < number_of_internal_hops may be safer but
requires a knowledge of the internal environment and incurs an overhead
with every internal change.
3) sysctl seems to provide no way to simply not send ttl expired
messages
4) If the goal is simply to hide the firewall, could one just drop all
packets where ttl == 1.  These packets would never make it only the
internal network anyway; it does not require incrementing ttl and 
requires no knowledge of the internal network.  I assume that, since one
can prevent the ttl expired from being sent by incrementing, that
netfilter will grab and drop the packet before the ttl expired
notification is sent.  Is there a problem with this approach?
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
---
If you are interested in helping to develop a GPL enterprise class
VPN/Firewall/Security device management console, please visit
http://iscs.sourceforge.net 
