From: Tom Eastep <teastep@shorewall.net>
Subject: Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 07:36:29 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401280736.29799.teastep@shorewall.net>
References: <20040124082252.GA19035@alpha.home.local> <200401270811.36973.teastep@shorewall.net> <20040127204546.GZ11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>,
	Henrik Nordstrom <hno@marasystems.com>,
	Michal Ludvig <mludvig@suse.cz>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040127204546.GZ11761@sunbeam.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 27 January 2004 12:45 pm, Harald Welte wrote:
> > > To do this, somewhen between esp_output() is called and the beginning
> > > of the modification of the packet payload, we need to call
> > > nf_hook(POST_ROUTING).  This way, conntrack would be able to put the
> > > connection in the hash, and people can do SNAT-like operations in
> > > nat->POSTROUTING.  We could even pass a dummy output device structure
> > > with an interface name "esp" so people can SNAT everything heading for
> > > esp encapsulation.
> >
> > I like this proposal.
>
> Great :)
>
> > I assume that on input, payload packets would also have this dummy
> > device as their input device?
>
> sure, makes sense.
>
> > And on output that payload packets would have "esp" as their output
> > device in the FORWARD and OUTPUT hooks as well?
>
> no, that's way more difficult.  I'm not sure whether it can be done at
> all (without adding rediculous kludges to the code).

Bummer -- I'm trying to avoid equally ridiculous kludges in my own code :-)

>
> > I would also like to register my vote for having the AH/ESP packets go
> > through INPUT and OUTPUT. This would allow Shorewall to treat IPSEC in
> > the same way as it does all other tunnel types:
>
> Mh.  Let's say we stick with the INPUT/OUTPUT chains for now.
>
> However, I would like to introduce new netfilter hooks.  At least for
> the beginning (due to lack of better ideas), I'm going to register the
> INPUT/OUTPUT chains with those new hooks.
>
> the idea of the new hooks is, that in reality they are at different
> locations in the stack.  And at some point we might have some module
> that is only interested in xfrm'ed packets.
>

I understand.

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
