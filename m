From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: a question on marking packets
Date: Wed, 10 Jul 2002 00:03:33 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207100003.33502.hno@marasystems.com>
References: <03781128C7B74B4DBC27C55859C9D73809840653@es06snlnt>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Shipman, Jeffrey E" <jeshipm@sandia.gov>,
	"'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
In-Reply-To: <03781128C7B74B4DBC27C55859C9D73809840653@es06snlnt>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

mark values are unique per packet. the response packet will get a new mark 
value, initially 0..

but there is help. See the CONNMARK pactch in patch-o-matic. Adds a similar 
mark value to conntrack, allowing you to mark a connection rather than 
individual packets.

Why do you need mark values to know which packets to modify? How are you 
modifying packets, and why? Perhaps there is a better way if you describe a 
little of what you are up to doing.

Regards
Henrik Nordström
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
