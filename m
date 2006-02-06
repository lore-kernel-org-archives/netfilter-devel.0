From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Fix expectation mask dumping, take #2
Date: Mon, 06 Feb 2006 11:15:18 +0900 (JST)
Message-ID: <200602060215.k162FJth023563@toshiba.co.jp>
References: <200602011335.k11DZHwj018072@toshiba.co.jp>
	<43E15615.2070508@netfilter.org> <43E6904E.9020306@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <43E6904E.9020306@netfilter.org>
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


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 06 Feb 2006 00:54:54 +0100

> Hi,
> 
> @Patrick: this patch fixes the problem that `[NETFILTER 03/14]:
> nf_conntrack: check address family when finding protocol module` works
> around. So I think that such patch needs to be reverted :(

Please don't revert that. I've been thinking that both your and
his patch are necessary. Even if your patch fixes oops triggered by
nfctnetlink, other module might have same problem future.

I think he aim of 2 patches is different. His patch fixes the root
of oops. Your patch fixes dumping expectation mask.

BTW, ah, his patch includes unlikely(). But fortunately,
your patch looks that it makes unnecessary to remove it and
I expect that it will be applied to net-2.6 tree. Great!

-- Yasuyuki Kozakai
