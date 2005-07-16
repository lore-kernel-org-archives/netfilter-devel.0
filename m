From: Patrick McHardy <kaber@trash.net>
Subject: Re: Owner match misnaming
Date: Sat, 16 Jul 2005 18:29:08 +0200
Message-ID: <42D935D4.9060907@trash.net>
References: <Pine.LNX.4.61.0507111401170.14796@yvahk01.tjqt.qr>	<datno8$gft$1@sea.gmane.org>	<Pine.LNX.4.61.0507112044190.17095@yvahk01.tjqt.qr>
	<20050712091749.GY16728@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050712091749.GY16728@sunbeam.de.gnumonks.org>
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

Harald Welte schrieb:
> On Mon, Jul 11, 2005 at 08:44:32PM +0200, Jan Engelhardt wrote:
> 
>>Any way to fix it?
> 
> no. The filesystem data structures are just not supposed to be called
> from any in_interrupt() context.  We should make this an FAQ entry.

Actually there are a couple of patches in -mm for lockless fd lookup.
Probably still doesn't work from softirq context, but I'm haveing a
look now.

Regards
Patrick
