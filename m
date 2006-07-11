From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Tue, 11 Jul 2006 10:28:13 +0200
Message-ID: <44B3611D.6030902@trash.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net> <44B22434.3050801@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44B22434.3050801@ufomechanic.net>
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

Amin Azez wrote:
> This leads me to suggest addition of ipt_marks instead of ipt_mark
> 
> Not only is "the" mark overutilized but the problems of managing free
> bit-ranges in iptables/ebtables (if/when ebtables supports masking) will
> also be too troublesome to bear.
> 
> I re-suggest adding multiple on-demand storage slots to conntrack (and
> now also skb's), for storing labelled cookie-type values tor checking
> later, by iptables or ebtables or any-other.
> 
> My I copy my latest RFC attempt here (still a work in progress)
> 
> [...]
> 
> Do these overheads waste any advantage in merely trying to save space in
> the conntrack?
> 
> Do this neatly solve the problem of passing state between tables?
> 
> Do these overheads waste any advantage in using the conntrack as a
> caching mechanism?

I would prefer to see some code before commenting. My gut feeling
is that it is overly complex. Have you looked at Rusty's ct_extend?
