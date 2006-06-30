From: Patrick McHardy <kaber@trash.net>
Subject: Re: xtables Re: Hacking iptables 1.3.5 for 2.6.17
Date: Fri, 30 Jun 2006 18:37:12 +0200
Message-ID: <44A55338.8080903@trash.net>
References: <e82pqq$3es$1@sea.gmane.org>	<200606300948.k5U9mNot001866@toshiba.co.jp>	<44A50091.7070003@ufomechanic.net>	<200606301157.k5UBvJTl016149@toshiba.co.jp>	<44A51BCB.7090006@ufomechanic.net>	<44A53794.6060405@trash.net>
	<44A5496C.3030504@ufomechanic.net> <44A54C65.20906@trash.net>
	<44A55116.9080107@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44A55116.9080107@ufomechanic.net>
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

Amin Azez wrote:
> iptables -Z dsrateentries -t mangle
> 
> causes the checkentry to all be called again.
> (It just so happens I was doing that every 10 seconds)
> 
> I guess iptables -z is not as lightweight as I thought, it perhaps
> re-applies all the rules - or maybe checkentry is wrongly being called
> from -z?

I'm actually not sure how this is implemented, I guess it just
dumps the ruleset to userspace, changes counters and pumps
it back to the kernel again (which means it needs to be revalidated).
