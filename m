From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [LARTC] Opinions about pom/patches [was: iptables 1.3.7, kernel
 2.6.19, ROUTE and Layer7 issues]
Date: Wed, 31 Jan 2007 03:58:51 +0100
Message-ID: <45C005EB.1040704@netfilter.org>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>	<457E6997.1050001@trash.net>	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>	<457FBBFD.6060009@trash.net>	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>	<45A48087.8090200@trash.net>	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>	<54696.195.55.244.106.1168435275.squirrel@www.arcoscom.com>
	<1169746884.4253.51.camel@andybev.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	linux@arcoscom.com
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1169746884.4253.51.camel@andybev.localdomain>
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

Andrew Beverley wrote:
> I would also like to see as many of the POM included in the stable
> kernel. It's a bit of a headache to patch in what I want each time I
> update the kernel, and on a fresh system I have to install CURL just to
> update POM just to add connlimit to the kernel...

IMHO, patching kernels to add some certain shiny-feature(TM) is
generally a bad idea if you don't know how the patch internally works or
if you can't directly get support from the author of such patch.
Moreover, if the applied patchset is large, this can become a problem
since, at some point, you could report unreproducible bugs probably
introduced by one of your patches, thus annoying developers that are
worried about fixing bugs in the stable kernel branch asap. So, I would
suggest people to be more conservative when applying patches.

Anyway, if you think that some certain patch is stable enough to push it
forward to mainline, encourage the author to push it forward. Probably
there is a reason why he decided not to do that.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
