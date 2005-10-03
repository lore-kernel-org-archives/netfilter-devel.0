From: Amin Azez <azez@ufomechanic.net>
Subject: Re: snat bridge routes reply packets
Date: Mon, 03 Oct 2005 11:48:44 +0100
Message-ID: <43410C8C.7080500@ufomechanic.net>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>	<433BE841.2090203@ufomechanic.net>	<41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>
	<Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>
	<433CCCD2.9030504@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <433CCCD2.9030504@rtij.nl>
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

>
> Ah, now I see. The unknown network mesh uses multiple routers which
> are unknown to the bridge, so the bridge does not know where to route
> the return packets, although it could know if it saved the mac the
> original packet came from. Right?

Yes. And having saved the mac address (and physdev) it will use the
bridge output functions instead of the ip route functions.

Sam
