From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Mon, 11 Jul 2005 13:06:19 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507111305360.20556@yvahk01.tjqt.qr>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
	<42D1608C.7040909@trash.net>
	<20050710202359.GA6874@sunbeam.de.gnumonks.org>
	<42D18912.7030306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42D18912.7030306@trash.net>
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

>> Yes, I'm also in favour of reverting the patch.  The number of functional bugs
>> it has caused by far outweigh the gain of save 'rmmod' without loops.
>
>Agreed, unfortunately. If we can't get module unload to work reliably we
>should introduce another way to flush the conntrack table however. I'm
>thinking of something easy like a /proc file.

But in the time that passes between echo 1 >/proc/flushme and rmmod new 
entries could show up, if it's "just" a flush and not a flush-and-disable 
operation.


Jan Engelhardt                                                               
--                                                                            
| Alphagate Systems, http://alphagate.hopto.org/
