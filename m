From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter/ipsec packet flow
Date: Thu, 15 Apr 2004 05:58:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407E0855.2080705@trash.net>
References: <20040414173749.GA6170@obs.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ivan Mitev <imitev@obs.bg>
In-Reply-To: <20040414173749.GA6170@obs.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ivan Mitev wrote:
> hi
> 
> sorry if that sounds like a stupid question; but let's ask, as more people
> should be concerned by that when they'll migrate their freeswan/2.4 to 2.6's
> ipsec... 
> 
> 1- is this 2.6 ipsec packet flow "freezed" ? 
> 
>             [incoming packet]
>                     |<-----------------. 
>                     v                  |
>                PREROUTING              |
>     dest!=local?  /  \  dest==local?   |
>                 /      \               |
>          FORWARD        LOCAL_IN       |
>              |            |            |
>              |      (ipsec?decrypt:nop)|
>              |            |   \        / dest!=local ?
>              |            |    `------'
>              v            v  dest==local ?
> 
> (excellent ascii-art stolen from willy tarreau in
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014464.html
> in a discussion about patrick's new netfilter/ipsec patches)
> 
> because for those of us that need to begin to migrate to 2.6 and that have
> very complex traffic control done with mangle/fwmark, it's important to know
> where ipsec packets will be seen twice (encrypted/de-encrypted). (and where
> they won't be seen, eg. encrypted ESP/AH pkts in OUTPUT/filter ?) 

This doesn't represent the packet flow accurately, it's basically like
this (I put X's at the positions where the packet would enter/leave the
ipsec devices with freeswan)

INPUT:
1. -> (encrypted) PRE_ROUTING -> LOCAL_IN -> (X plain) PRE_ROUTING -> 
LOCAL_IN
2. -> (encrypted) PRE_ROUTING -> LOCAL_IN -> (X plain) PRE_ROUTING -> 
FORWARD

OUTPUT:
1. -> (plain) FORWARD   -> POST_ROUTING -> (X encrypted) LOCAL_OUT -> 
POST_ROUTING
2. -> (plain) LOCAL_OUT -> POST_ROUTING -> (X encrypted) LOCAL_OUT -> 
POST_ROUTING

> 2- does the ipsec policy match by patrick McHardy is considered as the
> "standard" way of matching de-encrypted packets ? (eg. compared to the earlier
> fwmark hack), or are there other ways ?

There is no "standard way" yet, but the policy match is meant to become
the standard way.

> ...or do some netfilter core developers have other design ideas ? (i'm talking
> only of the packet flow here; not the internals/implementation)
> 

The packet flow (hook-wise) was discussed here a couple of month ago,
IIRC everyone agreed on this order.

> question for patrick: does the last patch in pom-ng change the design above ?
> ("The input patch is replaced with a new version which...")
> (http://lists.netfilter.org/pipermail/netfilter-devel/2004-April/014977.html) 

It doesn't change the order in which hooks are traversed,
it only changes the packet flow through the network stack.

> another thing (sorry for the lengthy post), can someone put patrick's xfig pic
> somewhere (or send it to me); i don't manage to "unbase64" it.
> (http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014469.html)

It's not correct anymore with the new input patch. It's not important
from a user's perspective anyway, the order in which hooks are traversed
is what matters.

> oh, and btw let me know if i can help with testing - i have a full 2.6 network
> testbed here ...

Sure, the most useful would be if you try to replicate your 2.4 setup
with 2.6 and see if everything works. Otherwise just testing the patches
and reporting problems is also helpful.

Regards
Patrick

> 
> thanks !
> 
> ivan
