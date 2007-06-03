From: Andrew Beverley <andy@andybev.com>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Sun, 03 Jun 2007 19:32:06 +0100
Message-ID: <1180895526.6601.44.camel@andybev>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
	<1180890022.6601.6.camel@andybev>
	<Pine.LNX.4.61.0706031914120.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706031914120.10578@yvahk01.tjqt.qr>
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

On Sun, 2007-06-03 at 19:18 +0200, Jan Engelhardt wrote:
> On Jun 3 2007 18:00, Andrew Beverley wrote:
> >On Sun, 2007-06-03 at 13:12 +0200, Jan Engelhardt wrote:
> >> Adds the connlimit match that has been in POM-NG for a long time.
> >> 
> >>     *	works with 2.6.22, xtables'ified and all that
> >> 
> >>     *	will request nf_conntrack_ipv4 upon load
> >> 	(otherwise it hotdrops every packet - a glitch that goes back
> >> 	to at least 2.6.20.2)
> >
> >Excellent! This has been at the back of my mind for a while.
> >
> >Is there any chance of getting UDP flows added as well as TCP
> >connections?
> 
> I dare to say it's easy. The real problem is rather, that UDP is
> connectionless, so for one, connlimit can, by definition of the word
> 'connectionless', not apply to UDP, though it is technically
> possible.

Understood.

> Second, because UDP "connections" "fly" (timeout after 30
> seconds), just spewing one UDP packet out may kill another connection
> (e.g. if you use connlimit in conjunction with DROP or REJECT).

I see what you mean, although I personally would use this with an IPSET
target, and I would argue it is the responsibility of the administrator
to ensure it is used correctly.

> What's more, UDP packets can be easily forged, much more than TCP, so
> anyone on the same subtree (not subnet, because that's something
> different) can send a bogus UDP packet and stop your connections from
> working.

I didn't know that, but I doubt anyone where I would use it would be
able to do that :-)

> Let's see how to implement UDP counting...

The alternative, as I see it, is to adapt hashlimit to have an option to
limit by number of different concurrent streams to different port
numbers (but same source/destination IP address). However, I personally
think it would sit better in connlimit, even if UDP is not a connection
by strict definition.

Is it something you would consider, or shall I look at it myself?

With regards to Patrick's comment, IIRC this was one of the points he
originally raised.

Regards,

Andy Beverley
