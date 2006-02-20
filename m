From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] disallow multiple matches of same type
Date: Mon, 20 Feb 2006 18:38:22 +0100
Message-ID: <43F9FE8E.5050607@trash.net>
References: <20060220055421.GA10552@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060220055421.GA10552@linuxace.com>
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

Phil Oester wrote:
> In latest iptables SVN, the command:
> 
> iptables -A foo -p tcp -m multiport --dport 45,47 -m multiport --sport 45:48
> 
> ends up with mangled results of:
> 
> ... multiport sports  multiport sports  tcp spts:45:48
> 
> Since at present, iptables can only handle one match of a given type
> per rule.  The below patch makes sure we disallow more than one.
> 
> This closes bugzilla #447

I think Harald already did something in this direction. Harald?
