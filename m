From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: fixed kernel panic when trying to find tcp option
Date: Thu, 16 Sep 2004 02:31:01 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409151731.i8FHV2Cv005059@toshiba.co.jp>
References: <20040915085049.7a7d45f0.davem@davemloft.net>
	<200409151720.i8FHKJAC002371@toshiba.co.jp>
	<20040915102236.6100ea14.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
        yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20040915102236.6100ea14.davem@davemloft.net>
	<200409151720.i8FHKJAC002371@toshiba.co.jp>
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
Date: Wed, 15 Sep 2004 10:22:36 -0700

> On Thu, 16 Sep 2004 02:20:18 +0900 (JST)
> Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> wrote:
> 
> > If you do it, all tcp packets which has no option will be dropped
> > in the case of adding tcp-option match rule.
> 
> You are right.
> 
> Did your patch return "invert" from tcp_find_option() when optlen
> is zero?  I deleted it, sorry.

Yes. Because

From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Thu, 16 Sep 2004 02:20:18 +0900 (JST)

> should return 0. On the other hand, if you configure
> 
> 	ip6tables -p tcp ! --tcp-option 2 -j LOG
> 
> tcp_match() should return 1.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
