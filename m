From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 15:12:49 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401271457370.17979-100000@filer.marasystems.com>
References: <20040127130739.GR11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040127130739.GR11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Jan 2004, Harald Welte wrote:

> > My view of where hooks should be for IPSec:
> > 
> > (Client) -> Gateway -> (Gateway)
> > 
> >   1. PREROUTING, original client packet
> >   2. FORWARD, original client packet. Destination the IPSec SPI
> >   3. POSTROUTING, original client packet. Destination the IPSec SPI
> >   4. OUTPUT, ESP packet. Preferably with some preserved information about 
> > the original packet attached.
> >   5. POSTROUTING, ESP packet.
> 
> I agree to all but 4.    My proposal was PREROUTING, yours OUTPUT.

It is very hard to distinguis the different IPSec cases here. Save of
adding yet another hook for encapsulated and to be decapsulated packets
OUTPUT(/INPUT) is the closest match in my opinion. The packet it sees is
the packet from this IPSec endpoint to the other IPSec endpoint on the
IPSec SPI connection between the two.

The packet inside may be a forwarded packet or locally generated, it's all 
the same. The ESP is an exchange between the two endpoints  OUTPUT -> 
POSTROUTING <-net-> PREROUTING -> INPUT

Use of PREROUTING introduces a completely new semantic unless you want to 
also call FORWARD on these packets which I do not think is appropriate.


If introducing new hooks then we would have

   XXXX -> POSTROUTING <-net-> PREROUTING -> YYYY

if XXXX and YYYY can be the same hook name in this case or not I'll leave
to the core team to ponder upon?

What exacly is the semantical problem of using OUTPUT/INPUT?  In my view
the ESP/AH packet is locally generated, and belongs to a connection with a
local endpoint.

Regards
Henrik
