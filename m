From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH 7/5] [CTNETLINK] Fix expectation mask dumping
Date: Thu, 02 Mar 2006 20:23:58 +0100
Message-ID: <4407464E.70003@eurodev.net>
References: <44025F8A.6070302@netfilter.org> <440744A2.3000307@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <440744A2.3000307@eurodev.net>
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
> This patch applies to 2.6.16.
> 
> This patch introduces the function ctnetlink_exp_dump_mask, that
> correctly dumps the expectation mask. Such function uses the l3num value
> from the expectation tuple that is a valid layer 3 protocol number.
> 
> The value of the l3num mask isn't dumped since it is meaningless from
> the userspace side.

This patch is crap, I'll resend later... sometimes I'm stupid.

--
Pablo
