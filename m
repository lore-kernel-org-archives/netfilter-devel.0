From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Sun, 08 Jan 2006 23:12:32 +0100
Message-ID: <43C18E50.5060908@trash.net>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<43C18D77.501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <43C18D77.501@trash.net>
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

Patrick McHardy wrote:
> For now just one question, I need some time to read through the patch:
> 
>  static int
>  icmp6_checkentry(const char *tablename,
> -          const struct ip6t_ip6 *ipv6,
> +          const void *entry,
> 
> Why do you change struct ip6t_ip6 * to void * for IPv6 matches,
> but keep ipt_ip for IPv4 matches? Shouldn't the old API be
> unaffected by moving some matches and targets to x_tables?

OK, I answered the question myself. I somehow misread and missed
that IPv4 matches are changed too and ipt_register_match is just
a wrapper for xt_tables. Now I like the patch even better :)
