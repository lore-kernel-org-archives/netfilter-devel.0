From: jamal <hadi@cyberus.ca>
Subject: Re: tc filtering vs iptables
Date: 27 Aug 2004 16:27:54 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093638474.14190.29.camel@jzny.localdomain>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20040827201137.GB9274@ti64.telemetry-investments.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-08-27 at 16:11, Bill Rugolsky Jr. wrote:
> On Fri, Aug 27, 2004 at 02:45:24PM -0400, jamal wrote:
> > Both of them seem to be a hassle for what i need (and given the time i
> > have). hipac seems to be a 2.4.x thing and pool requires me to recompile
> > a few things (while docs look scarce). I dont have much time to get this
> > done by - when i have more time in the future i could do it.
> > 
> > Any recommendation of how i should arrange the chains?
>  
> PATRICIA tree?  Calculate the internal CIDR address/prefixes and branch
> on them.

Can you emulate a patricia tree out of chains?
Heres what i have now (posted earlier):

What a painful experience it is to install large rules.
about 20 minutes to install 16K rules. Not sure if this is
even worth pursuing anymore

---------------
256 chains:  subnet_0 .. subnet_255

In each chain, there are 256 rules specifying a host in each 
(.0 ....255).

This creates a maximum of 65536 rules with hosts from 10.1.0.0 to 
10.1.255.255.

The lookup on the rules is done only on the IPs at the end.
I am being a little unfair to tc u32 which looks up the rcp src ports as
well in the rules - hopefully, this will  compensate for lack of
iptables optimization skills on my part.
----------------

cheers,
jamal
