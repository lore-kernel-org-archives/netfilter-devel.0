From: Amin Azez <azez@ufomechanic.net>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 14:12:33 +0100
Message-ID: <433BE841.2090203@ufomechanic.net>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>
	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Martijn Lievaart wrote:
> Amin Azez zei:
> 
>>Henrik Nordstrom wrote:
>>
>>>But I strongly suspect your problems is not at all related to routing.
>>>It would only be routing related if your bridge does not have correct
>>>routing info for either the source or destination.
>>
>>My bridge does may not have routing for the source in many instances.
> 
> 
> Maybe a stupid remark, but if you create routes for the source to the
> existing IP where you want the packet delivered? Does that solve your
> problem?

My actual problem is that I need a bridging kernel that can be deployed
in unknown network environments and nat to a known gateway that is the
only machine guaranteed to be on the same subnet. It's not pretty.

We have created broad network aliases for the bridge so that all IP
addresses are local and roughly get the scenario you speak of, but then
we need to add static arp entries to assign the default gateway's mac to
specific known non-local ip, which is of course a worse hack than
mending snat for source-bridge scenarios.

Sam
