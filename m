From: Tom Eastep <teastep@shorewall.net>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 08:11:36 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401270811.36973.teastep@shorewall.net>
References: <20040124082252.GA19035@alpha.home.local> <20040124092721.GA19140@alpha.home.local> <20040127103917.GC11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Michal Ludvig <mludvig@suse.cz>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040127103917.GC11761@sunbeam.de.gnumonks.org>
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

On Tuesday 27 January 2004 02:39 am, Harald Welte wrote:

>
> My proposal:
> From conntracks view (and thus from NAT view), there (shuld be?) two
> seperate connections for any given to-be-encapsulated packet:
>
> - the payload connection (tcp/udp/whatever)
> 	- conntrack entry created at PREROUTING
> 	- conntrack entry confirmed (put in hash) at XXX
> - the AH/ESP connection
> 	- conntrack entry created at YYY
> 	- conntrack entry confirmed at POSTROUTING
>
> To do this, somewhen between esp_output() is called and the beginning of
> the modification of the packet payload, we need to call
> nf_hook(POST_ROUTING).  This way, conntrack would be able to put the
> connection in the hash, and people can do SNAT-like operations in
> nat->POSTROUTING.  We could even pass a dummy output device structure
> with an interface name "esp" so people can SNAT everything heading for
> esp encapsulation.

I like this proposal. I assume that on input, payload packets would also have 
this dummy device as their input device? And on output that payload packets 
would have "esp" as their output device in the FORWARD and OUTPUT hooks as 
well?

I would also like to register my vote for having the AH/ESP packets go through 
INPUT and OUTPUT. This would allow Shorewall to treat IPSEC in the same way 
as it does all other tunnel types:

a) the payload connection uses a dedicated device ("esp" in this case)
b) the encapsulated traffic originates at the gateway on output and is 
directed to the gateway on input.

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
