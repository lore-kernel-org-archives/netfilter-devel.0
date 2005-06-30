From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: REDIRECT changes DST address of the packet
Date: Thu, 30 Jun 2005 13:09:30 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506301308290.3095@yvahk01.tjqt.qr>
References: <20050630072756.89120.qmail@web60820.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Venkata Narayana <mesg2nari@yahoo.com>
In-Reply-To: <20050630072756.89120.qmail@web60820.mail.yahoo.com>
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

>Hello,
> 
>My question is if I use REDIRECT action in
>NAT PREROUTING table  is it going to change the tcp
>packet DST address.
> 
>If I lose original DST address, how can I persist
>that value in that packet.

You can't really with PREROUTING (except of course, said getsockopt() call)
If you want to transparently redirect packets, you might want to use ROUTE or 
TPROXY, depending on what you really want.



Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
