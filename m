From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: Any way of knowing a packet's been defragmented
Date: Mon, 23 Aug 2004 10:11:46 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040823101146.4597eb53@dell_ss3.pdx.osdl.net>
References: <W5101410375481091705422@asteria.telenet-ops.be>
	<Pine.LNX.4.61.0408051507530.405@filer.marasystems.com>
	<20040819114604.GQ3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
   Bart De Schuymer
 <bdschuym@pandora.be>,
   netfilter-devel
 <netfilter-devel@lists.netfilter.org>,
   bridge <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819114604.GQ3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Aug 2004 13:46:04 +0200
Harald Welte <laforge@netfilter.org> wrote:

> On Thu, Aug 05, 2004 at 03:10:42PM +0200, Henrik Nordstrom wrote:
> > On Thu, 5 Aug 2004 bdschuym@pandora.be wrote:
> > 
> > >As Stephen explained, bridge ports of the same bridge device no longer 
> > >need to have the same mtu. So the bridge code needs to drop packets 
> > >(ARP, IP, whatever) that will be too long for the output port.
> > 
> > Eh.. I do not claim to be a bridge guru, but won't such bridge cause 
> > serious havoc on the network much like PMTU blackholes does?
> 
> Nobody ever replied to that question.
> 
> Bart, Stephen, what is your take on this?   How was this resolved?

Yes, it would create PMTU black holes, so it shouldn't be recommended
but it is allowed by the standard and might be useful in some specialized
environments. In other words, I can't think why anyone would want to do
it but maybe they will so why stop them?
