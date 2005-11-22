From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH 2.4] TCP window tracking: core implementation
Date: Tue, 22 Nov 2005 17:56:31 +0100
Message-ID: <20051122165631.GA13716@alpha.home.local>
References: <43819E72.5060704@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <43819E72.5060704@tac.ch>
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

Hi Roberto,

On Mon, Nov 21, 2005 at 11:16:18AM +0100, Roberto Nibali wrote:
> Hello,
> 
> This is the core tcp window tracking patch, updated for 2.4.32 and
> enhanced with some 2.6.x fixes in the tcp state verifier. Notably the
> following two flag combinations are allowed as well:
> 
> TCP_SYN|TCP_PSH
> TCP_SYN|TCP_ACK|TCP_PSH
> 
> NOTE: This is the work of the excellent netfilter hacker Jozsef
> Kadlecsik, so all credit goes to him for the 2.4.x implementation. I
> just rediffed and backported some minor things from 2.6.x.
> 
> A former version of this patch has been in production on a dozen nodes
> for about 8 months now, and besides unmotivated DROPs invoked by
> "non-RFC-comformant" applications, it works reasonably well.

Seconded !
I've had it in production for 18 months now, handling between 1.2 and 1.8
billions of sessions a month, and it still works like a charm.

> The added
> TCP flag combinations in this patch should resolve most of the observed
> issues we've gathered from various customers over the past half year.
> 
> We'd hoped to overcome remaining "broken" applications by using the
> NOTRACK flag to a filter rule. This would allow one to have a general
> stateful packet filter with a few stateless rules for "broken"
> applications; a feature most commercial firewall suites don't offer.
> Unfortunately there is still an issue with regard to SMP and rmmod'ing
> ip_conntrack while having NOTRACK rules loaded and network traffic
> hitting NOTRACK and conntrack. Otherwise it works flawlessly. Patch will
> follow shortly.

another possibility would be to add something like a "reason" code to the
INVALID state, so that we could tell which types of invalids we still want
to let go and which ones we definitely want to block.

Cheers,
Willy
