From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Why the behavior of LOCAL OUTPUT DNAT changes?
Date: Fri, 17 Jun 2005 15:19:27 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506171449060.19385@yvahk01.tjqt.qr>
References: <1118997723.7428.2.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hellwolf Misty <hellwolf@seu.edu.cn>
In-Reply-To: <1118997723.7428.2.camel@cocteau.hellwolf-misty.org>
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


>#nc 1.2.3.4 5678&
>[3] 4662
>#
>[3]+  Exit 1                  nc 1.2.3.4 5678
>
>And why?

Looks like CONFIG_IP_NF_NAT_LOCAL is not activated.

However, beginning with 2.6.11 ..NAT_LOCAL as a #define symbol does 
not exist anymore and is always set to yes.


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
