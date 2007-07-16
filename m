From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c.
Date: Mon, 16 Jul 2007 17:31:15 +0900 (JST)
Message-ID: <200707160831.l6G8VGK0014836@toshiba.co.jp>
References: <200707141811.l6EIBQma008773@toshiba.co.jp>
	<Pine.LNX.4.64.0707142043430.25352@fbirervta.pbzchgretzou.qr>
	<469A30E4.5060608@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469A30E4.5060608@trash.net>
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


From: Patrick McHardy <kaber@trash.net>
Date: Sun, 15 Jul 2007 16:36:20 +0200

> Jan Engelhardt wrote:
> > On Jul 15 2007 03:11, Yasuyuki KOZAKAI wrote:
> > 
> >>Note: libipt_tcp handled '--syn' as '--flags SYN,RST,ACK,FIN SYN', but
> >>     libip6t_tcp handled it as '--flags SYN,RST,ACK SYN'. I keep this
> >>     difference for now.
> > 
> > 
> > Since SYN+FIN does not make much sense (unless the ipv6-tcp protocol _really_
> > allowed that), libipt_tcp's definition should be used.
> 
> 
> Agreed, that should work fine for both.

OK, I don't come up with bad impact to current user, too.
I'll fix that before applying xtables pathes.

-- Yasuyuki Kozakai
