From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipv4options still broken (posted prev w/ no reply)...
Date: Thu, 01 Jun 2006 05:25:41 +0200
Message-ID: <447E5E35.1090304@trash.net>
References: <1149033568.27117@www.broadwayinternet.com>	<447CD93F.9070103@trash.net>
	<20060531045445.GA8333@oknodo.bof.de>	<447DA068.1090507@trash.net>
	<1149097509.6167.9.camel@mbox>	<447DE2F3.8090104@trash.net>
	<1149102130.6167.20.camel@mbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cody Tubbs <tubbs@wispdirect.com>
In-Reply-To: <1149102130.6167.20.camel@mbox>
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

Cody Tubbs wrote:
> Bottom line is, it would be nice to -j LOG these options passing through
> or attempting to be passed through a bridged firewall.  It details
> malicious activity, thus deterring that fact into a presumption that "I
> most likely have more serious problems" was blatantly absurd.

As I already said, please just send me your patch to disable or even
better fix this behaviour and I'm going to apply it. If you really want
to do something useful, please just fix the ipv4options match to be
acceptable for kernel inclusion. So far, it does stupid things like
using seperate flags for option negation and it depends on IP option
metadata provided by the IP layer, which doesn't work for bridging.
The last point BTW really is a good example why random crap from POM
shouldn't be trusted.
