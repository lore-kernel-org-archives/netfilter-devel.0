From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Subject: Re: [PATCH -mm] lib/ts_fsm.c: constify structs
Date: Fri, 1 Sep 2006 16:09:04 +0200
Message-ID: <20060901140904.GA4324@rhlx01.fht-esslingen.de>
References: <20060831182734.GA26228@rhlx01.fht-esslingen.de>
	<20060901113137.GI3470@postel.suug.ch>
	<20060901125158.GA17752@rhlx01.fht-esslingen.de>
	<20060901135016.GJ3470@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>, netfilter-devel@lists.netfilter.org
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20060901135016.GJ3470@postel.suug.ch>
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

Hi,

On Fri, Sep 01, 2006 at 03:50:16PM +0200, Thomas Graf wrote:
> Right, not sure what I was thinking. ;) However, gcc probably already
> put it into rodata for being static and only referenced for reading
> so it probably doesn't make any difference.

I didn't verify it with this particular patch, but I'm 99.9% certain
that it isn't in rodata, since I've checked it with many other constify
patches before (objdump -x).

Andreas Mohr
