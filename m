From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: -m limit problem
Date: Tue, 21 Sep 2004 12:06:26 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409211204030.28425@filer.marasystems.com>
References: <1e0e01c49f56$7f61b490$523e000a@sirijus>
	<Pine.LNX.4.61.0409202329180.18874@filer.marasystems.com>
	<1ec901c49fb3$e5a9cf50$523e000a@sirijus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Darius Tribandis <sirijus@kobra.ktu.lt>
In-Reply-To: <1ec901c49fb3$e5a9cf50$523e000a@sirijus>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Sep 2004, Darius Tribandis wrote:

> Now i understand. I thing that counter resets just after i reload specific
> rule, but if it resets each time i modify any of rules =- than it must by
> trated as bug, because it lacks all funcionality of iptables limit match
> module.

It is when you touch any rule within the same table (nat in your case).

No it is not a bug, it is a limitation of iptables.

> is it posible to owercome this "future" ? ;)

Only by redesign of iptables to allow the limit match to save it's 
counters in the user copy of the table, not the first CPU copy.

The pkttables approach worked on by Harald will solve this problem as it 
does not reload the whole table on every change.

Regards
Henrik
