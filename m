From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [RFC][PATCH] ipt_expire - expiring iptables rules
Date: Sun, 12 Jun 2005 17:48:06 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506121745400.6693@yvahk01.tjqt.qr>
References: <20050610145248.GA3201@rover.pcbi.upenn.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Cardillo <dillo@seas.upenn.edu>
In-Reply-To: <20050610145248.GA3201@rover.pcbi.upenn.edu>
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


>        crude, so consider it a proof of concept.  I'm curious,
>        would others find this useful?  Has this been done?

Hm this sounds like a reverse implementation of ipt_recent.
I once wanted something like ipt_expire to add a DROP target on a specific IP 
when that IP does something "bad", and let it go away someday. However, 
ipt_recent would do almost the same afaics.



Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
