From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH]: fixed kernel panic when trying to find tcp option
Date: Wed, 15 Sep 2004 08:50:49 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040915085049.7a7d45f0.davem@davemloft.net>
References: <200409151136.i8FBajor029883@toshiba.co.jp>
	<20040915084335.6944eebe.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
        yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20040915084335.6944eebe.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 15 Sep 2004 08:43:35 -0700
"David S. Miller" <davem@davemloft.net> wrote:

> All callers, well there is only one, make sure optlen is
> non-zero.
> 
> Here is the call site in tcp_match():
> 
> 	if (tcpinfo->option) {
> 		if (th->doff * 4 < sizeof(_tcph)) {
> 			*hotdrop = 1;
> 			return 0;
> 		}
> 		if (!tcp_find_option(tcpinfo->option, skb,
> 				     th->doff*4 - sizeof(_tcph),
> 				     tcpinfo->invflags & IPT_TCP_INV_OPTION,
> 				     hotdrop))
> 			return 0;
> 	}
> 
> If the optlen would be zero, second if() passes and we
> set *hotdrop to 1 and return.

Wait, that is the bug, the condition test has an
off-by-one error, it should read:

		if (th->doff * 4 <= sizeof(_tcph))

I will fix this in my tree.
