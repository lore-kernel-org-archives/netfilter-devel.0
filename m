From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] simplify the code to dump the conntrack table
Date: Thu, 07 Sep 2006 17:13:19 +0200
Message-ID: <4500370F.5050002@trash.net>
References: <45001B82.4000504@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45001B82.4000504@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Merge the bits to dump the conntrack table and the ones to dump and
> zero counters in a single piece of code. This patch does not change
> the default behaviour if accounting is not enabled.

Nice cleanup, thanks. And it saves me from removing the id based
dumping, which I forgot to change for the counter case :)

BTW, what about my last question regarding your early_drop patch?
