From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 12:24:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128112419.GA11961@alpha.home.local>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
   Henrik Nordstrom <hno@marasystems.com>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 28, 2004 at 11:30:00AM +0100, Harald Welte wrote:
 
> > If NAT is used, ip_route_{input,output} might even return a different
> > policy bundle.
> 
> The question is, again: What ist the desired behaviour?  Should the
> policy be determined on the un-NAT'ed packet or on the NAT'ed one?

Harald, I believe it's important to remember that NAT is not the only usage
of this extension. For many people seeking security (=those who install VPN
gateways for customers), it is very important to :
  - be able to filter what enters and leaves a tunnel
  - be able to filter where the encapsulated packets go to/come from

NAT is complementary IMHO.

Regards,
Willy
