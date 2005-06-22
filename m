From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: New target to control a fake network interface
Date: Wed, 22 Jun 2005 14:56:08 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506221455460.25356@yvahk01.tjqt.qr>
References: <1119319953.4109.59.camel@envy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Corey Giovanella <coreygiovanella@challenge-engineering.com>
In-Reply-To: <1119319953.4109.59.camel@envy>
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


>What I have done is written two new kernel modules: a fake network
>interface module and a new iptables target that remote controls the

NTS, there is already a fake interface module: called dummy.ko

>packet counters on the fake interface.  The fake interface itself, does
>nothing.


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
