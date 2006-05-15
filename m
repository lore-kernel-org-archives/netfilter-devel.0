From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Mon, 15 May 2006 20:49:32 +0200
Message-ID: <4468CD3C.3000908@trash.net>
References: <20060507093640.GF11191@w.ods.org>
	<egts52hm2epfu4g1b9kqkm4s9cdiv3tvt9@4ax.com>
	<20060508050748.GA11495@w.ods.org>
	<20060507.224339.48487003.davem@davemloft.net>
	<44643BFD.3040708@trash.net>
	<9a8748490605120409x3851ca4fn14fc9c52500701e4@mail.gmail.com>
	<44647280.1030602@trash.net> <446490BB.10801@ufomechanic.net>
	<44683AFF.4070200@trash.net>
	<20060515142834.GL7774@kenobi.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, marcelo@kvack.org,
	willy@w.ods.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20060515142834.GL7774@kenobi.snowman.net>
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

Stephen Frost wrote:
> * Patrick McHardy (kaber@trash.net) wrote:
> 
>>Anyway, here goes the first shot at a replacement, it should be fully
>>compatible. Comments and testing welcome.
> 
> 
> This patch didn't apply cleanly against 2.6.16; I didn't think there had
> been other changes since then.  As it was an entire replacement I just
> pulled out the '[+ ]' lines from the patch.  Hopefully this doesn't lead
> to problems in my review.


That should be fine. That patch applies on top of Jespers patch which
started this thread, which I plan to push to Dave today.

> It probably would have been better to integrate it with ipset, as I've
> mentioned previously.  Other comments:


Unfortunately we need to provide compatibility.

> recent_entry_init() appears to just look for something to delete when
> the maximum number of entries has been reached, starting from the hash
> position of the address.  The original ipt_recent, quite intentionally,
> looked for the *oldest* address to replace.  This meant that the list
> only had to be large enough to cover the number of addresses seen in a
> given time-period.  This change would mean that the list would need to
> be large enough to hold all addresses seen always, to be able to enforce
> the time-based rules ipt_recent was written for.
> 
> ie: List of 100 addresses.  Highest timeout value in the ruleset is 60
> seconds.  Average of 100 individual addresses in a 60-second timeframe.
> The old ipt_recent would correctly enforce the 60-second requirement in
> the ruleset.  With the new version, as soon as the list was full the
> next address could replace any address in the list, even if that address
> was only 15 seconds old.
> 
> One way to handle this would be to track the highest time value in the
> rulesets but as the ruleset is dynamic you could end up throwing away an
> address which would have been caught by a rule that was about to be
> added.  The old module was written with the expectation of the list
> always being full and that it would only be less-than-full shortly after
> booting.  By then only removing the oldest entry in the table for each
> new address seen the maximum amount of time possible for the given table
> size and distinct addresses seen is achieved.


I wasn't sure whether eviction was happening intentional in the old code
at all - still not able to locate the code where this happens, just
noticed that it does do eviction when I manually tried to trigger
a table overflow by adding entries through /proc. Anyway, it should
be easy to fix by keeping an additional lru list. I'll post
an updated patch soon.
