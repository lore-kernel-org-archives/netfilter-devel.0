From: Tom Eastep <teastep@shorewall.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 07:58:39 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401280758.39917.teastep@shorewall.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <20040128112419.GA11961@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>,
	Harald Welte <laforge@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <hno@marasystems.com>,
	Michal Ludvig <mludvig@suse.cz>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20040128112419.GA11961@alpha.home.local>
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

On Wednesday 28 January 2004 03:24 am, Willy Tarreau wrote:
> On Wed, Jan 28, 2004 at 11:30:00AM +0100, Harald Welte wrote:
> > > If NAT is used, ip_route_{input,output} might even return a different
> > > policy bundle.
> >
> > The question is, again: What ist the desired behaviour?  Should the
> > policy be determined on the un-NAT'ed packet or on the NAT'ed one?
>
> Harald, I believe it's important to remember that NAT is not the only usage
> of this extension. For many people seeking security (=those who install VPN
> gateways for customers), it is very important to :
>   - be able to filter what enters and leaves a tunnel
>   - be able to filter where the encapsulated packets go to/come from
>

I agree. And the 2.4 implementation of IPSEC allowed this control to be 
exercised in a natural and uniform way (the same model applied for all tunnel 
types including IPSEC).

- Unencrypted traffic is exchanged between the client and a special device.
- encrypted traffic is exchanged between the gateways.

These are separately tracked connections that obey the normal netfilter rules. 

For configured tunnels, I still believe that this is the proper model. 

Opportunistic keying OTOH probably shouldn't follow that model.

> NAT is complementary IMHO.

But there are instances where it is necessary.

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
