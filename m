From: "Shipman, Jeffrey E" <jeshipm@sandia.gov>
Subject: RE: a question on marking packets
Date: Wed, 10 Jul 2002 07:50:49 -0600
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <03781128C7B74B4DBC27C55859C9D73809840655@es06snlnt>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>,
	"'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

You are correct in saying that the packets will be coming
in and leaving on the same interface. I am dealing with TCP/UDP
packets and the addresses/ports will not be changed. The things
I will be changing are possibly:

Sequence Numbers, Flags, Options, Don't Fragment bit,
window sizes, Type of Service, UDP data, etc.

Pretty much anything in the IP/TCP/UDP layers that don't
involve changing the source or destination addresses/ports. :)

Essentially what we are doing are emulating the behavior
of other OSs based on signatures we've already gathered.
This requires modifying or dropping the outgoing packets
that are in response to particular incoming packets.

I don't have control of the applications while my
module is being used inside the kernel.

I was thinking we'd probably have to come up with our
own solution, but I was hoping Netfilter had something
to support this situation.=20

Either way, thank you so much for your help!

Jeff Shipman - CCD
Sandia National Laboratories
(505) 844-1158 / MS-1372


-----Original Message-----
From: Henrik Nordstrom [mailto:hno@marasystems.com]
Sent: Tuesday, July 09, 2002 4:42 PM
To: Shipman, Jeffrey E; 'netfilter-devel@lists.samba.org'
Subject: Re: a question on marking packets


I assume you by incoming/outgoing packets refer to incoming and =
response=20
packets.. not single packets coming in to a router on one interface and
going=20
out on another after possibly having some kind of transformation =
applied to=20
them..

Will be damn hard...

a) As you seem to be messing around with the packets outside of the
netfilter=20
NAT framework you cannot use conntrack.. (I assume these modifications =
may=20
include addressing/port modifications).

b) As incoming packets has not yet been processed by the TCP/IP stack =
you=20
don't know which socket these will get accepted by, so your cannot base =
any=20
desisions on the local socket..

c) You cannot use nfmark, as nfmark is per-packet, not at all =
connection=20
related.. A response pakcket is a new packet, and will have a new =
nfmark=20
value, not related to the incoming packet..

d) You cannot use ToS, as this is not reflected by the TCP/IP kernel.. =
and
is=20
generally to small for this kind of things anyway, indended for other =
uses.

Basically you would need to implement your own connection tracking =
based on=20
the packets you have sent to the TCP/IP kernel, and invert the tuple to
match=20
possible response packets.


It is a little bit hard to theorise on this on a packet level without
knowing=20
what kind of packets we are talking about here or the =
application/purpose on

why you are modifying the packets. Does this involve TCP/UDP/whatever? =
Do
you=20
have control of the application that generates the response packets? =
And
many=20
other similar questions..

Regards
Henrik Nordstr=F6m
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
