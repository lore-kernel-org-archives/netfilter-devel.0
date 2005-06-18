From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: 2.6.12: connection tracking broken?
Date: Sat, 18 Jun 2005 16:57:49 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506181656250.20828@yvahk01.tjqt.qr>
References: <20050618124359.39052.qmail@web52901.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chris Rankin <rankincj@yahoo.com>
In-Reply-To: <20050618124359.39052.qmail@web52901.mail.yahoo.com>
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

>Hi,
>
>I have just tried upgrading my firewall to 2.6.12, but neither of the following rules in my
>FORWARD table was allowing return traffic:

You forget about INPUT and OUTPUT. If you drop everything in INPUT, there's 
nothing to FORWARD.

> 1109  814K ACCEPT     all  --  ppp0   br0     anywhere             anywhere         ctstate
>RELATED,ESTABLISHED
>  11M   13G ACCEPT     all  --  ppp0   br0     anywhere             anywhere         state
>RELATED,ESTABLISHED
>
>I have currently returned to using 2.6.11.11, where the identical configuration works fine. br0 is
>a bridge device containing two e100 devices, and ppp0 is my PPPoE DSL link. I am using iptables
>1.3.1.


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
