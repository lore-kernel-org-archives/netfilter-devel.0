From: Patrick McHardy <kaber@trash.net>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Mon, 11 Jul 2005 13:19:07 +0200
Message-ID: <42D255AB.401@trash.net>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
	<42D1608C.7040909@trash.net>
	<20050710202359.GA6874@sunbeam.de.gnumonks.org>
	<42D18912.7030306@trash.net>
	<Pine.LNX.4.61.0507111305360.20556@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0507111305360.20556@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
>>>Yes, I'm also in favour of reverting the patch.  The number of functional bugs
>>>it has caused by far outweigh the gain of save 'rmmod' without loops.
>>
>>Agreed, unfortunately. If we can't get module unload to work reliably we
>>should introduce another way to flush the conntrack table however. I'm
>>thinking of something easy like a /proc file.
> 
> But in the time that passes between echo 1 >/proc/flushme and rmmod new 
> entries could show up, if it's "just" a flush and not a flush-and-disable 
> operation.

"flush-and-disable" (should actually be disable-and-flush) can be
achieved by adding a rule to drop everything before flushing.
Its not meant to clean up before rmmod (conntrack tries to do this
itself) but to kick out old conntrack entries after ruleset changes.

Regards
Patrick
