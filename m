From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 14:22:28 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401271419280.17162-100000@filer.marasystems.com>
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

> > If the packet is rerouted in POSTROUTING then this should include IPSec
> > routing. If the new route is to an IPSec SPI then it is. If not then it is
> > not.
> 
> You are talking about the first POSTROUTING, Number 3?  Then I would
> definitely agree.

I am.

> > (Gateway) -> Gateway -> (client)
> 
> This is not symmetric, despite being the exact opposite of the previous
> case.  I don't like that.  If we make it similar to the previous case,
> it would be:
> 
> 1. PREROUTING, ESP packet
> 2. INPUT, ESP packet
> 3. PREROUTING, decapsulated packet
> 4. FORWARD, decapsulated packet
> 5. POSTROUTING, decapsulated packet.

Right. My error. Thinks one thing, writes another. Brain obviously not 
fully functional today.

> > I also see it likely there needs to be some skb extensions to add the
> > requires SPI tracking information to allow rulesets a better view of
> > what is going on (optional).
> 
> yes, but let's that make step 2.  First we have to agree on the first
> step, do a decent implementation and then submit it to netdev.

Agreed.

Regards
Henrik
