From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Missed any patches? [PATCH] expectation timeouts
Date: Sat, 11 Jun 2005 19:23:39 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506111922060.22504@yvahk01.tjqt.qr>
References: <42AB1577.5040006@trash.net> <20050611170739.GA5018@linuxace.com>
	<42AB1B05.2060509@trash.net>
	<Pine.LNX.4.61.0506111913540.22504@yvahk01.tjqt.qr>
	<42AB1D48.3020505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AB1D48.3020505@trash.net>
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

>> Is there any chance that all of POMng will get updated? Most of the patches 
>> still address a 2.6.<10 kernel. I have not tested if they apply correctly (I 
>> don't need them ... yet), but if they don't, rediff could be wise.
>
>Updated how? Which patches are you talking about?

Heh, you got me.

NAT reservations, for example, cannot be applied to a 2.6.11, because the 
expect code changed.

The ACCOUNT directory in today's (well, yesterday 20050610) POMng tree has a 
linux.patch with this header:
--- kernel-2.4.25/include/linux/netfilter_ipv4/ip_tables.h      Mon Apr 12 
Not exactly 2.6.x at all :)



Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
