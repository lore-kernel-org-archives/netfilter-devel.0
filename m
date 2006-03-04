From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] [CTNETLINK] Fix expectation mask dumping
Date: Sat, 04 Mar 2006 10:26:15 +0100
Message-ID: <44095D37.1030109@trash.net>
References: <44025F8A.6070302@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44025F8A.6070302@netfilter.org>
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
> This patch introduces the function ctnetlink_exp_dump_mask, that
> correctly dumps the expectation mask. Such function uses the l3num value
> from the expectation tuple that is a valid layer 3 protocol number.
> 
> The value of the l3num mask isn't dumped since it is meaningless from
> the userspace side.

Its too late for 2.6.16, I've applied incarnation n+1 to my 2.6.17 tree.
Thanks.
