From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] TCP window tracking over-window handling
Date: Mon, 7 Feb 2005 08:25:53 -0800
Message-ID: <20050207162553.GA8788@linuxace.com>
References: <20050128234334.GA20713@linuxace.com>
	<Pine.LNX.4.58.0502021017590.24272@blackhole.kfki.hu>
	<20050202160009.GB30465@linuxace.com>
	<Pine.LNX.4.58.0502022139470.25538@blackhole.kfki.hu>
	<Pine.LNX.4.58.0502071036410.31326@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502071036410.31326@blackhole.kfki.hu>
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

On Mon, Feb 07, 2005 at 11:32:27AM +0100, Jozsef Kadlecsik wrote:
> Actually the real governing rule is that packets must intersect the
> window: there may be segments before the left or after the right edge.
> Moreover, the receivers may keep the segments over the window for later
> processing, and your recording just proves it does happen.
> 
> So we can either follow the article and drop the assumption about
> receivers trimming the segments over the window or adjust the code to
> meet RFC793 and real life traffic patterns. I believe the second
> approach would be preferable because then conntrack wouldn't drop
> legitimate packets and there were less false alarms.
> 
> The first attached patch (your version with some modifications to
> complete it) implements the first variation.
> 
> The second one aims to implement the more RFC-compatible window tracking
> code. It is slightly tested using the first window tracking tests by
> nfsim. I'm working on writing more tests to cover as many cases as
> possible.

Both look good, but would it be best to merge the less intrusive alternative
#1 for 2.6.11, then update to alternative #2 early in 2.6.12 so it can receive
more testing?

Phil
