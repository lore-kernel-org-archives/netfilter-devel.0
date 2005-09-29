From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 14:49:11 +0200 (CEST)
Message-ID: <20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>
	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>
	<433BDBD7.6030609@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <433BDBD7.6030609@ufomechanic.net>
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

Amin Azez zei:
> Henrik Nordstrom wrote:
>> But I strongly suspect your problems is not at all related to routing.
>> It would only be routing related if your bridge does not have correct
>> routing info for either the source or destination.
>
> My bridge does may not have routing for the source in many instances.

Maybe a stupid remark, but if you create routes for the source to the
existing IP where you want the packet delivered? Does that solve your
problem?

M4
