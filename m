From: "Shipman, Jeffrey E" <jeshipm@sandia.gov>
Subject: RE: a question on marking packets
Date: Tue, 9 Jul 2002 16:23:11 -0600
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <03781128C7B74B4DBC27C55859C9D73809840654@es06snlnt>
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

The incoming packets will fit a particular criteria
as in what port it is connecting to, what options
and flags are set, etc. The outgoing packet really
depends on what was incoming. We see what pattern
we matched as, and then we have a hash table of modifications
for the packet (just about anything can be modified)
that we'll need to perform. The trouble is making sure
we're modifying the correct outgoing packet which
is in response to the packet that came in.

Jeff Shipman - CCD
Sandia National Laboratories
(505) 844-1158 / MS-1372


-----Original Message-----
From: Henrik Nordstrom [mailto:hno@marasystems.com]
Sent: Tuesday, July 09, 2002 4:04 PM
To: Shipman, Jeffrey E; 'netfilter-devel@lists.samba.org'
Subject: Re: a question on marking packets


mark values are unique per packet. the response packet will get a new =
mark=20
value, initially 0..

but there is help. See the CONNMARK pactch in patch-o-matic. Adds a =
similar=20
mark value to conntrack, allowing you to mark a connection rather than=20
individual packets.

Why do you need mark values to know which packets to modify? How are =
you=20
modifying packets, and why? Perhaps there is a better way if you =
describe a=20
little of what you are up to doing.

Regards
Henrik Nordstr=F6m
MARA Systems AB, Sweden




Shipman, Jeffrey E wrote:
> I have a situation where I need to be able to
> mark packets on the NF_IP_LOCAL_IN hook that
> match certain patterns we will be watching
> for. This because after accept the packet and
> the response packet is generated (NF_IP_LOCAL_OUT),
> we must be able to know how to modify this packet
> depending on the results from that incoming
> packet. Does anyone have some advice how to properly
> mark these packets so we can do this? Any tips
> or direction on where to look would be most
> appreciated.
>
> TIA,
>
> Jeff Shipman - CCD
> Sandia National Laboratories
> (505) 844-1158 / MS-1372
