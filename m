From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Owner match misnaming
Date: Sat, 16 Jul 2005 18:45:40 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507161844530.3810@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0507111401170.14796@yvahk01.tjqt.qr>
	<datno8$gft$1@sea.gmane.org>
	<Pine.LNX.4.61.0507112044190.17095@yvahk01.tjqt.qr>
	<20050712091749.GY16728@sunbeam.de.gnumonks.org>
	<42D935D4.9060907@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42D935D4.9060907@trash.net>
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

>> > Any way to fix it?
>> 
>> no. The filesystem data structures are just not supposed to be called
>> from any in_interrupt() context.  We should make this an FAQ entry.
>
> Actually there are a couple of patches in -mm for lockless fd lookup.
> Probably still doesn't work from softirq context, but I'm haveing a
> look now.

What exactly needs to be locked? Right now, I only see the tasklist lock and 
the file list lock being taken, but no lock on individual fds.



Jan Engelhardt
-- 
