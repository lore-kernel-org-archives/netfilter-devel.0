From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: a question on marking packets
Date: Wed, 10 Jul 2002 00:42:15 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207100042.15339.hno@marasystems.com>
References: <03781128C7B74B4DBC27C55859C9D73809840654@es06snlnt>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Shipman, Jeffrey E" <jeshipm@sandia.gov>,
	"'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
In-Reply-To: <03781128C7B74B4DBC27C55859C9D73809840654@es06snlnt>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I assume you by incoming/outgoing packets refer to incoming and response 
packets.. not single packets coming in to a router on one interface and going 
out on another after possibly having some kind of transformation applied to 
them..

Will be damn hard...

a) As you seem to be messing around with the packets outside of the netfilter 
NAT framework you cannot use conntrack.. (I assume these modifications may 
include addressing/port modifications).

b) As incoming packets has not yet been processed by the TCP/IP stack you 
don't know which socket these will get accepted by, so your cannot base any 
desisions on the local socket..

c) You cannot use nfmark, as nfmark is per-packet, not at all connection 
related.. A response pakcket is a new packet, and will have a new nfmark 
value, not related to the incoming packet..

d) You cannot use ToS, as this is not reflected by the TCP/IP kernel.. and is 
generally to small for this kind of things anyway, indended for other uses.

Basically you would need to implement your own connection tracking based on 
the packets you have sent to the TCP/IP kernel, and invert the tuple to match 
possible response packets.


It is a little bit hard to theorise on this on a packet level without knowing 
what kind of packets we are talking about here or the application/purpose on 
why you are modifying the packets. Does this involve TCP/UDP/whatever? Do you 
have control of the application that generates the response packets? And many 
other similar questions..

Regards
Henrik Nordström
MARA Systems AB, Sweden


Shipman, Jeffrey E wrote:
> The incoming packets will fit a particular criteria
> as in what port it is connecting to, what options
> and flags are set, etc. The outgoing packet really
> depends on what was incoming. We see what pattern
> we matched as, and then we have a hash table of modifications
> for the packet (just about anything can be modified)
> that we'll need to perform. The trouble is making sure
> we're modifying the correct outgoing packet which
> is in response to the packet that came in.
>
> Jeff Shipman - CCD
> Sandia National Laboratories
> (505) 844-1158 / MS-1372
