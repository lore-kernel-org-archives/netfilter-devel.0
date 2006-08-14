From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 16:31:34 +0200
Message-ID: <44E08946.1040105@trash.net>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814142559.GS7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> 2006-08-14 15:34:05+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>I'm afraid I have some bad news ..
>>
>>[...]
>
> I do not completly understand you. Today a modification of ONE rule will or
> will not trigger the checkentry()/init() of ALL rules? 

Yes it will. Modification happens like this:

- dump entire table to userspace
- modify table
- send new table to kernel

_All_ matches and target and reinstantiated, since the kernel doesn't
know which rule in the currently active table corresponds to which
in the new table. When moving state out of the data shared with
userspace it will get lost during this.

> I know they did before (in 2.4) since modules i have written has code to
> workaround this. Having a low limiter like say a few packets each 5min can't
> just be reset each time we modify another unrelated rule.

Exactly.

> Latly howver it seams as it doesn't? What do you mean we are breaking with
> this patch? A match/target doesn't have to use this new data area. Just let
> don't alter them and they will continue to act aas they always done? We will
> however provide better tools for new modules (not yet in pom-ng).

Well, if nobody can use it reasonable there is no reason to introduce
it.
