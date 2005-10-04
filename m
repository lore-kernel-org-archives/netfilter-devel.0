From: Amin Azez <azez@ufomechanic.net>
Subject: Re: snat bridge routes reply packets
Date: Tue, 04 Oct 2005 11:58:51 +0100
Message-ID: <4342606B.3020508@ufomechanic.net>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>	<433BE841.2090203@ufomechanic.net>	<41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>	<Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>	<433CCCD2.9030504@rtij.nl>
	<43410C8C.7080500@ufomechanic.net>
	<Pine.LNX.4.61.0510031423060.24889@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510031423060.24889@filer.marasystems.com>
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

Henrik Nordstrom wrote:
> On Mon, 3 Oct 2005, Amin Azez wrote:
> 
>> Yes. And having saved the mac address (and physdev) it will use the
>> bridge output functions instead of the ip route functions.
> 
> 
> Saving the MAC should be sufficient. The implicit DNAT of return traffic
> in SNAT:ed connections is run in PREROUTE and should be before the
> bridge forwarding table..

Thanks for this tip. I've been working through the conntrack and natting
code again looking for the most judicious point to apply this.

There is a wiki up with my findings I'll announce in another post.

Sam
