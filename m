From: Wang Jian <lark@linux.net.cn>
Subject: Re: A top 10 statistics module?
Date: Thu, 21 Apr 2005 00:14:29 +0800
Message-ID: <20050420235712.03BD.LARK@linux.net.cn>
References: <20050420200757.03A9.LARK@linux.net.cn>
	<20050420145235.GC6027@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20050420145235.GC6027@ti64.telemetry-investments.com>
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

Hi Bill Rugolsky Jr.,

Thanks for your input.

On Wed, 20 Apr 2005 10:52:35 -0400, "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com> wrote:

> On Wed, Apr 20, 2005 at 08:40:20PM +0800, Wang Jian wrote:
> > Top10 is used to monitor a while and then disabled. It could be expensive,
> > but is useful to investigate.
> > 
> > I will implement it anyway to complete the task, but before I code, I am
> > willing to listen to any one who has comment and suggestion.
> 
> To be generally useful, the table must be bounded.  That will result in
> inaccurate order statistics, but often that doesn't matter much, if the
> table is an order of magnitude or two larger than the required order
> statistic, (i.e., 100-1000 entries for estimating the top 10).
> 
> Given that the table must be bounded, there needs to be a replacement
> policy once it fills up.  The best choice of replacement strategy of
> course depends on the distribution of new entries; the problem is similar
> to that of the code table management in certain data compression algorithms.
> Heuristics and data structures tend to be somewhat intimate, as fast
> updates are required.
> 
> A common heuristic is to prioritize the entries via a scaled frequency
> that decays with a time (or packet count, etc.) scaling constant, and
> replace the lowest frequency members in the table with the new entries.
> This heuristic lends itself to being implemented with a heap-based
> priority queue whose top is the next entry to be expired.
> Complexity: O(log N)

This is the first thing appears in my mind :)

> 
> Other heuristics derive from various queuing models, the simplest
> being "move-to-front" -- every time an entry is referenced, it is moved
> to the front of the active list; entries are expired from the
> tail of the list. Complexity: O(1)

This is very easy to implement. I will try this first :)

> 
> In the distant past I've used the scaled frequency heuristic to good
> effect on long time-series data.
> 
> Regards,
> 
> 	Bill Rugolsky



-- 
  lark
