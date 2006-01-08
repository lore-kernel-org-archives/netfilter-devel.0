From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 09 Jan 2006 00:01:24 +0100
Message-ID: <43C199C4.2080902@trash.net>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
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
> I'm planning to submit x_tables eatly next week, so this is assumed to
> be the final review phase.
> 
> So if you have any issues, please comment now before it's too late :)

OK, here are a couple of more comments.

- xt_owner:

Unfortunately I think the owner match can't be converted to x_tables
without breaking compatiblity with ip6_tables. The ip6_tables version
never supported command and sid matching, so the structures differ in
size and layout.

- xt_realm:

IPv6 doesn't use tclassid, so its currently useless for ip6_tables.
Maybe keep it as an x_tables match and just don't register for
ip6_tables.

- xt_conntrack:

The existing match is unfixable IPv4 specific because of address sizes,
NAT support, ..., so it also shouldn't register for IPv6. An
IPv6-capable version probably needs to duplicate most of the code,
but I'd keep it as x_tables match anyway.

- assertion while adding rules

I get this assertion while adding rules:
ASSERT: CPU #0, filter comefrom(ecbaf05c) = 2

I assume its known because the place responsible for setting comefrom
is surrounded by CONFIG_FIXME :) I'm going to look into fixing it.
