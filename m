From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: fixed kernel panic when trying to find tcp option
Date: Thu, 16 Sep 2004 02:20:18 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409151720.i8FHKJAC002371@toshiba.co.jp>
References: <200409151136.i8FBajor029883@toshiba.co.jp>
	<20040915084335.6944eebe.davem@davemloft.net>
	<20040915085049.7a7d45f0.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
        yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20040915085049.7a7d45f0.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


From: "David S. Miller" <davem@davemloft.net>
Date: Wed, 15 Sep 2004 08:50:49 -0700

> On Wed, 15 Sep 2004 08:43:35 -0700
> "David S. Miller" <davem@davemloft.net> wrote:
> 
> > All callers, well there is only one, make sure optlen is
> > non-zero.
> > 
> > Here is the call site in tcp_match():
> > 
> > 	if (tcpinfo->option) {
> > 		if (th->doff * 4 < sizeof(_tcph)) {
> > 			*hotdrop = 1;
> > 			return 0;
> > 		}
> > 		if (!tcp_find_option(tcpinfo->option, skb,
> > 				     th->doff*4 - sizeof(_tcph),
> > 				     tcpinfo->invflags & IPT_TCP_INV_OPTION,
> > 				     hotdrop))
> > 			return 0;
> > 	}
> > 
> > If the optlen would be zero, second if() passes and we
> > set *hotdrop to 1 and return.
> 
> Wait, that is the bug, the condition test has an
> off-by-one error, it should read:
> 
> 		if (th->doff * 4 <= sizeof(_tcph))
> 
> I will fix this in my tree.

If you do it, all tcp packets which has no option will be dropped
in the case of adding tcp-option match rule.

For example,

Try to configure

	ip6tables -p tcp --tcp-option 2 -j LOG

and send tcp packets which has no tcp option.

With this situation, rule should not match. Then, tcp_match()
should return 0. On the other hand, if you configure

	ip6tables -p tcp ! --tcp-option 2 -j LOG

tcp_match() should return 1.

This is the reason I sent that patch.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
