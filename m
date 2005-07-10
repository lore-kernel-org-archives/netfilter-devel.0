From: Patrick McHardy <kaber@trash.net>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 22:46:10 +0200
Message-ID: <42D18912.7030306@trash.net>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
	<42D1608C.7040909@trash.net>
	<20050710202359.GA6874@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050710202359.GA6874@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> Yes, I'm also in favour of reverting the patch.  The number of functional bugs
> it has caused by far outweigh the gain of save 'rmmod' without loops.

Agreed, unfortunately. If we can't get module unload to work reliably we
should introduce another way to flush the conntrack table however. I'm
thinking of something easy like a /proc file.

Regards
Patrick
